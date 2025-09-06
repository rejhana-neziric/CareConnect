using CareConnect.Models.Enums;
using CareConnect.Models.Responses;
using CareConnect.Services.Database;
using CareConnect.Services.Helpers;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareConnect.Services
{
    public class ReportService : IReportService
    {
        public CareConnectContext Context { get; set; }

        public IMapper Mapper { get; }

        public ReportService(CareConnectContext context, IMapper mapper)
        {
            Context = context;
            Mapper = mapper;
        }

        public List<ReportData> GetReportData(DateTime start, DateTime end, string period)
        {
            List<ReportData> result = new List<ReportData>();

            switch (period)
            {
                case "daily":
                    var dailyDates = Enumerable.Range(0, (end - start).Days + 1)
                        .Select(i => start.AddDays(i).Date)
                        .ToList();

                    foreach (var date in dailyDates)
                    {
                        var appointments = Context.Appointments
                            .Where(a => a.Date.Date == date && a.StateMachine != "Canceled")
                            .Count();

                        var newClients = Context.Clients
                            .Where(c => c.CreatedDate.Date == date)
                            .Count();

                        var workshops = Context.Workshops
                            .Where(w => w.StartDate.Date == date && w.Status != "Canceled")
                            .Count();

                        if (appointments > 0 || newClients > 0 || workshops > 0)
                        {
                            result.Add(new ReportData
                            {
                                Date = date,
                                Appointments = appointments,
                                NewClients = newClients,
                                Workshops = workshops
                            });
                        }
                    }
                    break;

                case "weekly":
                    var weekStart = start;
                    while (weekStart <= end)
                    {
                        var weekEnd = weekStart.AddDays(6);
                        if (weekEnd > end) weekEnd = end;

                        var appointments = Context.Appointments
                            .Where(a => a.Date >= weekStart && a.Date <= weekEnd && a.StateMachine != "Canceled")
                            .Count();

                        var newClients = Context.Clients
                            .Where(c => c.CreatedDate >= weekStart && c.CreatedDate <= weekEnd)
                            .Count();

                        var workshops = Context.Workshops
                            .Where(w => w.StartDate >= weekStart && w.StartDate <= weekEnd && w.Status != "Canceled")
                            .Count();

                        if (appointments > 0 || newClients > 0 || workshops > 0)
                        {
                            result.Add(new ReportData
                            {
                                Date = weekStart,
                                Appointments = appointments,
                                NewClients = newClients,
                                Workshops = workshops
                            });
                        }

                        weekStart = weekStart.AddDays(7);
                    }
                    break;

                case "monthly":
                    var monthStart = new DateTime(start.Year, start.Month, 1);
                    var monthEnd = new DateTime(end.Year, end.Month, 1);

                    while (monthStart <= monthEnd)
                    {
                        var nextMonth = monthStart.AddMonths(1);
                        var actualEnd = nextMonth.AddDays(-1);

                        if (actualEnd > end) actualEnd = end;
                        if (monthStart < start) monthStart = start;

                        var appointments = Context.Appointments
                            .Where(a => a.Date >= monthStart && a.Date <= actualEnd && a.StateMachine != "Canceled")
                            .Count();

                        var newClients = Context.Clients
                            .Where(c => c.CreatedDate >= monthStart && c.CreatedDate <= actualEnd)
                            .Count();

                        var workshops = Context.Workshops
                            .Where(w => w.StartDate >= monthStart && w.StartDate <= actualEnd && w.Status != "Canceled")
                            .Count();

                        if (appointments > 0 || newClients > 0 || workshops > 0)
                        {
                            result.Add(new ReportData
                            {
                                Date = new DateTime(monthStart.Year, monthStart.Month, 1),
                                Appointments = appointments,
                                NewClients = newClients,
                                Workshops = workshops
                            });
                        }

                        monthStart = new DateTime(monthStart.Year, monthStart.Month, 1).AddMonths(1);
                    }
                    break;

                case "custom":
                default:
                    var allDates = Context.Appointments
                        .Where(a => a.Date >= start && a.Date <= end && a.StateMachine != "Canceled")
                        .Select(a => a.Date.Date)
                        .Union(Context.Clients
                            .Where(c => c.CreatedDate >= start && c.CreatedDate <= end)
                            .Select(c => c.CreatedDate.Date))
                        .Union(Context.Workshops
                            .Where(w => w.StartDate >= start && w.StartDate <= end && w.Status != "Canceled")
                            .Select(w => w.StartDate.Date))
                        .Distinct()
                        .OrderBy(d => d)
                        .ToList();

                    foreach (var date in allDates)
                    {
                        var appointments = Context.Appointments
                            .Where(a => a.Date.Date == date && a.StateMachine != "Canceled")
                            .Count();

                        var newClients = Context.Clients
                            .Where(c => c.CreatedDate.Date == date)
                            .Count();

                        var workshops = Context.Workshops
                            .Where(w => w.StartDate.Date == date && w.Status != "Canceled")
                            .Count();

                        result.Add(new ReportData
                        {
                            Date = date,
                            Appointments = appointments,
                            NewClients = newClients,
                            Workshops = workshops
                        });
                    }
                    break;
            }

            return result.OrderBy(r => r.Date).ToList();
        }

        public KpiData GetKpiData(DateTime start, DateTime end, string period)
        {
            var currentNewClients = Context.Clients
                 .Where(c => c.CreatedDate >= start && c.CreatedDate <= end)
                 .Count();

            var currentAppointments = Context.Appointments
                .Where(a => a.Date >= start && a.Date <= end && a.StateMachine != "Canceled")
                .Count();

            var currentWorkshops = Context.Workshops
                .Where(w => w.StartDate >= start && w.StartDate <= end && w.Status != "Canceled")
                .Count();

            var (prevStart, prevEnd) = PeriodHelper.GetPreviousPeriod(start, end, period);

            var previousNewClients = Context.Clients
                .Where(c => c.CreatedDate >= prevStart && c.CreatedDate <= prevEnd)
                .Count();

            var previousAppointments = Context.Appointments
                .Where(a => a.Date >= prevStart && a.Date <= prevEnd && a.StateMachine != "Canceled")
                .Count();

            var previousWorkshops = Context.Workshops
                .Where(w => w.StartDate >= prevStart && w.StartDate <= prevEnd && w.Status != "Canceled")
                .Count();

            var newClientsChange = PeriodHelper.CalculatePercentageChange(currentNewClients, previousNewClients);
            var appointmentsChange = PeriodHelper.CalculatePercentageChange(currentAppointments, previousAppointments);
            var workshopsChange = PeriodHelper.CalculatePercentageChange(currentWorkshops, previousWorkshops);

            return new KpiData
            {
                TotalNewClients = currentNewClients,
                TotalAppointments = currentAppointments,
                TotalWorkshops = currentWorkshops,
                NewClientsChange = newClientsChange,
                AppointmentsChange = appointmentsChange,
                WorkshopsChange = workshopsChange
            };
        }

        public string GetInsights(DateTime start, DateTime end)
        {
            if (start > end) throw new Exception("Start date must be before end date");

            var dailyCounts = Context.Appointments
                .Where(a => a.Date >= start && a.Date <= end)
                .GroupBy(a => a.Date.Date) 
                .Select(g => new
                {
                    Date = g.Key,
                    Count = g.Count()
                })
                .OrderByDescending(g => g.Count)
                .ToList();

            if (!dailyCounts.Any())
                return "No appointments found in the selected period.";

            var topDay = dailyCounts.First();

            return $"Most appointments conducted on {topDay.Date:MMMM dd} with {topDay.Count} examinations.";
        }
    }
}
