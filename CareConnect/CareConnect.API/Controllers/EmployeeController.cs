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
    public class EmployeeController : BaseCRUDController<Employee, EmployeeSearchObject, EmployeeAdditionalData, EmployeeInsertRequest, EmployeeUpdateRequest>
    {
        public EmployeeController(IEmployeeService service) : base(service) { }

        [HttpGet("statistics")]
        [PermissionAuthorize("GetStatistics")]
        public EmployeeStatistics GetStatistics()
        {
            return (_service as EmployeeService).GetStatistics();    
        }

        [HttpPost("{employeeId}/availabilty")]
        [PermissionAuthorize("CreateEmployeeAvailability")]
        public Models.Responses.Employee CreateEmployeeAvailability(int employeeId, List<EmployeeAvailabilityInsertRequest> availability)
        {
            return (_service as EmployeeService).CreateEmployeeAvailability(employeeId, availability);
        }

        [HttpPatch("{employeeId}/availabilty")]
        [PermissionAuthorize("UpdateEmployeeAvailability")]
        public Models.Responses.Employee UpdateEmployeeAvailability(int employeeId, [FromBody]EmployeeAvailabilityChanges availability)
        {
            return (_service as EmployeeService).UpdateEmployeeAvailability(employeeId, availability);
        }
    }
}
