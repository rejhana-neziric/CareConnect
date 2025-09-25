using CareConnect.Models.Enums;
using CareConnect.Models.Exceptions;
using CareConnect.Models.Messages;
using CareConnect.Models.Requests;
using CareConnect.Models.Responses;
using CareConnect.Services.Database;
using EasyNetQ;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareConnect.Services.AppointmentStateMachine
{
    public class InitialAppointmentState : BaseAppointmentState
    {

        public InitialAppointmentState(CareConnectContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {

        }

        public override Models.Responses.Appointment Insert(AppointmentInsertRequest request)
        {

            var service = _context.EmployeeAvailabilities.Where(x => x.EmployeeAvailabilityId == request.EmployeeAvailabilityId)
                                                         .Include(x => x.Service)
                                                         .Select(x => x.Service)
                                                         .FirstOrDefault();

            if (service == null)
                throw new UserException("Service not found.");

            //if (service.Price > 0)
            //    return new BookingResponse { Success = false, Message = "Service is not free." };

            return BookFreeAppointment(request); 

            //var set = _context.Set<Database.Appointment>();

            //var entity = _mapper.Map<Database.Appointment>(request);

            //entity.StateMachine = "Scheduled";

            //set.Add(entity);

            //_context.SaveChanges();

            //var bus = RabbitHutch.CreateBus("host=localhost;username=admin;password=admin");

            //var scheduledAppointment = _mapper.Map<Models.Responses.Appointment>(entity);

            //AppointmentScheduled mesagge = new AppointmentScheduled() {  Appointment = scheduledAppointment }; 

            //bus.PubSub.Publish(mesagge); 

            //return scheduledAppointment;
        }

        public override List<string> AllowedActions(Database.Appointment entity)
        {
            return new List<string>() { nameof(Insert) };
        }


        private Models.Responses.Appointment BookFreeAppointment(AppointmentInsertRequest request)
        {
            var client = _context.Clients.FirstOrDefault(x => x.User.UserId == request.ClientId);

            if (client == null)
                throw new UserException("Client not found.");


            var child = _context.Children.FirstOrDefault(x => x.ChildId == request.ChildId);

            if (child == null)
                throw new UserException("Child not found.");  

            var clientsChild = _context.ClientsChildren.FirstOrDefault(x => x.ClientId == request.ClientId && x.ChildId == request.ChildId);

            if (clientsChild == null)
                throw new UserException("Selected child does not belong to this client."); 

            var availability = _context.EmployeeAvailabilities.FirstOrDefault(x => x.EmployeeAvailabilityId == request.EmployeeAvailabilityId);

            if (availability == null)
                throw new UserException("Availability not found.");  

            var alreadyExist = _context.Appointments
                .FirstOrDefault(x => x.ClientId == client.ClientId
                                  && x.ChildId == child.ChildId 
                                  && x.EmployeeAvailabilityId == request.EmployeeAvailabilityId 
                                  && x.Date == request.Date);

            if (alreadyExist != null)
                throw new UserException("You already scheduled this service on the same date and time."); 

            var set = _context.Set<Database.Appointment>();

            var entity = _mapper.Map<Database.Appointment>(request);

            entity.StateMachine = "Scheduled";

            set.Add(entity);

            _context.SaveChanges();

            var scheduledAppointment = _context.Appointments.Include(a => a.EmployeeAvailability)
                                                                .ThenInclude(ea => ea.Service)
                                                            .Include(a => a.EmployeeAvailability.Employee)
                                                            .Include(a => a.ClientsChild)
                                                                .ThenInclude(cc => cc.Child)
                                                            .Include(a => a.ClientsChild.Client)
                                                                .ThenInclude(c => c.User)
                                                            .FirstOrDefault(a => a.AppointmentId == entity.AppointmentId);

            return _mapper.Map<Models.Responses.Appointment>(scheduledAppointment);
        }
    }
}
