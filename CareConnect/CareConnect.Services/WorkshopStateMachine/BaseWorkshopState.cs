using CareConnect.Models.Exceptions;
using CareConnect.Models.Requests;
using CareConnect.Services.AppointmentStateMachine;
using CareConnect.Services.Database;
using MapsterMapper;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareConnect.Services.WorkshopStateMachine
{
    public class BaseWorkshopState
    {
        protected readonly CareConnectContext _context;

        protected readonly IMapper _mapper;

        protected readonly IServiceProvider _serviceProvider;

        public BaseWorkshopState(CareConnectContext context, IMapper mapper, IServiceProvider serviceProvider)
        {
            _context = context;
            _mapper = mapper;
            _serviceProvider = serviceProvider;
        }

        public virtual Models.Responses.Workshop Insert(WorkshopInsertRequest request)
        {
            throw new UserException("Method not allowed.");
        }

        public virtual Models.Responses.Workshop Update(int id, WorkshopUpdateRequest request)
        {
            throw new UserException("Method not allowed.");
        }

        public virtual Models.Responses.Workshop Publish(int id)
        {
            throw new UserException("Method not allowed.");
        }

        public virtual Models.Responses.Workshop Close(int id)
        {
            throw new UserException("Method not allowed.");
        }

        public virtual Models.Responses.Workshop Cancel(int id)
        {
            throw new UserException("Method not allowed.");
        }

        public virtual List<string> AllowedActions(Workshop entity)
        {
            throw new UserException("Method not allowed.");
        }

        public BaseWorkshopState CreateWorkshopState(string stateName)
        {
            switch (stateName)
            {
                case "Initial":
                    return _serviceProvider.GetService<InitialWorkshopState>()!;
                case "Draft":
                    return _serviceProvider.GetService<DraftWorkshopState>()!;
                case "Published":
                    return _serviceProvider.GetService<PublishedWorkshopState>()!;
                case "Closed":
                    return _serviceProvider.GetService<ClosedWorkshopState>()!;
                case "Canceled":
                    return _serviceProvider.GetService<CanceledWorkshopState>()!;

                default:
                    throw new Exception($"State {stateName} not defined.");
            }
        }
    }
}
