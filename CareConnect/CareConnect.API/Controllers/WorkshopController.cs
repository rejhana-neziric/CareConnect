using CareConnect.API.Filters;
using CareConnect.Models.Enums;
using CareConnect.Models.Requests;
using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;
using CareConnect.Services;
using CareConnect.Services.Database;
using CareConnect.Services.WorkshopML;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;

namespace CareConnect.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class WorkshopController : BaseCRUDController<Models.Responses.Workshop, WorkshopSearchObject, WorkshopAdditionalData, WorkshopInsertRequest, WorkshopUpdateRequest>
    {
        private readonly CareConnectContext _context;

        private readonly IWorkshopMLService _mlService;


        public WorkshopController(IWorkshopService service, IWorkshopMLService mLService, CareConnectContext context) : base(service) 
        {
            _context = context;
            _mlService = mLService; 
        }

        [HttpPut("{id}/cancel")]
        [PermissionAuthorize("Cancel")]
        public Models.Responses.Workshop Cancel(int id)
        {
            return (_service as IWorkshopService)!.Cancel(id);
        }

        [HttpPut("{id}/publish")]
        [PermissionAuthorize("Publish")]
        public Models.Responses.Workshop Publish(int id)
        {
            return (_service as IWorkshopService)!.Publish(id);
        }

        [HttpPut("{id}/close")]
        [PermissionAuthorize("Close")]
        public Models.Responses.Workshop Close(int id)
        {
            return (_service as IWorkshopService)!.Close(id);
        }

        [HttpGet("{id}/allowedActions")]
        [PermissionAuthorize("AllowedActions")]
        public List<string> AllowedActions(int id)
        {
            return (_service as IWorkshopService)!.AllowedActions(id);
        }

        [HttpGet("statistics")]
        [PermissionAuthorize("GetStatistics")]
        public WorkshopStatistics GetStatistics()
        {
            return (_service as IWorkshopService)!.GetStatistics();
        }

        [HttpPost("enroll")]
        [PermissionAuthorize("Enroll")]
        public async Task<IActionResult> Enroll([FromBody] EnrollmentRequest request)
        {
            try
            {
                bool success = false;

                success = await (_service as IWorkshopService)!.EnrollInWorkshopAsync(request.ClientId, request.ChildId, request.WorkshopId, request.PaymentIntentId);

                if (success)
                {
                    return Ok(new { message = "Successfully enrolled/booked" });
                }
                else
                {
                    return BadRequest(new { error = "Failed to enroll/book. Item may be full, already booked, or payment not verified." });
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { error = "Internal server error" });
            }
        }

        [HttpGet("{workshopId}/status")]
        [Authorize] // [PermissionAuthorize("GetWorkshopEnrollmentStatus")]
        public async Task<IActionResult> GetWorkshopEnrollmentStatus([FromQuery] int clientId, [FromRoute] int workshopId, [FromQuery] int? childId = null)
        {

            var isEnrolled = await (_service as IWorkshopService)!.IsEnrolledInWorkshopAsync(clientId, childId, workshopId);
            return Ok(new { isEnrolled });
        }

        [HttpPost("train")]
        [PermissionAuthorize("TrainModel")]
        public async Task<IActionResult> TrainModel()
        {
            try
            {
                var completedWorkshops = await _context.Workshops
                    .Where(w => w.Date <= DateTime.Now && w.Status != "Canceled" && w.Participants.HasValue && w.Participants > 0)
                    .OrderBy(w => w.Date)
                    .ToListAsync();

                if (completedWorkshops.Count < 10) 
                {
                    return BadRequest(new
                    {
                        message = $"Not enough data to train. Need at least 10 completed workshops, found {completedWorkshops.Count}"
                    });
                }

                _mlService.TrainModel(completedWorkshops);

                var metrics = _mlService.EvaluateModel(completedWorkshops.TakeLast(completedWorkshops.Count / 5).ToList());

                double Sanitize(double value)
                {
                    if (double.IsNaN(value) || double.IsInfinity(value))
                        return 0.0;
                    return value;
                }

                return Ok(new
                {
                    message = "Model trained successfully",
                    workshopsUsed = completedWorkshops.Count,
                    metrics = metrics == null ? null : new
                    {
                        rSquared = Sanitize(metrics.RSquared),
                        rootMeanSquaredError = Sanitize(metrics.RootMeanSquaredError),
                        meanAbsoluteError = Sanitize(metrics.MeanAbsoluteError)
                    }
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = ex.Message });
            }
        }

        [HttpPost("predict")]
        [PermissionAuthorize("PredictForNewWorkshop")]
        public async Task<IActionResult> PredictForNewWorkshop([FromBody] WorkshopInsertRequest workshop)
        {
            try
            {
                if (!_mlService.IsModelTrained())
                {
                    await TrainModel(); 
                }

                var prediction = _mlService.PredictParticipants(workshop);

                if (float.IsInfinity(prediction.PredictedParticipants) || float.IsNaN(prediction.PredictedParticipants))
                {
                    prediction.PredictedParticipants = 0;
                }

                double? utilizationPercentage = null;

                if (workshop.MaxParticipants.HasValue && workshop.MaxParticipants.Value > 0)
                {
                    utilizationPercentage = Math.Round(
                        (prediction.PredictedParticipants / workshop.MaxParticipants.Value) * 100, 2
                    );

                    if (double.IsInfinity(utilizationPercentage.Value) || double.IsNaN(utilizationPercentage.Value))
                    {
                        utilizationPercentage = null;
                    }
                }

                return Ok(new
                {
                    predictedParticipants = Math.Round(prediction.PredictedParticipants),
                    maxParticipants = workshop.MaxParticipants,
                    utilizationPercentage,
                    recommendation = GetRecommendation(prediction.PredictedParticipants, workshop.MaxParticipants)
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = ex.Message });
            }
        }

        private string GetRecommendation(float predictedParticipants, int? maxParticipants)
        {
            if (!maxParticipants.HasValue) return "Consider setting a maximum participant limit";

            var utilizationRate = predictedParticipants / maxParticipants.Value;

            if (utilizationRate >= 0.9)
                return "High demand expected! Consider increasing capacity or adding another session.";
            else if (utilizationRate >= 0.7)
                return "Good attendance expected. Workshop capacity is well-sized.";
            else if (utilizationRate >= 0.5)
                return "Moderate attendance expected. Consider promotional activities.";
            else
                return "Low attendance predicted. Consider changing the time, date, or promoting more actively.";
        }
    }
}
