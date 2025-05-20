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
    public class EmployeePayHistoryService : BaseCRUDService<Models.Responses.EmployeePayHistory, EmployeePayHistorySearchObject, EmployeePayHistoryAdditionalData, EmployeePayHistory, EmployeePayHistoryInsertRequest, EmployeePayHistoryUpdateRequest>, IEmployeePayHistoryService
    {
        public EmployeePayHistoryService(CareConnectContext context, IMapper mapper) : base(context, mapper) { }

        public override IQueryable<EmployeePayHistory> AddFilter(EmployeePayHistorySearchObject search, IQueryable<EmployeePayHistory> query)
        {
            query = base.AddFilter(search, query);

            if (search?.RateChangeDateGTE.HasValue == true)
            {
                query = query.Where(x => x.RateChangeDate >= search.RateChangeDateGTE);
            }

            if (search?.RateChangeDateLTE.HasValue == true)
            {
                query = query.Where(x => x.RateChangeDate <= search.RateChangeDateLTE);
            }

            if (search?.Rate.HasValue == true)
            {
                query = query.Where(x => x.Rate == search.Rate);
            }

            if (!string.IsNullOrWhiteSpace(search?.EmployeeFirstNameGTE))
            {
                query = query.Where(x => x.Employee.User.FirstName.StartsWith(search.EmployeeFirstNameGTE));
            }

            if (!string.IsNullOrWhiteSpace(search?.EmployeeLastNameGTE))
            {
                query = query.Where(x => x.Employee.User.LastName.StartsWith(search.EmployeeLastNameGTE));
            }

            return query;
        }

        protected override void AddInclude(EmployeePayHistoryAdditionalData additionalData, ref IQueryable<EmployeePayHistory> query)
        {
            if (additionalData != null)
            {
                if (additionalData.IsEmployeeIncluded.HasValue && additionalData.IsEmployeeIncluded == true)
                {
                    additionalData.IncludeList.Add("Employee");
                    additionalData.IncludeList.Add("Employee.User");
                }
            }

            base.AddInclude(additionalData, ref query);
        }

        public override void BeforeInsert(EmployeePayHistoryInsertRequest request, EmployeePayHistory entity)
        {
            base.BeforeInsert(request, entity);
        }

        public override void BeforeUpdate(EmployeePayHistoryUpdateRequest request, ref EmployeePayHistory entity)
        {
            base.BeforeUpdate(request, ref entity);
        }

        public override EmployeePayHistory GetByIdWithIncludes(int id)
        {
            return Context.EmployeePayHistories
                    .Include(e => e.Employee)
                    .ThenInclude(u => u.User)
                    .First(e => e.EmployeeId == id);
        }

        public override void BeforeDelete(EmployeePayHistory entity)
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
