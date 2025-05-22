using CareConnect.Models.Exceptions;
using CareConnect.Models.Requests;
using CareConnect.Services.Database;
using MapsterMapper;
using Microsoft.Extensions.DependencyInjection; 

namespace CareConnect.Services.AppointmentStateMachine
{
    public class BaseAppointmentState
    {
        protected readonly CareConnectContext _context;

        protected readonly IMapper _mapper;

        protected readonly IServiceProvider _serviceProvider; 

        public BaseAppointmentState(CareConnectContext context, IMapper mapper, IServiceProvider serviceProvider)
        {
            _context = context;
            _mapper = mapper;
            _serviceProvider = serviceProvider;
        }

        public virtual Models.Responses.Appointment Insert(AppointmentInsertRequest request)
        {
            throw new UserException("Method not allowed.");
        }

        public virtual Models.Responses.Appointment Reschedule(int id, AppointmentRescheduleRequest request)
        {
            throw new UserException("Method not allowed.");
        }

        public virtual Models.Responses.Appointment Confirm(int id)
        {
            throw new UserException("Method not allowed.");
        }

        public virtual Models.Responses.Appointment Start(int id)
        {
            throw new UserException("Method not allowed.");
        }

        public virtual Models.Responses.Appointment Complete(int id)
        {
            throw new UserException("Method not allowed.");
        }

        public virtual Models.Responses.Appointment Cancel(int id)
        {
            throw new UserException("Method not allowed.");
        }

        public virtual List<string> AllowedActions(Appointment entity)
        {
            throw new UserException("Method not allowed.");
        }

        public BaseAppointmentState GetProductState(string stateName)
        {
            switch(stateName) 
            {
                case "Initial":
                    return _serviceProvider.GetService<InitialAppointmentState>();
                case "Scheduled":
                    return _serviceProvider.GetService<ScheduledAppointmentState>();
                case "Confirmed":
                    return _serviceProvider.GetService<ConfirmedAppointmentState>();
                case "Rescheduled":
                    return _serviceProvider.GetService<RescheduledAppointmedState>();
                case "Canceled":
                    return _serviceProvider.GetService<CanceledAppointmentState>();
                case "Started":
                    return _serviceProvider.GetService<StartedAppointmentService>();
                case "Completed":
                    return _serviceProvider.GetService<CompletedAppointmentState>();

                default :
                    throw new Exception($"State {stateName} not defined."); 
            }
        }
    }
}
