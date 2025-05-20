using CareConnect.Models.Requests;
using CareConnect.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Security.Cryptography;
using Mapster;
using CareConnect.Services.Helpers;
using CareConnect.Models.SearchObjects;

namespace CareConnect.Services
{
    public class WorkshopService : BaseCRUDService<Models.Responses.Workshop, WorkshopSearchObject, WorkshopAdditionalData, Workshop, WorkshopInsertRequest, WorkshopUpdateRequest>, IWorkshopService
    {
        public WorkshopService(CareConnectContext context, IMapper mapper) : base(context, mapper) { }

        public override IQueryable<Workshop> AddFilter(WorkshopSearchObject search, IQueryable<Workshop> query)
        {
            query = base.AddFilter(search, query);


            if (!string.IsNullOrWhiteSpace(search?.NameGTE))
            {
                query = query.Where(x => x.Name.StartsWith(search.NameGTE));
            }

            if (!string.IsNullOrWhiteSpace(search?.Status))
            {
                query = query.Where(x => x.Status == search.Status);
            }

            if (search?.StartDateGTE.HasValue == true)
            {
                query = query.Where(x => x.StartDate >= search.StartDateGTE);
            }

            if (search?.StartDateLTE.HasValue == true)
            {
                query = query.Where(x => x.StartDate <= search.StartDateLTE);
            }

            if (search?.EndDateGTE.HasValue == true)
            {
                query = query.Where(x => x.EndDate >= search.EndDateGTE);
            }

            if (search?.EndDateLTE.HasValue == true)
            {
                query = query.Where(x => x.EndDate <= search.EndDateLTE);
            }

            if (search?.Price.HasValue == true)
            {
                query = query.Where(x => x.Price == search.Price);
            }

            if (search?.MemberPrice.HasValue == true)
            {
                query = query.Where(x => x.MemberPrice == search.MemberPrice);
            }

            if (search?.MaxParticipants.HasValue == true)
            {
                query = query.Where(x => x.MaxParticipants == search.MaxParticipants);
            }

            if (search?.Participants.HasValue == true)
            {
                query = query.Where(x => x.Participants == search.Participants);
            }

            return query;
        }

        protected override void AddInclude(WorkshopAdditionalData additionalData, ref IQueryable<Workshop> query)
        {
            if (additionalData != null)
            {
                if (additionalData.IsWorkshopTypeIncluded.HasValue && additionalData.IsWorkshopTypeIncluded == true)
                {
                    additionalData.IncludeList.Add("WorkshopType");
                }
            }

            base.AddInclude(additionalData, ref query);
        }

        public override void BeforeInsert(WorkshopInsertRequest request, Workshop entity)
        {
            base.BeforeInsert(request, entity);
        }

        public override void BeforeUpdate(WorkshopUpdateRequest request, ref Workshop entity)
        {
            base.BeforeUpdate(request, ref entity);
        }

        public override Workshop GetByIdWithIncludes(int id)
        {
            return Context.Workshops
                .Include(w => w.WorkshopType)
                .First(w => w.WorkshopId == id);
        }

        public override void BeforeDelete(Workshop entity)
        {
            foreach (var session in entity.Sessions)
                Context.Remove(session);

            foreach (var review in entity.Reviews)
                Context.Remove(review);

            base.BeforeDelete(entity);
        }

        public override void AfterDelete(int id)
        {
            //var user = Context.Users.Find(id);

            //if (user != null)
            //{
            //    Context.Remove(user);
            //    Context.SaveChanges();
            //}

            base.AfterDelete(id);
        }
    }
}
