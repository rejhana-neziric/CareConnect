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
    }
}
