using CareConnect.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareConnect.Services.WorkshopStateMachine
{
    public class CanceledWorkshopState : BaseWorkshopState
    {
        public CanceledWorkshopState(CareConnectContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override List<string> AllowedActions(Workshop entity)
        {
            return new List<string>() { };
        }
    }
}
