using CareConnect.Models.Messages;
using CareConnect.Models.Requests;
using CareConnect.Services.Database;
using EasyNetQ;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareConnect.Services.WorkshopStateMachine
{
    public class InitialWorkshopState : BaseWorkshopState
    {
        public InitialWorkshopState(CareConnectContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override Models.Responses.Workshop Insert(WorkshopInsertRequest request)
        {
            var set = _context.Set<Workshop>();

            var entity = _mapper.Map<Workshop>(request);

            entity.Status = "Draft";

            set.Add(entity);

            _context.SaveChanges();

            return _mapper.Map<Models.Responses.Workshop>(entity);
        }

        public override List<string> AllowedActions(Workshop entity)
        {
            return new List<string>() { nameof(Insert) };
        }
    }
}
