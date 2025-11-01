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
    [AllowAnonymous]
    [Route("[controller]")]
    public class EmployeeController : BaseCRUDController<Employee, EmployeeSearchObject, EmployeeAdditionalData, EmployeeInsertRequest, EmployeeUpdateRequest>
    {
        public EmployeeController(IEmployeeService service) : base(service) { }

        [HttpGet("basic")]
        [PermissionAuthorize("GetBasic")]
        public async Task<IActionResult> GetBasicList()
        {
            var search = new EmployeeSearchObject();    
            search.AdditionalData = new EmployeeAdditionalData() { IsUserIncluded = true};   
            var employees = (_service as EmployeeService)!.Get(search).ResultList;
            return Ok(employees.Select(e => new { e.User.UserId, e.User.FirstName, e.User.LastName}));
        }

        [HttpGet("statistics")]
        [PermissionAuthorize("GetStatistics")]
        public EmployeeStatistics GetStatistics()
        {
            return (_service as EmployeeService).GetStatistics();    
        }

        [HttpGet("{employeeId}/availability")]
        [PermissionAuthorize("GetEmployeeAvailability")]
        public List<EmployeeAvailability> GetEmployeeAvailability(int employeeId, [FromQuery]  DateTime? date = null)
        {
            return (_service as EmployeeService).GetEmployeeAvailability(employeeId, date);
        }

        [HttpPost("{employeeId}/availability")]
        [PermissionAuthorize("CreateEmployeeAvailability")]
        public Models.Responses.Employee CreateEmployeeAvailability(int employeeId, List<EmployeeAvailabilityInsertRequest> availability)
        {
            return (_service as EmployeeService).CreateEmployeeAvailability(employeeId, availability);
        }

        [HttpPatch("{employeeId}/availability")]
        [PermissionAuthorize("UpdateEmployeeAvailability")]
        public Models.Responses.Employee UpdateEmployeeAvailability(int employeeId, [FromBody]EmployeeAvailabilityChanges availability)
        {
            return (_service as EmployeeService).UpdateEmployeeAvailability(employeeId, availability);
        }
    }
}
