using CareConnect.Services.Database;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;


namespace CareConnect.Services.BackgroundTasks
{
    public class AppointmentStatusUpdater : BackgroundService
    {
        private readonly IServiceProvider _serviceProvider;

        private readonly TimeSpan _checkInterval = TimeSpan.FromMinutes(30); // check every minute

        public AppointmentStatusUpdater(IServiceProvider serviceProvider)
        {
            _serviceProvider = serviceProvider;
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            while (!stoppingToken.IsCancellationRequested)
            {
                try
                {
                    await UpdateExpiredAppointmentsAsync();
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"Error updating appointments: {ex.Message}");
                }

                await Task.Delay(_checkInterval, stoppingToken);
            }
        }
        private async Task UpdateExpiredAppointmentsAsync()
        {
            using var scope = _serviceProvider.CreateScope();
            var context = scope.ServiceProvider.GetRequiredService<CareConnectContext>();

            var now = DateTime.Now;

            var appointments = await context.Appointments
                     .Include(a => a.AttendanceStatus)
                     .Include(a => a.EmployeeAvailability)
                     .Where(a => a.StateMachine != "Completed" && a.StateMachine != "Canceled")
                     .ToListAsync(); 

            foreach (var a in appointments)
            {
                if (a.EmployeeAvailability == null ||
                    string.IsNullOrEmpty(a.EmployeeAvailability.StartTime) ||
                    string.IsNullOrEmpty(a.EmployeeAvailability.EndTime))
                    continue;

                if (!TimeSpan.TryParse(a.EmployeeAvailability.StartTime, out var startTime) ||
                    !TimeSpan.TryParse(a.EmployeeAvailability.EndTime, out var endTime))
                    continue;

                var appointmentStart = a.Date.Date + startTime;
                var appointmentEnd = a.Date.Date + endTime;

                if (now >= appointmentEnd)
                    a.StateMachine = "Completed";
                
                else if (now >= appointmentStart && now < appointmentEnd) 
                    a.StateMachine = "Started";
                

                a.ModifiedDate = now;
            }

            await context.SaveChangesAsync();
        }
    }
}
