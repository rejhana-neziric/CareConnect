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
    public class RescheduleRequestedAppointmentState : BaseAppointmentState
    {
        public RescheduleRequestedAppointmentState(CareConnectContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override Models.Responses.Appointment ReschedulePendingApprove(int id, AppointmentRescheduleRequest request)
        {
            var set = _context.Set<Appointment>();

            var entity = set.Find(id);

            if (entity == null) return null;

            if(request.EmployeeAvailabilityId != null) entity.EmployeeAvailabilityId = request.EmployeeAvailabilityId.Value;
            if(request.Date != null) entity.Date = request.Date.Value;

            entity.StateMachine = "ReschedulePendingApproval";

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
            return new List<string>() { nameof(ReschedulePendingApprove), nameof(Cancel) };
        }
    }
}
