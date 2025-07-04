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
    public class AttendanceStatusController : BaseController<AttendanceStatus, AttendanceStatusSearchObject, AttendanceStatusAdditionalData>
    {
        //private readonly IAttendanceStatusService _service;

        public AttendanceStatusController(IAttendanceStatusService service) : base(service)
        {
            //_service = service;
        }
    }
}
