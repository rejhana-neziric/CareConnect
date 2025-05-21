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
    public class InitialAppointmentState : BaseAppointmentState
    {
        public InitialAppointmentState(CareConnectContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override Models.Responses.Appointment Insert(AppointmentInsertRequest request)
        {
            var set = _context.Set<Appointment>();

            var entity = _mapper.Map<Appointment>(request);

            entity.StateMachine = "Scheduled";

            set.Add(entity);

            _context.SaveChanges();

            return _mapper.Map<Models.Responses.Appointment>(entity);
        }

        public override List<string> AllowedActions(Appointment entity)
        {
            return new List<string>() { nameof(Insert) };
        }

    }
}
