using CareConnect.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareConnect.Services.AppointmentStateMachine
{
    public class CanceledAppointmentState : BaseAppointmentState
    {
        public CanceledAppointmentState(CareConnectContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override List<string> AllowedActions(Appointment entity)
        {
            return new List<string>() { };
        }
    }
}
