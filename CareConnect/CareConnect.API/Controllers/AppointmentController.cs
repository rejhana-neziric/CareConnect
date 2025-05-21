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

        [HttpPut("{id}/cancel")]
        public Appointment Cancel(int id)
        {
            return (_service as IAppointmentService).Cancel(id); 
        }

        [HttpPut("{id}/confirm")]
        public Appointment Confirm(int id)
        {
            return (_service as IAppointmentService).Confirm(id);
        }

        [HttpPut("{id}/start")]
        public Appointment Start(int id)
        {
            return (_service as IAppointmentService).Start(id);
        }

        [HttpPut("{id}/complete")]
        public Appointment Complete(int id)
        {
            return (_service as IAppointmentService).Complete(id);
        }

        [HttpPut("{id}/reschedule")]
        public Appointment Reschedule(int id, AppointmentRescheduleRequest request)
        {
            return (_service as IAppointmentService).Reschedule(id, request);
        }

        [HttpGet("{id}/allowedActions")]
        public List<string> AllowedActions(int id)
        {
            return (_service as IAppointmentService).AllowedActions(id);
        }
    }
}
