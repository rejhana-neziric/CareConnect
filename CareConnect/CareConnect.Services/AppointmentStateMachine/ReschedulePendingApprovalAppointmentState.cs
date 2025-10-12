using CareConnect.Models.Requests;
using CareConnect.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareConnect.Services.AppointmentStateMachine
{
    public class ReschedulePendingApprovalAppointmentState : BaseAppointmentState
    {
        public ReschedulePendingApprovalAppointmentState(CareConnectContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override Models.Responses.Appointment Reschedule(int id)
        {
            var set = _context.Set<Appointment>();

            var entity = set.Find(id);

            if (entity == null) return null;

            entity.StateMachine = "Rescheduled";

            _context.SaveChanges();

            return _mapper.Map<Models.Responses.Appointment>(entity);
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

        public override List<string> AllowedActions(Appointment entity)
        {
            return new List<string>() { nameof(Reschedule), nameof(Cancel) };
        }
    }
}
