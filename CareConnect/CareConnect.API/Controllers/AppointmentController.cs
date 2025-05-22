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
    public class AppointmentController : BaseCRUDController<Appointment, AppointmentSearchObject, AppointmentAdditionalData, AppointmentInsertRequest, AppointmentUpdateRequest>
    {
        public AppointmentController(IAppointmentService service) : base(service) { }

        [HttpPut("{id}/cancel")]
        [PermissionAuthorize("Cancel")]
        public Appointment Cancel(int id)
        {
            return (_service as IAppointmentService)!.Cancel(id); 
        }

        [HttpPut("{id}/confirm")]
        [PermissionAuthorize("Confirm")]
        public Appointment Confirm(int id)
        {
            return (_service as IAppointmentService)!.Confirm(id);
        }

        [HttpPut("{id}/start")]
        [PermissionAuthorize("Start")]
        public Appointment Start(int id)
        {
            return (_service as IAppointmentService)!.Start(id);
        }

        [HttpPut("{id}/complete")]
        [PermissionAuthorize("Complete")]
        public Appointment Complete(int id)
        {
            return (_service as IAppointmentService)!.Complete(id);
        }

        [HttpPut("{id}/reschedule")]
        [PermissionAuthorize("Reschedule")]
        public Appointment Reschedule(int id, AppointmentRescheduleRequest request)
        {
            return (_service as IAppointmentService)!.Reschedule(id, request);
        }

        [HttpGet("{id}/allowedActions")]
        [PermissionAuthorize("AllowedActions")]
        public List<string> AllowedActions(int id)
        {
            return (_service as IAppointmentService)!.AllowedActions(id);
        }
    }
}
