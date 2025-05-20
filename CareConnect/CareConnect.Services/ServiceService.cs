using CareConnect.Models.Requests;
using CareConnect.Models.SearchObjects;
using CareConnect.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;

namespace CareConnect.Services
{
    public class ServiceService : BaseCRUDService<Models.Responses.Service, ServiceSearchObject, ServiceAdditionalData, Service, ServiceInsertRequest, ServiceUpdateRequest>, IServiceService
    {
        public ServiceService(CareConnectContext context, IMapper mapper) : base(context, mapper) { }

        public override IQueryable<Service> AddFilter(ServiceSearchObject search, IQueryable<Service> query)
        {
            query = base.AddFilter(search, query);

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

            return query;
        }

        protected override void AddInclude(ServiceAdditionalData additionalData, ref IQueryable<Service> query)
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

        public override void BeforeInsert(ServiceInsertRequest request, Service entity)
        {
            base.BeforeInsert(request, entity);
        }

        public override void BeforeUpdate(ServiceUpdateRequest request, ref Service entity)
        {
            base.BeforeUpdate(request, ref entity);
        }

        public override Service GetByIdWithIncludes(int id)
        {
            return Context.Services
                .First(s => s.ServiceId == id);
        }

        public override void BeforeDelete(Service entity)
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
