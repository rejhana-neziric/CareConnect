using CareConnect.Services.Database;
using MapsterMapper;
using CareConnect.Models.Requests;


namespace CareConnect.Services.AppointmentStateMachine
{
    public class ConfirmedAppointmentState : BaseAppointmentState
    {
        public ConfirmedAppointmentState(CareConnectContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override Models.Responses.Appointment Cancel(int id)
        {
            var set = _context.Set<Appointment>();

            var entity = set.Find(id);

            if (entity == null) return null;

            entity.StateMachine = "Canceled";

            _context.SaveChanges();

            return _mapper.Map<Models.Responses.Appointment>(entity);
        }

        public override Models.Responses.Appointment Start(int id)
        {
            var set = _context.Set<Appointment>();

            var entity = set.Find(id);
           
            if (entity == null) return null;

            entity.StateMachine = "Started";

            _context.SaveChanges();

            return _mapper.Map<Models.Responses.Appointment>(entity);
        }

        public override Models.Responses.Appointment Reschedule(int id, AppointmentRescheduleRequest request)
        {
            var set = _context.Set<Appointment>();

            var entity = set.Find(id);

            if (entity == null) return null;

            _mapper.Map(entity, request);   

            entity.StateMachine = "Rescheduled";

            _context.SaveChanges();

            return _mapper.Map<Models.Responses.Appointment>(entity);
        }

        public override List<string> AllowedActions(Appointment entity)
        {
            return new List<string>() { nameof(Cancel), nameof(Start), nameof(Reschedule) };
        }
    }
}
