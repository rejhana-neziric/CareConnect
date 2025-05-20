using CareConnect.Models.Requests;
using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;
using CareConnect.Services;
using Microsoft.AspNetCore.Mvc;

namespace CareConnect.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ServiceController : BaseCRUDController<Service, ServiceSearchObject, ServiceAdditionalData, ServiceInsertRequest, ServiceUpdateRequest>
    {
        public ServiceController(IServiceService service) : base(service) { }
    }
}
