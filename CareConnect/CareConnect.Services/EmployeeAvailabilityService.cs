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
    public class EmployeeAvailabilityService : BaseCRUDService<Models.Responses.EmployeeAvailability, EmployeeAvailabilitySearchObject, EmployeeAvailabilityAdditionalData, EmployeeAvailability, EmployeeAvailabilityInsertRequest, EmployeeAvailabilityUpdateRequest>, IEmployeeAvailabilityService
    {
        public EmployeeAvailabilityService(CareConnectContext context, IMapper mapper) : base(context, mapper) { }

        public override IQueryable<EmployeeAvailability> AddFilter(EmployeeAvailabilitySearchObject search, IQueryable<EmployeeAvailability> query)
        {
            query = base.AddFilter(search, query);


            if (!string.IsNullOrWhiteSpace(search?.DayOfWeek))
            {
                query = query.Where(x => x.DayOfWeek == search.DayOfWeek);
            }

            if (search?.StartTime.HasValue == true)
            {
                query = query.Where(x => x.StartTime == search.StartTime);
            }

            if (search?.EndTime.HasValue == true)
            {
                query = query.Where(x => x.EndTime == search.EndTime);
            }

            if (search?.IsAvailable.HasValue == true)
            {
                query = query.Where(x => x.IsAvailable == search.IsAvailable);
            }

            if (!string.IsNullOrWhiteSpace(search?.EmployeeFirstNameGTE))
            {
                query = query.Where(x => x.Employee.User.FirstName.StartsWith(search.EmployeeFirstNameGTE));
            }

            if (!string.IsNullOrWhiteSpace(search?.EmployeeLastNameGTE))
            {
                query = query.Where(x => x.Employee.User.LastName.StartsWith(search.EmployeeLastNameGTE));
            }

            if (!string.IsNullOrWhiteSpace(search?.ServiceNameGTE))
            {
                query = query.Where(x => x.Service != null && x.Service.Name.StartsWith(search.ServiceNameGTE));
            }

            return query;
        }

        protected override void AddInclude(EmployeeAvailabilityAdditionalData additionalData, ref IQueryable<EmployeeAvailability> query)
        {
            if (additionalData != null)
            {
                if (additionalData.IsEmployeeIncluded.HasValue && additionalData.IsEmployeeIncluded == true)
                {
                    additionalData.IncludeList.Add("Employee");
                    additionalData.IncludeList.Add("Employee.User");
                }

                if (additionalData.IsServiceIncluded.HasValue && additionalData.IsServiceIncluded == true)
                {
                    additionalData.IncludeList.Add("Service");
                }
            }

            base.AddInclude(additionalData, ref query);
        }

        public override void BeforeInsert(EmployeeAvailabilityInsertRequest request, EmployeeAvailability entity)
        {
            base.BeforeInsert(request, entity);
        }

        public override void BeforeUpdate(EmployeeAvailabilityUpdateRequest request, ref EmployeeAvailability entity)
        {
            base.BeforeUpdate(request, ref entity);
        }

        public override EmployeeAvailability GetByIdWithIncludes(int id)
        {
            return Context.EmployeeAvailabilities
                .Include(e => e.Employee)
                    .ThenInclude(u => u.User)
                .Include(s => s.Service)
                .Include(a => a.Appointments)
                .First(e => e.EmployeeAvailabilityId == id);
        }

        public override void BeforeDelete(EmployeeAvailability entity)
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
