using CareConnect.API.Filters;
using CareConnect.Models.Requests;
using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;
using CareConnect.Services;
using Microsoft.AspNetCore.Mvc;

namespace CareConnect.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ReviewController : BaseCRUDController<Review, ReviewSearchObject, ReviewAdditionalData, ReviewInsertRequest, ReviewUpdateRequest>
    {
        public ReviewController(IReviewService service) : base(service) { }

        [HttpPatch("{id}/visibility")]
        [PermissionAuthorize("ChangeVisibility")]
        public Review ChangeVisibility(int id)
        {
            return (_service as ReviewService)!.ChangeVisibility(id);
        }

        [HttpGet("average")]
        [PermissionAuthorize("GetAverage")]
        public double GetAverage(int? employeeId)
        {
            return (_service as ReviewService)!.GetAverage(employeeId);
        }
    }
}
