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
    [AllowAnonymous]
    public class AttendanceStatusController : BaseCRUDController<AttendanceStatus, AttendanceStatusSearchObject, AttendanceStatusAdditionalData, AttendanceStatusUpsertRequest, AttendanceStatusUpsertRequest>
    {

        public AttendanceStatusController(IAttendanceStatusService service) : base(service)
        {

        }
    }
}
