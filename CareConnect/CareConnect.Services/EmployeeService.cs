using CareConnect.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MapsterMapper;
using System.Security.Cryptography;
using CareConnect.Models.Requests;
using Mapster;
using CareConnect.Services.Helpers;
using CareConnect.Models.SearchObjects;

namespace CareConnect.Services
{
    public class EmployeeService : BaseCRUDService<Models.Responses.Employee, EmployeeSearchObject, EmployeeAdditionalData, Database.Employee, EmployeeInsertRequest, EmployeeUpdateRequest>, IEmployeeService
    {
        public EmployeeService(CareConnectContext context, IMapper mapper) : base(context, mapper) { }


        public override IQueryable<Database.Employee> AddFilter(EmployeeSearchObject search, IQueryable<Database.Employee> query)
        {
            query = base.AddFilter(search, query);

            if (!string.IsNullOrWhiteSpace(search?.FirstNameGTE))
            {
                query = query.Where(x => x.User.FirstName.StartsWith(search.FirstNameGTE));
            }

            if (!string.IsNullOrWhiteSpace(search?.LastNameGTE))
            {
                query = query.Where(x => x.User.LastName.StartsWith(search.LastNameGTE));
            }

            if (!string.IsNullOrWhiteSpace(search?.Email))
            {
                query = query.Where(x => x.User.Email == search.Email);
            }

            if (!string.IsNullOrWhiteSpace(search?.JobTitle))
            {
                query = query.Where(x => x.JobTitle == search.JobTitle);
            }

            if (search?.HireDateGTE.HasValue == true)
            {
                var mappedHireDate = search.HireDateGTE;
                query = query.Where(x => x.HireDate >= mappedHireDate);
            }

            if (search?.HireDateLTE.HasValue == true)
            {
                var mappedHireDate = search.HireDateLTE;
                query = query.Where(x => x.HireDate <= mappedHireDate);
            }

            return query;
        }

        protected override void AddInclude(EmployeeAdditionalData additionalData, ref IQueryable<Employee> query)
        {
            if (additionalData != null)
            {
                if (additionalData.IsUserIncluded.HasValue && additionalData.IsUserIncluded == true)
                {
                    additionalData.IncludeList.Add("User");
                }

                if (additionalData.IsQualificationIncluded.HasValue && additionalData.IsQualificationIncluded == true)
                {
                    additionalData.IncludeList.Add("Qualification");
                }

                if (additionalData.IsEmployeeAvailabilityIncluded.HasValue && additionalData.IsEmployeeAvailabilityIncluded == true)
                {
                    additionalData.IncludeList.Add("EmployeeAvailabilities");
                }
            }

            base.AddInclude(additionalData, ref query);
        }

        public override void BeforeInsert(EmployeeInsertRequest request, Employee entity)
        {
            if (request.User.Password != request.User.ConfirmationPassword)
                throw new Exception("Password and confirmation password must be same.");

            entity.User.PasswordSalt = SecurityHelper.GenerateSalt();
            entity.User.PasswordHash = SecurityHelper.GenerateHash(entity.User.PasswordSalt, request.User.Password);

            base.BeforeInsert(request, entity);
        }

        public override void BeforeUpdate(EmployeeUpdateRequest request, ref Employee entity)
        {
            if (request.User != null)
            {
                if (request.User.ConfirmationPassword != null)
                {
                    if (request.User.Password != request.User.ConfirmationPassword)
                        throw new Exception("Password and confirmation password must be same.");

                    entity.User.PasswordSalt = SecurityHelper.GenerateSalt();
                    entity.User.PasswordHash = SecurityHelper.GenerateHash(entity.User.PasswordSalt, request.User.Password);
                }

                Mapper.Map(request.User, entity.User);
                entity.User.ModifiedDate = DateTime.Now; ;
            }

            if (request.Qualification != null && entity.Qualification != null)
            {
                Mapper.Map(request.Qualification, entity.Qualification);
                entity.Qualification.ModifiedDate = DateTime.Now;
            }

            entity.ModifiedDate = DateTime.Now;

            base.BeforeUpdate(request, ref entity);
        }

        public override Employee GetByIdWithIncludes(int id)
        {
            return Context.Employees
                .Include(e => e.EmployeeAvailabilities)
                .Include(e => e.EmployeePayHistories)
                .Include(e => e.Reviews)
                .Include(e => e.Sessions)
                .Include(e => e.User)
                .Include(e => e.Qualification)
                .First(e => e.EmployeeId == id);
        }

        public override void BeforeDelete(Employee entity)
        {
            if (entity.Qualification != null)
                Context.Remove(entity.Qualification);

            foreach (var history in entity.EmployeePayHistories)
                Context.Remove(history);

            foreach (var availability in entity.EmployeeAvailabilities)
                Context.Remove(availability);

            base.BeforeDelete(entity);
        }

        public override void AfterDelete(int id)
        {
            var user = Context.Users.Find(id);

            if (user != null)
            {
                Context.Remove(user);
                Context.SaveChanges();
            }

            base.AfterDelete(id);
        }
    }
}
