using CareConnect.Models.Requests;
using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;
using CareConnect.Services;
using Microsoft.AspNetCore.Mvc;

namespace CareConnect.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ChildController : BaseCRUDController<Child, ChildSearchObject, ChildAdditionalData, ChildInsertRequest, ChildUpdateRequest>
    {
        public ChildController(IChildService service) : base(service) { }
    }
}