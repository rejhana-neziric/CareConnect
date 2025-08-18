using CareConnect.Models.Requests;
using CareConnect.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareConnect.Services.WorkshopStateMachine
{
    public class DraftWorkshopState : BaseWorkshopState
    {
        public DraftWorkshopState(CareConnectContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override Models.Responses.Workshop Update(int id, WorkshopUpdateRequest request)
        {
            var set = _context.Set<Database.Workshop>();

            var entity = set.Find(id);

            _mapper.Map(request, entity);

            _context.SaveChanges();

            return _mapper.Map<Models.Responses.Workshop>(entity);            
        }

        public override Models.Responses.Workshop Publish(int id)
        {
            var set = _context.Set<Workshop>();

            var entity = set.Find(id);

            if (entity == null) return null;

            entity.Status = "Published";

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
            return new List<string>() { nameof(Update), nameof(Publish), nameof(Cancel) };
        }
    }
}
