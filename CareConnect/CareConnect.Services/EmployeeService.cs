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
using System.Globalization;
using CareConnect.Models.Responses;
using Microsoft.EntityFrameworkCore.Internal;
using static Permissions;
using Azure.Core;

namespace CareConnect.Services
{
    public class EmployeeService : BaseCRUDService<Models.Responses.Employee, EmployeeSearchObject, EmployeeAdditionalData, Database.Employee, EmployeeInsertRequest, EmployeeUpdateRequest>, IEmployeeService
    {
        private readonly IEmployeeAvailabilityService _employeeAvailabilityService;

        public EmployeeService(CareConnectContext context, IMapper mapper, IEmployeeAvailabilityService employeeAvailabilityService) : base(context, mapper) 
        {
            _employeeAvailabilityService = employeeAvailabilityService; 
        }


        public override IQueryable<Database.Employee> AddFilter(EmployeeSearchObject search, IQueryable<Database.Employee> query)
        {
            query = base.AddFilter(search, query);

            if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                query = query.Where(x => x.User.FirstName.StartsWith(search.FTS) || x.User.LastName.StartsWith(search.FTS) || x.JobTitle.StartsWith(search.FTS) || x.User.Email == search.FTS);
            }

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

            if(search?.Employed != null && search?.Employed == true)
            {
                query = query.Where(x => x.EndDate == null);
            }

            if (search?.Employed != null && search?.Employed == false)
            {
                query = query.Where(x => x.EndDate != null);
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

            if(!string.IsNullOrWhiteSpace(search?.SortBy))
            {
                query = search?.SortBy switch
                {
                    "firstName" => search.SortAscending ? query.OrderBy(x => x.User.FirstName) : query.OrderByDescending(x => x.User.FirstName),
                    "lastName" => search.SortAscending ? query.OrderBy(x => x.User.LastName) : query.OrderByDescending(x => x.User.LastName),
                    "jobTitle" => search.SortAscending ? query.OrderBy(x => x.JobTitle) : query.OrderByDescending(x => x.JobTitle),
                    _ => query
                };
            }

            return query;
        }

        protected override void AddInclude(EmployeeAdditionalData additionalData, ref IQueryable<Database.Employee> query)
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
            }

            base.AddInclude(additionalData, ref query);
        }

        public override void BeforeInsert(EmployeeInsertRequest request, Database.Employee entity)
        {
            if (request.User.Password != request.User.ConfirmationPassword)
                throw new Exception("Password and confirmation password must be same.");

            entity.User.PasswordSalt = SecurityHelper.GenerateSalt();
            entity.User.PasswordHash = SecurityHelper.GenerateHash(entity.User.PasswordSalt, request.User.Password);

            base.BeforeInsert(request, entity);
        }

        public override void BeforeUpdate(EmployeeUpdateRequest request, ref Database.Employee entity)
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

        public override Database.Employee GetByIdWithIncludes(int id)
        {
            return Context.Employees
                .Include(e => e.EmployeeAvailabilities).ThenInclude(e => e.Service)
                .Include(e => e.Reviews)
                .Include(e => e.User)
                .Include(e => e.Qualification)
                .First(e => e.EmployeeId == id);
        }

        public override void BeforeDelete(Database.Employee entity)
        {
            if (entity.Qualification != null)
                Context.Remove(entity.Qualification);

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

        public EmployeeStatistics GetStatistics()
        {
            var now = DateTime.Now;

            return new EmployeeStatistics
            {
                TotalEmployees = Context.Employees.Count(),
                EmployedThisMonth = Context.Employees.Count(e => e.HireDate.Month == now.Month && e.HireDate.Year == now.Year),
                CurrentlyEmployed = Context.Employees.Count(e => e.EndDate == null),
            };
        }

        public List<Models.Responses.EmployeeAvailability> GetEmployeeAvailability(int employeeId, DateTime? date = null)
        {
            var employee = Context.Employees.Find(employeeId);

            if (employee == null) return null;

            var response  = new List<Database.EmployeeAvailability>();

            var query = Context.EmployeeAvailabilities.Where(x => x.EmployeeId == employeeId); 

            if (date.HasValue)
            {
                var dayName = date!.Value.DayOfWeek.ToString();
                query = query.Where(x => x.DayOfWeek == dayName); 
            } 

            response = query.Include(x => x.Service).ThenInclude(x => x.ServiceType).ToList();

            if (response.Any() == false) return null;

            List<Models.Responses.EmployeeAvailability> list = new List<Models.Responses.EmployeeAvailability>();

            foreach (var availability in response)
            {

                var mapped = Mapper.Map<Models.Responses.EmployeeAvailability>(availability);

                if (date.HasValue)
                {
                    bool isBooked = Context.Appointments.Any(a =>
                        a.EmployeeAvailabilityId == availability.EmployeeAvailabilityId &&
                        a.Date.Date == date.Value.Date
                    );

                    mapped.IsBooked = isBooked; 
                }
                else
                {
                    mapped.IsBooked = false;
                }

                list.Add(mapped);
            }

            return list;
        }

        public Models.Responses.Employee CreateEmployeeAvailability(int employeeId, List<EmployeeAvailabilityInsertRequest> availability)
        {
            using var transaction = Context.Database.BeginTransaction();

            try
            {
                if(availability.Any())
                {
                    foreach(var request in availability)
                    {
                        _employeeAvailabilityService.Insert(request);
                    }
                }
              
                Context.SaveChanges();

                transaction.Commit();

                var response = Context.Employees.Include(x => x.User).Include(x => x.EmployeeAvailabilities).ThenInclude(x => x.Service).Where(x => x.EmployeeId == employeeId); 

                return Mapper.Map<Models.Responses.Employee>(response);

            }
            catch (Exception ex)
            {

                transaction.Rollback();
                throw;
            }
        }

        public Models.Responses.Employee UpdateEmployeeAvailability(int employeeId, EmployeeAvailabilityChanges availability)
        {
            using var transaction = Context.Database.BeginTransaction();

            try
            {
                if (availability.toCreate.Any())
                {
                    foreach (var request in availability.toCreate)
                    {
                        _employeeAvailabilityService.Insert(request);
                    }
                }

                if (availability.toUpdate.Any())
                {
                    foreach (var request in availability.toUpdate)
                    {
                        _employeeAvailabilityService.Update(request.Key, request.Value);
                    }
                }

                if (availability.toDelete.Any())
                {
                    foreach (var request in availability.toDelete)
                    {
                        _employeeAvailabilityService.Delete(request);
                    }
                }

                Context.SaveChanges();

                transaction.Commit();
                
                var response = Context.Employees.Include(x => x.User).Include(x => x.EmployeeAvailabilities).ThenInclude(x => x.Service).FirstOrDefault(x => x.EmployeeId == employeeId);

                return Mapper.Map<Models.Responses.Employee>(response);

            }
            catch (Exception ex)
            {

                transaction.Rollback();
                throw;
            }
        }
    }
}
