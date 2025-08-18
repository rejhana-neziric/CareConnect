using CareConnect.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareConnect.Services.WorkshopStateMachine
{
    public class PublishedWorkshopState : BaseWorkshopState
    {
        public PublishedWorkshopState(CareConnectContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override Models.Responses.Workshop Close(int id)
        {
            var set = _context.Set<Workshop>();

            var entity = set.Find(id);

            if (entity == null) return null;

            entity.Status = "Closed";

            _context.SaveChanges();

            return _mapper.Map<Models.Responses.Workshop>(entity);
        }

        public override Models.Responses.Workshop Cancel(int id)
        {
            var set = _context.Set<Workshop>();

            var entity = set.Find(id);

            if (entity == null) return null;

            entity.Status = "Canceled";

            _context.SaveChanges();

            return _mapper.Map<Models.Responses.Workshop>(entity);
        }

        public override List<string> AllowedActions(Workshop entity)
        {
            return new List<string>() { nameof(Close), nameof(Cancel) };
        }
    }
}
