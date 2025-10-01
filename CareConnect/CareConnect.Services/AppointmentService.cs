using CareConnect.Models.Requests;
using CareConnect.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using CareConnect.Models.SearchObjects;
using CareConnect.Services.AppointmentStateMachine;
using Azure.Core;
using Microsoft.Extensions.Logging;
using CareConnect.Models.Enums;
using CareConnect.Models.Responses;
using static Permissions;
using Stripe.Forwarding;

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

            if (!string.IsNullOrWhiteSpace(search?.EmployeeFirstName))
            {
                query = query.Where(x => x.EmployeeAvailability.Employee.User.FirstName == search.EmployeeFirstName);
            }

            if (!string.IsNullOrWhiteSpace(search?.EmployeeLastName))
            {
                query = query.Where(x => x.EmployeeAvailability.Employee.User.LastName == search.EmployeeLastName);
            }

            if (!string.IsNullOrWhiteSpace(search?.StartTime))
            {
                query = query.Where(x => x.EmployeeAvailability.StartTime == search.StartTime);
            }

            if (!string.IsNullOrWhiteSpace(search?.EndTime))
            {
                query = query.Where(x => x.EmployeeAvailability.EndTime == search.EndTime);
            }

            if (!string.IsNullOrWhiteSpace(search?.Status))
            {
                query = query.Where(x => x.StateMachine == search.Status);
            }

            if (!string.IsNullOrWhiteSpace(search?.ChildFirstName))
            {
                query = query.Where(x => x.ClientsChild.Child.FirstName == search.ChildFirstName);
            }

            if (!string.IsNullOrWhiteSpace(search?.ChildLastName))
            {
                query = query.Where(x => x.ClientsChild.Child.LastName == search.ChildLastName);
            }

            if (search?.ClientId != null)
            {
                query = query.Where(x => x.ClientsChild.ClientId == search.ClientId);
            }

            if (search?.ChildId != null)
            {
                query = query.Where(x => x.ClientsChild.ChildId == search.ChildId);
            }

            if (!string.IsNullOrWhiteSpace(search?.ClientUsername))
            {
                query = query.Where(x => x.ClientsChild.Client.User.Username == search.ClientUsername);
            }

            if (search?.ServiceTypeId != null)
            {
                query = query.Where(x => x.EmployeeAvailability.Service.ServiceTypeId == search.ServiceTypeId);
            }

            if (!string.IsNullOrWhiteSpace(search?.ServiceNameGTE))
            {
                query = query.Where(x => x.EmployeeAvailability.Service.Name.StartsWith(search.ServiceNameGTE));
            }

            if (search?.EmployeeAvailabilityId != null)
            {
                query = query.Where(x => x.EmployeeAvailabilityId == search.EmployeeAvailabilityId);
            }

            if (search?.Date.HasValue == true)
            {
                query = query.Where(x => x.Date == search.Date);
            }

            if (!string.IsNullOrWhiteSpace(search?.SortBy))
            {
                query = search?.SortBy switch
                {
                    "employeeFirstName" => search.SortAscending ? query.OrderBy(x => x.EmployeeAvailability.Employee.User.FirstName) : query.OrderByDescending(x => x.EmployeeAvailability.Employee.User.FirstName),
                    "employeeLastName" => search.SortAscending ? query.OrderBy(x => x.EmployeeAvailability.Employee.User.LastName) : query.OrderByDescending(x => x.EmployeeAvailability.Employee.User.LastName),
                    "clientFirstName" => search.SortAscending ? query.OrderBy(x => x.ClientsChild.Client.User.FirstName) : query.OrderByDescending(x => x.ClientsChild.Client.User.FirstName),
                    "clientLastName" => search.SortAscending ? query.OrderBy(x => x.ClientsChild.Client.User.LastName) : query.OrderByDescending(x => x.ClientsChild.Client.User.LastName),
                    "childFirstName" => search.SortAscending ? query.OrderBy(x => x.ClientsChild.Child.FirstName) : query.OrderByDescending(x => x.ClientsChild.Child.FirstName),
                    "childLastName" => search.SortAscending ? query.OrderBy(x => x.ClientsChild.Child.LastName) : query.OrderByDescending(x => x.ClientsChild.Child.LastName),
                    "date" => search.SortAscending ? query.OrderBy(x => x.Date) : query.OrderByDescending(x => x.Date),
                    "status" => search.SortAscending ? query.OrderBy(x => x.StateMachine) : query.OrderByDescending(x => x.StateMachine),
                    _ => query
                };
            }

            return query;
        }

        protected override void AddInclude(AppointmentAdditionalData additionalData, ref IQueryable<Database.Appointment> query)
        {
            if (additionalData != null)
            {
                if (additionalData.IsClientsChildIncluded.HasValue && additionalData.IsClientsChildIncluded == true)
                {
                    additionalData.IncludeList.Add("ClientsChild");
                    additionalData.IncludeList.Add("ClientsChild.Client");
                    additionalData.IncludeList.Add("ClientsChild.Client.User"); 
                    additionalData.IncludeList.Add("ClientsChild.Child");
                }

                if (additionalData.IsEmployeeAvailabilityIncluded.HasValue && additionalData.IsEmployeeAvailabilityIncluded == true)
                {
                    additionalData.IncludeList.Add("EmployeeAvailability");
                    additionalData.IncludeList.Add("EmployeeAvailability.Employee");
                    additionalData.IncludeList.Add("EmployeeAvailability.Employee.User");
                    additionalData.IncludeList.Add("EmployeeAvailability.Service");
                    additionalData.IncludeList.Add("EmployeeAvailability.Service.ServiceType");
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
            var state = BaseAppointmentState.CreateAppointmentState("Initial");
            return state.Insert(request); 
        }

        public override Database.Appointment GetByIdWithIncludes(int id)
        {
            return Context.Appointments
                .Include(c => c.ClientsChild)
                    .ThenInclude(c => c.Child)
                .Include(c => c.ClientsChild)
                    .ThenInclude(c => c.Client)
                        .ThenInclude(c => c.User)
                .Include(e => e.EmployeeAvailability)
                    .ThenInclude(e => e.Employee)
                        .ThenInclude(e => e.User)
                .Include(e => e.EmployeeAvailability)
                    .ThenInclude(s => s.Service)
                .Include(a => a.AttendanceStatus)
                .First(a => a.AppointmentId == id);
        }

        public Models.Responses.Appointment Cancel(int id)
        {
            var entity = GetById(id);

            var state = BaseAppointmentState.CreateAppointmentState(entity.StateMachine);
            return state.Cancel(id);
        }

        public Models.Responses.Appointment Confirm(int id)
        {
            var entity = GetById(id);

            var state = BaseAppointmentState.CreateAppointmentState(entity.StateMachine);
            return state.Confirm(id);
        }

        public Models.Responses.Appointment Start(int id)
        {
            var entity = GetById(id);

            var state = BaseAppointmentState.CreateAppointmentState(entity.StateMachine);
            return state.Start(id);
        }

        public Models.Responses.Appointment Complete(int id)
        {
            var entity = GetById(id);

            var state = BaseAppointmentState.CreateAppointmentState(entity.StateMachine);
            return state.Complete(id);
        }

        public Models.Responses.Appointment Reschedule(int id, AppointmentRescheduleRequest request)
        {
            var entity = GetById(id);

            var state = BaseAppointmentState.CreateAppointmentState(entity.StateMachine);
            return state.Reschedule(id, request);
        }

        public List<string> AllowedActions(int id)
        {
            _logger.LogInformation($"Allowed action called for: {id}."); 

            if(id <= 0)
            {
                var state = BaseAppointmentState.CreateAppointmentState("Initial");
                return state.AllowedActions(null);
            }

            else
            {
                var entity = Context.Appointments.Find(id); 
                var state = BaseAppointmentState.CreateAppointmentState(entity.StateMachine);
                return state.AllowedActions(entity);
            }
        }
    }
}
