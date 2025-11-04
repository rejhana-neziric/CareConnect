using Azure;
using CareConnect.API.Filters;
using CareConnect.Models.Enums;
using CareConnect.Models.Messages;
using CareConnect.Models.Requests;
using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;
using CareConnect.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using Stripe.TestHelpers.Issuing;
using System.Security.Claims;

namespace CareConnect.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class AppointmentController : BaseCRUDController<Appointment, AppointmentSearchObject, AppointmentAdditionalData, AppointmentInsertRequest, AppointmentUpdateRequest>
    {
        private readonly IRabbitMqService _rabbitMqService;

        public AppointmentController(IAppointmentService service, IRabbitMqService rabbitMqService) : base(service) 
        {
            _rabbitMqService = rabbitMqService;

        }

        [HttpPut("{id}/cancel")]
        [PermissionAuthorize("Cancel")]
        public Appointment Cancel(int id)
        {
            var additional = new AppointmentAdditionalData()
            {
                IsClientsChildIncluded = true,
                IsAttendanceStatusIncluded = true,
                IsEmployeeAvailabilityIncluded = true
            };

            var appointment = GetById(id, additional);

            var message = CreateMessage(id, appointment, AppointmentStatus.Canceled);

            var response = (_service as IAppointmentService)!.Cancel(id);

            if (response != null)
            {
                _rabbitMqService.PublishAppointmentNotificationAsync(message);
            }

            return response;
        }

        [HttpPut("{id}/confirm")]
        [PermissionAuthorize("Confirm")]
        public Appointment Confirm(int id)
        {
            var additional = new AppointmentAdditionalData()
            {
                IsClientsChildIncluded = true, 
                IsAttendanceStatusIncluded = true, 
                IsEmployeeAvailabilityIncluded = true  
            };

            var appointment = GetById(id, additional); 

            var message = CreateMessage(id, appointment, AppointmentStatus.Confirmed);

            var response = (_service as IAppointmentService)!.Confirm(id);

            if (response != null)
            {
                _rabbitMqService.PublishAppointmentNotificationAsync(message);
            }

            return response; 
        }


        public override Appointment Insert(AppointmentInsertRequest request)
        {
            var appointment = (_service as IAppointmentService)!.Insert(request);

            var message = CreateMessage(appointment.AppointmentId, appointment, AppointmentStatus.Scheduled);

            if (appointment != null)
            {
                _rabbitMqService.PublishAppointmentNotificationAsync(message);
            }

            return appointment;
        }

        [HttpPut("{id}/start")]
        [PermissionAuthorize("Start")]
        public Appointment Start(int id)
        {
            return (_service as IAppointmentService)!.Start(id);
        }

        [HttpPut("{id}/complete")]
        [PermissionAuthorize("Complete")]
        public Appointment Complete(int id)
        {
            return (_service as IAppointmentService)!.Complete(id);
        }

        [HttpPut("{id}/reschedule")]
        [PermissionAuthorize("Reschedule")]
        public Appointment Reschedule(int id)
        {
            var additional = new AppointmentAdditionalData()
            {
                IsClientsChildIncluded = true,
                IsAttendanceStatusIncluded = true,
                IsEmployeeAvailabilityIncluded = true
            };

            var appointment = GetById(id, additional);

            var message = CreateMessage(id, appointment, AppointmentStatus.Rescheduled);

            var response = (_service as IAppointmentService)!.Reschedule(id);

            if (appointment != null)
            {
                _rabbitMqService.PublishAppointmentNotificationAsync(message);
            }

            return response;
        }

        [HttpPut("{id}/request-reschedule")]
        [PermissionAuthorize("RescheduleRequested")]
        public Appointment RescheduleRequest(int id)
        {
            var additional = new AppointmentAdditionalData()
            {
                IsClientsChildIncluded = true,
                IsAttendanceStatusIncluded = true,
                IsEmployeeAvailabilityIncluded = true
            };

            var appointment = GetById(id, additional);

            var message = CreateMessage(id, appointment, AppointmentStatus.RescheduleRequested);

            var response = (_service as IAppointmentService)!.RescheduleRequest(id);

            if (appointment != null)
            {
                _rabbitMqService.PublishAppointmentNotificationAsync(message);
            }

            return response;
        }

        [HttpPut("{id}/reschedule-pending-approval")]
        [PermissionAuthorize("ReschedulePendingApproval")]
        public Appointment ReschedulePendingApprove(int id, AppointmentRescheduleRequest request)
        {
            var additional = new AppointmentAdditionalData()
            {
                IsClientsChildIncluded = true,
                IsAttendanceStatusIncluded = true,
                IsEmployeeAvailabilityIncluded = true
            };

            var appointment = GetById(id, additional);

            var message = CreateMessage(id, appointment, AppointmentStatus.ReschedulePendingApproval);

            var response = (_service as IAppointmentService)!.ReschedulePendingApprove(id, request);

            if (appointment != null)
            {
                _rabbitMqService.PublishAppointmentNotificationAsync(message);
            }

            return response;
        }

        [HttpGet("{id}/allowedActions")]
        [AllowAnonymous]
        public List<string> AllowedActions(int id)
        {
            return (_service as IAppointmentService)!.AllowedActions(id);
        }

        [HttpGet("appointment-types")]
        [PermissionAuthorize("GetAppointmentTypes")]
        public List<string> GetAppointmentTypes()
        {
            return Enum.GetNames(typeof(AppointmentType)).ToList();
        }

        AppointmentNotificationMessage CreateMessage(int id, Appointment appointment, AppointmentStatus status) 
        {
            return new AppointmentNotificationMessage()
            {
                AppointmentId = id,
                ClientId = appointment.ClientId,
                EmployeeId = appointment.EmployeeAvailability.Employee.User.UserId,
                Status = status,
                AppointmentDate = appointment.Date,
                ServiceName = appointment.EmployeeAvailability.Service == null ? "No service name provided" : appointment.EmployeeAvailability.Service.Name,
                ChangedAt = DateTime.Now,
            };
        }
    }
}
