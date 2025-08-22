using CareConnect.Models.Requests;
using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;
using CareConnect.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using static Permissions;

namespace CareConnect.Services
{
    public class ServiceService : BaseCRUDService<Models.Responses.Service, ServiceSearchObject, ServiceAdditionalData, Database.Service, ServiceInsertRequest, ServiceUpdateRequest>, IServiceService
    {
        public ServiceService(CareConnectContext context, IMapper mapper) : base(context, mapper) { }

        public override IQueryable<Database.Service> AddFilter(ServiceSearchObject search, IQueryable<Database.Service> query)
        {
            query = base.AddFilter(search, query);

            query = query.Include(x => x.ServiceType); 

            if (!string.IsNullOrWhiteSpace(search?.NameGTE))
            {
                query = query.Where(x => x.Name.StartsWith(search.NameGTE));
            }

            if (search?.Price.HasValue == true)
            {
                query = query.Where(x => x.Price == search.Price);
            }

            if (search?.MemberPrice.HasValue == true)
            {
                query = query.Where(x => x.MemberPrice == search.MemberPrice);
            }

            if (search?.IsActive.HasValue == true)
            {
                query = query.Where(x => x.IsActive == search.IsActive);
            }

            if (search?.ServiceTypeId.HasValue == true)
            {
                query = query.Where(x => x.ServiceTypeId == search.ServiceTypeId);
            }

            if (!string.IsNullOrWhiteSpace(search?.SortBy))
            {
                query = search?.SortBy switch
                {
                    "name" => search.SortAscending ? query.OrderBy(x => x.Name) : query.OrderByDescending(x => x.Name),
                    "price" => search.SortAscending ? query.OrderBy(x => x.Price) : query.OrderByDescending(x => x.Price),
                    "memberPrice" => search.SortAscending ? query.OrderBy(x => x.MemberPrice) : query.OrderByDescending(x => x.MemberPrice),
                    _ => query
                };
            }

            return query;
        }

        protected override void AddInclude(ServiceAdditionalData additionalData, ref IQueryable<Database.Service> query)
        {
            /*
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
*/
            base.AddInclude(additionalData, ref query);
        }

        public override void BeforeInsert(ServiceInsertRequest request, Database.Service entity)
        {
            base.BeforeInsert(request, entity);
        }

        public override void BeforeUpdate(ServiceUpdateRequest request, ref Database.Service entity)
        {
            entity = GetByIdWithIncludes(entity.ServiceId); 

            base.BeforeUpdate(request, ref entity);
        }

        public override Database.Service GetByIdWithIncludes(int id)
        {
            return Context.Services.Include(x => x.ServiceType)
                .First(x => x.ServiceId == id);
        }

        public override void BeforeDelete(Database.Service entity)
        {
            foreach (var service in entity.EmployeeAvailabilities)
                Context.Remove(service);

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

        public ServiceStatistics GetStatistics()
        {
            var now = DateTime.Now;
            var startOfMonth = new DateTime(now.Year, now.Month, 1);
            var startOfNextMonth = startOfMonth.AddMonths(1);

            return new ServiceStatistics
            {
                TotalServices = Context.Services.Count(),
                AveragePrice = Context.Services.Average(x => x.Price),
                AverageMemberPrice = Context.Services.Average(x => x.MemberPrice),

            };
        }
    }
}
