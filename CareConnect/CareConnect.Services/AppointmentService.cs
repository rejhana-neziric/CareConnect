using CareConnect.Models.Requests;
using CareConnect.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using CareConnect.Models.SearchObjects;
using CareConnect.Services.AppointmentStateMachine;
using Azure.Core;
using Microsoft.Extensions.Logging;

namespace CareConnect.Services
{
    public class AppointmentService : BaseCRUDService<Models.Responses.Appointment, AppointmentSearchObject, AppointmentAdditionalData, Database.Appointment, AppointmentInsertRequest, AppointmentUpdateRequest>, IAppointmentService
    {
        public BaseAppointmentState BaseAppointmentState { get; set; }

        ILogger<AppointmentService> _logger; 

        public AppointmentService(CareConnectContext context, IMapper mapper, BaseAppointmentState baseAppointmentState, ILogger<AppointmentService> logger) 
            : base(context, mapper) 
        {
            BaseAppointmentState = baseAppointmentState;  
            _logger = logger;   
        }

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

            //if (!string.IsNullOrWhiteSpace(search?.UserFirstNameGTE))
            //{
            //    query = query.Where(x => x.User.FirstName.StartsWith(search.UserFirstNameGTE));
            //}

            //if (!string.IsNullOrWhiteSpace(search?.UserLastNameGTE))
            //{
            //    query = query.Where(x => x.User.LastName.StartsWith(search.UserLastNameGTE));
            //}

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

        public override Models.Responses.Appointment Insert(AppointmentInsertRequest request)
        {
            var state = BaseAppointmentState.GetProductState("Initial");
            return state.Insert(request); 
        }

        public override Database.Appointment GetByIdWithIncludes(int id)
        {
            return Context.Appointments
                //.Include(u => u.User)
                .Include(e => e.EmployeeAvailability)
                .Include(a => a.AttendanceStatus)
                .First(a => a.AppointmentId == id);
        }

        public Models.Responses.Appointment Cancel(int id)
        {
            var entity = GetById(id);

            var state = BaseAppointmentState.GetProductState(entity.StateMachine);
            return state.Cancel(id);
        }

        public Models.Responses.Appointment Confirm(int id)
        {
            var entity = GetById(id);

            var state = BaseAppointmentState.GetProductState(entity.StateMachine);
            return state.Confirm(id);
        }

        public Models.Responses.Appointment Start(int id)
        {
            var entity = GetById(id);

            var state = BaseAppointmentState.GetProductState(entity.StateMachine);
            return state.Start(id);
        }

        public Models.Responses.Appointment Complete(int id)
        {
            var entity = GetById(id);

            var state = BaseAppointmentState.GetProductState(entity.StateMachine);
            return state.Complete(id);
        }

        public Models.Responses.Appointment Reschedule(int id, AppointmentRescheduleRequest request)
        {
            var entity = GetById(id);

            var state = BaseAppointmentState.GetProductState(entity.StateMachine);
            return state.Reschedule(id, request);
        }

        public List<string> AllowedActions(int id)
        {
            _logger.LogInformation($"Allowed action called for: {id}."); 

            if(id <= 0)
            {
                var state = BaseAppointmentState.GetProductState("Initial");
                return state.AllowedActions(null);
            }

            else
            {
                var entity = Context.Appointments.Find(id); 
                var state = BaseAppointmentState.GetProductState(entity.StateMachine);
                return state.AllowedActions(entity);
            }
        }
    }
}
