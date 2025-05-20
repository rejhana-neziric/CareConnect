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
    }
}
