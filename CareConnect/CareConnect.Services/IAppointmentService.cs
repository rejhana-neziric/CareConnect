using CareConnect.Models.Requests;
using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;
using CareConnect.Services.AppointmentStateMachine;

namespace CareConnect.Services
{
    public interface IAppointmentService : ICRUDService<Appointment, AppointmentSearchObject, AppointmentAdditionalData, AppointmentInsertRequest, AppointmentUpdateRequest>
    {
        public Appointment Cancel(int id);

        public Appointment Confirm(int id);

        public Appointment Start(int id);

        public Appointment Complete(int id);

        public Appointment Reschedule(int id);

        public Appointment RescheduleRequest(int id);

        public Appointment ReschedulePendingApprove(int id, AppointmentRescheduleRequest request); 

        public List<string> AllowedActions(int id);
    }
}
