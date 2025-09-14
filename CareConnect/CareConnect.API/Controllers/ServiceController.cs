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
    public class ServiceController : BaseCRUDController<Service, ServiceSearchObject, ServiceAdditionalData, ServiceInsertRequest, ServiceUpdateRequest>
    {
        public ServiceController(IServiceService service) : base(service) { }

        [HttpGet("statistics")]
        [PermissionAuthorize("GetStatistics")]
        public ServiceStatistics GetStatistics()
        {
            return (_service as ServiceService).GetStatistics();
        }

        [HttpGet("{serviceId}/employees")]
        [PermissionAuthorize("GetEmployeesForService")]
        public List<Models.Responses.Employee> GetEmployeesForService(int serviceId)
        { 
            return (_service as ServiceService).GetEmployeesForService(serviceId);
        }
    }
}
