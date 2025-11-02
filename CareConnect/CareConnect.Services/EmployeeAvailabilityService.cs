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

            if (!string.IsNullOrWhiteSpace(search?.StartTime))
            {
                query = query.Where(x => x.StartTime == search.StartTime);
            }

            if (!string.IsNullOrWhiteSpace(search?.EndTime))
            {
                query = query.Where(x => x.EndTime == search.EndTime);
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

            if(search?.EmployeeId.HasValue == true)
            {
                query = query.Where(x => x.EmployeeId == search.EmployeeId);
            }

            if (search?.ServiceId.HasValue == true)
            {
                query = query.Where(x => x.ServiceId == search.ServiceId);
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
    }
}
