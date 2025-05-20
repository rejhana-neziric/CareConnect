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
    public class AppointmentService : BaseCRUDService<Models.Responses.Appointment, AppointmentSearchObject, AppointmentAdditionalData, Database.Appointment, AppointmentInsertRequest, AppointmentUpdateRequest>, IAppointmentService
    {
        public AppointmentService(CareConnectContext context, IMapper mapper) : base(context, mapper) { }

        public override IQueryable<Database.Appointment> AddFilter(AppointmentSearchObject search, IQueryable<Database.Appointment> query)
        {
            query = base.AddFilter(search, query);

            if (!string.IsNullOrWhiteSpace(search?.AppointmentType))
            {
                query = query.Where(x => x.AppointmentType == search.AppointmentType);
            }

            if (search?.DateGTE.HasValue == true)
            {
                query = query.Where(x => x.Date >= search.DateGTE);
            }

            if (search?.DateLTE.HasValue == true)
            {
                query = query.Where(x => x.Date <= search.DateLTE);
            }

            if (!string.IsNullOrWhiteSpace(search?.AttendanceStatusName))
            {
                query = query.Where(x => x.AttendanceStatus.Name == search.AttendanceStatusName);
            }

            if (!string.IsNullOrWhiteSpace(search?.EmployeeFirstNameGTE))
            {
                query = query.Where(x => x.EmployeeAvailability.Employee.User.FirstName.StartsWith(search.EmployeeFirstNameGTE));
            }

            if (!string.IsNullOrWhiteSpace(search?.EmployeeLastNameGTE))
            {
                query = query.Where(x => x.EmployeeAvailability.Employee.User.LastName.StartsWith(search.EmployeeLastNameGTE));
            }

            if (search?.StartTime.HasValue == true)
            {
                query = query.Where(x => x.EmployeeAvailability.StartTime == search.StartTime);
            }

            if (search?.EndTime.HasValue == true)
            {
                query = query.Where(x => x.EmployeeAvailability.EndTime == search.EndTime);
            }

            if (!string.IsNullOrWhiteSpace(search?.UserFirstNameGTE))
            {
                query = query.Where(x => x.User.FirstName.StartsWith(search.UserFirstNameGTE));
            }

            if (!string.IsNullOrWhiteSpace(search?.UserLastNameGTE))
            {
                query = query.Where(x => x.User.LastName.StartsWith(search.UserLastNameGTE));
            }

            return query;
        }

        protected override void AddInclude(AppointmentAdditionalData additionalData, ref IQueryable<Database.Appointment> query)
        {
            if (additionalData != null)
            {
                if (additionalData.IsUserIncluded.HasValue && additionalData.IsUserIncluded == true)
                {
                    additionalData.IncludeList.Add("User");
                }

                if (additionalData.IsEmployeeAvailabilityIncluded.HasValue && additionalData.IsEmployeeAvailabilityIncluded == true)
                {
                    additionalData.IncludeList.Add("EmployeeAvailability");
                }

                if (additionalData.IsAttendanceStatusIncluded.HasValue && additionalData.IsAttendanceStatusIncluded == true)
                {
                    additionalData.IncludeList.Add("AttendanceStatus");
                }
            }

            base.AddInclude(additionalData, ref query);
        }

        public override void BeforeInsert(AppointmentInsertRequest request, Database.Appointment entity)
        {
            base.BeforeInsert(request, entity);
        }

        public override void BeforeUpdate(AppointmentUpdateRequest request, ref Database.Appointment entity)
        {
            base.BeforeUpdate(request, ref entity);
        }

        public override Database.Appointment GetByIdWithIncludes(int id)
        {
            return Context.Appointments
                .Include(u => u.User)
                .Include(e => e.EmployeeAvailability)
                .Include(a => a.AttendanceStatus)
                .First(a => a.AppointmentId == id);
        }

        public override void BeforeDelete(Database.Appointment entity)
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
