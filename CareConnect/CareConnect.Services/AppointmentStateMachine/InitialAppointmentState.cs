using CareConnect.Models.Enums;
using CareConnect.Models.Exceptions;
using CareConnect.Models.Messages;
using CareConnect.Models.Requests;
using CareConnect.Models.Responses;
using CareConnect.Services.Database;
using EasyNetQ;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Stripe;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareConnect.Services.AppointmentStateMachine
{
    public class InitialAppointmentState : BaseAppointmentState
    {

        private readonly IPaymentService _paymentService;

        private readonly ILogger<InitialAppointmentState> _logger;

        public InitialAppointmentState(
            CareConnectContext context, 
            IMapper mapper, 
            IServiceProvider serviceProvider, 
            IPaymentService paymentService, 
            ILogger<InitialAppointmentState> logger) 
            : base(context, mapper, serviceProvider)
        {
            _paymentService = paymentService;
            _logger = logger;
        }

        public override Models.Responses.Appointment Insert(AppointmentInsertRequest request)
        {
           var service = _context.EmployeeAvailabilities
                           .Where(x => x.EmployeeAvailabilityId == request.EmployeeAvailabilityId)
                           .Include(x => x.Service)
                           .Select(x => x.Service)
                           .FirstOrDefault();

            if (service == null)
                throw new UserException("Service not found.");

            var response = BookAppointmentAsync(request).GetAwaiter().GetResult();

            if (response)
            {
                var set = _context.Set<Database.Appointment>();

                var entity = _mapper.Map<Database.Appointment>(request);

                entity.StateMachine = "Scheduled";

                set.Add(entity);

                _context.SaveChanges(); 

                var scheduledAppointment = _context.Appointments
                    .Include(a => a.EmployeeAvailability)
                        .ThenInclude(ea => ea.Service)
                    .Include(a => a.EmployeeAvailability.Employee)
                    .Include(a => a.ClientsChild)
                        .ThenInclude(cc => cc.Child)
                    .Include(a => a.ClientsChild.Client)
                        .ThenInclude(c => c.User)
                    .FirstOrDefault(a => a.AppointmentId == entity.AppointmentId);

                if (scheduledAppointment == null)
                    throw new UserException("Failed to schedule appointment.");

                return _mapper.Map<Models.Responses.Appointment>(scheduledAppointment);
            }

            throw new UserException("Unable to book appointment. Validation failed."); 
        }

        public override List<string> AllowedActions(Database.Appointment entity)
        {
            return new List<string>() { nameof(Insert) };
        }

        public async Task<bool> BookAppointmentAsync(AppointmentInsertRequest request)
        {
            var client = await _context.Clients
                .FirstOrDefaultAsync(x => x.User.UserId == request.ClientId);

            if (client == null) return false;

            var child = await _context.Children
                .FirstOrDefaultAsync(x => x.ChildId == request.ChildId);

            if (child == null) return false;

            var clientsChild = await _context.ClientsChildren
                .FirstOrDefaultAsync(x => x.ClientId == request.ClientId && x.ChildId == request.ChildId);

            if (clientsChild == null) return false;

            var availability = await _context.EmployeeAvailabilities
                .Include(x => x.Service)
                .FirstOrDefaultAsync(x => x.EmployeeAvailabilityId == request.EmployeeAvailabilityId);

            if (availability == null) return false;

            var alreadyExist = await _context.Appointments
                .FirstOrDefaultAsync(x => x.ClientId == client.ClientId
                                       && x.ChildId == child.ChildId
                                       && x.EmployeeAvailabilityId == request.EmployeeAvailabilityId
                                       && x.Date == request.Date);

            if (alreadyExist != null) return false;

            if (availability?.Service?.Price != null)
            {
                if (string.IsNullOrEmpty(request.PaymentIntentId))
                    return false;

                var isPaymentVerified = await _paymentService.VerifyPaymentAsync(request.PaymentIntentId);
                if (!isPaymentVerified)
                    return false;


                var paymentRecord = await _context.Payments
                .FirstOrDefaultAsync(pr => pr.PaymentIntentId == request.PaymentIntentId);

                if (paymentRecord == null) return false;

                // Update payment status
                paymentRecord.Status = Models.Enums.PaymentStatus.Completed.ToString();
                paymentRecord.CompletedAt = DateTime.Now;
            }

            return true;
        }  
    }
}
