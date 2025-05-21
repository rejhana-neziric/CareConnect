using CareConnect.Services.Database;
using MapsterMapper;

namespace CareConnect.Services.AppointmentStateMachine
{
    public class StartedAppointmentService : BaseAppointmentState
    {
        public StartedAppointmentService(CareConnectContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override Models.Responses.Appointment Complete(int id)
        {
            var set = _context.Set<Appointment>();

            var entity = set.Find(id);

            if (entity == null) return null;

            entity.StateMachine = "Completed";

            _context.SaveChanges();

            return _mapper.Map<Models.Responses.Appointment>(entity);
        }

        public override List<string> AllowedActions(Appointment entity)
        {
            return new List<string>() { nameof(Complete) };
        }
    }
}
