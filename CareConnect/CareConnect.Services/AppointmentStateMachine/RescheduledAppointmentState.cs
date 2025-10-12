using CareConnect.Models.Messages;
using CareConnect.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace CareConnect.Services.AppointmentStateMachine
{
    public class RescheduledAppointmentState : BaseAppointmentState
    {
        private readonly IRabbitMqService _rabbitMqService;


        public RescheduledAppointmentState(CareConnectContext context, IMapper mapper, IServiceProvider serviceProvider, IRabbitMqService rabbitMqService) : base(context, mapper, serviceProvider)
        {
            _rabbitMqService = rabbitMqService;
        }

        public override Models.Responses.Appointment Cancel(int id)
        {
            var set = _context.Set<Appointment>();

            var entity = set.Find(id);

            if (entity == null) return null;

            var oldState = entity.StateMachine; 

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

        public override List<string> AllowedActions(Appointment entity)
        {
            return new List<string>() { nameof(Cancel), nameof(Start) };
        }
    }
}
