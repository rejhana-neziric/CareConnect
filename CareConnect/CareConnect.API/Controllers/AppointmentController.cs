using CareConnect.Models.Requests;
using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;
using CareConnect.Services;
using Microsoft.AspNetCore.Mvc;

namespace CareConnect.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class AppointmentController : BaseCRUDController<Appointment, AppointmentSearchObject, AppointmentAdditionalData, AppointmentInsertRequest, AppointmentUpdateRequest>
    {
        public AppointmentController(IAppointmentService service) : base(service) { }
    }
}
