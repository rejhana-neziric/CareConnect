using CareConnect.API.Filters;
using CareConnect.Models.Enums;
using CareConnect.Models.Requests;
using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;
using CareConnect.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace CareConnect.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class WorkshopController : BaseCRUDController<Workshop, WorkshopSearchObject, WorkshopAdditionalData, WorkshopInsertRequest, WorkshopUpdateRequest>
    {
        public WorkshopController(IWorkshopService service) : base(service) { }

        [HttpPut("{id}/cancel")]
        [PermissionAuthorize("Cancel")]
        public Workshop Cancel(int id)
        {
            return (_service as IWorkshopService)!.Cancel(id);
        }

        [HttpPut("{id}/publish")]
        [PermissionAuthorize("Publish")]
        public Workshop Publish(int id)
        {
            return (_service as IWorkshopService)!.Publish(id);
        }

        [HttpPut("{id}/close")]
        [PermissionAuthorize("Close")]
        public Workshop Close(int id)
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
        [PermissionAuthorize("GetWorkshopEnrollmentStatus")]
        public async Task<IActionResult> GetWorkshopEnrollmentStatus([FromQuery] int clientId, [FromRoute] int workshopId, [FromQuery] int? childId = null)
        {

            var isEnrolled = await (_service as IWorkshopService)!.IsEnrolledInWorkshopAsync(clientId, childId, workshopId);
            return Ok(new { isEnrolled });
        }
    }
}
