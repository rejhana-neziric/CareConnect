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
using CareConnect.Services.AppointmentStateMachine;
using CareConnect.Services.WorkshopStateMachine;
using Microsoft.Extensions.Logging;
using CareConnect.Models.Responses;

namespace CareConnect.Services
{
    public class WorkshopService : BaseCRUDService<Models.Responses.Workshop, WorkshopSearchObject, WorkshopAdditionalData, Database.Workshop, WorkshopInsertRequest, WorkshopUpdateRequest>, IWorkshopService
    {
        public BaseWorkshopState BaseWorkshopState { get; set; }

        ILogger<WorkshopService> _logger;


        public WorkshopService(CareConnectContext context, IMapper mapper, BaseWorkshopState baseWorkshopState, ILogger<WorkshopService> logger) : base(context, mapper) 
        {
            BaseWorkshopState = baseWorkshopState;
            _logger = logger;
        }

        public override IQueryable<Database.Workshop> AddFilter(WorkshopSearchObject search, IQueryable<Database.Workshop> query)
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

            if (!string.IsNullOrWhiteSpace(search?.WorkshopType))
            {
                query = query.Where(x => x.WorkshopType == search.WorkshopType);
            }

            if (!string.IsNullOrWhiteSpace(search?.SortBy))
            {
                query = search?.SortBy switch
                {
                    "name" => search.SortAscending ? query.OrderBy(x => x.Name) : query.OrderByDescending(x => x.Name),
                    "price" => search.SortAscending ? query.OrderBy(x => x.Price) : query.OrderByDescending(x => x.Price),
                    "memberPrice" => search.SortAscending ? query.OrderBy(x => x.MemberPrice) : query.OrderByDescending(x => x.MemberPrice),
                    "startDate" => search.SortAscending ? query.OrderBy(x => x.StartDate) : query.OrderByDescending(x => x.StartDate),
                    "maxParticipants" => search.SortAscending ? query.OrderBy(x => x.MaxParticipants) : query.OrderByDescending(x => x.MaxParticipants),
                    "participants" => search.SortAscending ? query.OrderBy(x => x.Participants) : query.OrderByDescending(x => x.Participants),
                    _ => query
                };
            }

            return query;
        }


        public override void BeforeInsert(WorkshopInsertRequest request, Database.Workshop entity)
        {   
            base.BeforeInsert(request, entity);
        }

        public override void BeforeUpdate(WorkshopUpdateRequest request, ref Database.Workshop entity)
        {
            base.BeforeUpdate(request, ref entity);
        }

        public override Database.Workshop GetByIdWithIncludes(int id)
        {
            return Context.Workshops
                .Include(w => w.WorkshopType)
                .First(w => w.WorkshopId == id);
        }

        public override void BeforeDelete(Database.Workshop entity)
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

        public Models.Responses.Workshop Insert(WorkshopInsertRequest request)
        {
            var state = BaseWorkshopState.CreateWorkshopState("Initial");
            return state.Insert(request);
        }

        public override Models.Responses.Workshop Update(int id, WorkshopUpdateRequest request)
        {
            var entity = GetById(id);
            var state = BaseWorkshopState.CreateWorkshopState(entity.Status);
            return state.Update(id, request);

        }

        public Models.Responses.Workshop Cancel(int id)
        {
            var entity = GetById(id);
            var state = BaseWorkshopState.CreateWorkshopState(entity.Status);
            return state.Cancel(id);
        }

        public Models.Responses.Workshop Close(int id)
        {
            var entity = GetById(id);
            var state = BaseWorkshopState.CreateWorkshopState(entity.Status);
            return state.Close(id);
        }

        public Models.Responses.Workshop Publish(int id)
        {
            var entity = GetById(id);

            var state = BaseWorkshopState.CreateWorkshopState(entity.Status);
            return state.Publish(id);
        }

        public List<string> AllowedActions(int id)
        {
            _logger.LogInformation($"Allowed action called for: {id}.");

            if (id <= 0)
            {
                var state = BaseWorkshopState.CreateWorkshopState("Initial");
                return state.AllowedActions(null);
            }

            else
            {
                var entity = Context.Workshops.Find(id);
                var state = BaseWorkshopState.CreateWorkshopState(entity.Status);
                return state.AllowedActions(entity);
            }
        }


        public WorkshopStatistics GetStatistics()
        {
            var now = DateTime.Now;
            var startOfMonth = new DateTime(now.Year, now.Month, 1);
            var startOfNextMonth = startOfMonth.AddMonths(1);

            return new WorkshopStatistics
            {
                TotalWorkshops = Context.Workshops.Count(),
                Upcoming = Context.Workshops.Where(x => x.Status == "Published").Count(),
                AverageParticipants = (int)Context.Workshops.Average(x => x.Participants),
                AverageRating = (int)Context.Workshops.SelectMany(x => x.Reviews).Average(y => y.Stars)

        };
        }
    }
}
