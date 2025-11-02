using CareConnect.API.Filters;
using CareConnect.Models.Requests;
using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;
using CareConnect.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace CareConnect.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ServiceTypeController : BaseCRUDController<ServiceType, ServiceTypeSearchObject, BaseAdditionalSearchRequestData, ServiceTypeInsertRequest, ServiceTypeUpdateRequest>
    {
        public ServiceTypeController(IServiceTypeService service) : base(service) { }
    }
}
