using CareConnect.Models.Requests;
using CareConnect.Models.SearchObjects;
using CareConnect.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;

namespace CareConnect.Services
{
    public class SessionService : BaseCRUDService<Models.Responses.Session, SessionSearchObject, SessionAdditionalData, Session, SessionInsertRequest, SessionUpdateRequest>, ISessionService
    {
        public SessionService(CareConnectContext context, IMapper mapper) : base(context, mapper) { }

        public override IQueryable<Session> AddFilter(SessionSearchObject search, IQueryable<Session> query)
        {
            query = base.AddFilter(search, query);


            if (!string.IsNullOrWhiteSpace(search?.NameGTE))
            {
                query = query.Where(x => x.Name.StartsWith(search.NameGTE));
            }

            if (search?.DateGTE.HasValue == true)
            {
                query = query.Where(x => x.Date >= search.DateGTE);
            }

            if (search?.DateLTE.HasValue == true)
            {
                query = query.Where(x => x.Date <= search.DateLTE);
            }

            if (search?.StartTime.HasValue == true)
            {
                query = query.Where(x => x.StartTime == search.StartTime);
            }

            if (search?.EndTime.HasValue == true)
            {
                query = query.Where(x => x.EndTime == search.EndTime);
            }

            if (!string.IsNullOrWhiteSpace(search?.Status))
            {
                query = query.Where(x => x.Status == search.Status);
            }

            return query;
        }

        protected override void AddInclude(SessionAdditionalData additionalData, ref IQueryable<Session> query)
        {
            if (additionalData != null)
            {
                if (additionalData.IsEmployeeIncluded.HasValue && additionalData.IsEmployeeIncluded == true)
                {
                    additionalData.IncludeList.Add("Employee");
                    additionalData.IncludeList.Add("Employee.User");

                }

                if (additionalData.IsInstructorIncluded.HasValue && additionalData.IsInstructorIncluded == true)
                {
                    additionalData.IncludeList.Add("Instructor");
                }

                if (additionalData.IsWorkshopIncluded.HasValue && additionalData.IsWorkshopIncluded == true)
                {
                    additionalData.IncludeList.Add("Workshop");
                }
            }

            base.AddInclude(additionalData, ref query);
        }

        public override void BeforeInsert(SessionInsertRequest request, Session entity)
        {
            base.BeforeInsert(request, entity);
        }

        public override void BeforeUpdate(SessionUpdateRequest request, ref Session entity)
        {
            base.BeforeUpdate(request, ref entity);
        }

        public override Session GetByIdWithIncludes(int id)
        {
            return Context.Sessions
                .Include(e => e.Employee)
                .Include(i => i.Instructor)
                .Include(w => w.Workshop)
                .First(s => s.SessionId == id);
        }

        public override void BeforeDelete(Session entity)
        {
            //foreach (var child in entity.ClientsChildren)
            //    Context.Remove(child);

            //foreach (var review in entity)
            //    Context.Remove(review);

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
