using CareConnect.Models.Requests;
using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;
using CareConnect.Services;
using Microsoft.AspNetCore.Mvc;

namespace CareConnect.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class EmployeePayHistoryController : BaseCRUDController<EmployeePayHistory, EmployeePayHistorySearchObject, EmployeePayHistoryAdditionalData, EmployeePayHistoryInsertRequest, EmployeePayHistoryUpdateRequest>
    {
        public EmployeePayHistoryController(IEmployeePayHistoryService service) : base(service) { }
    }
}
