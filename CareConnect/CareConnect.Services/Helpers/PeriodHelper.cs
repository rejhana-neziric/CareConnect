using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareConnect.Services.Helpers
{
    public static class PeriodHelper
    {
        public static (DateTime start, DateTime end) GetPreviousPeriod(DateTime start, DateTime end, string period)
        {
            var duration = end - start;

            switch (period?.ToLower())
            {
                case "daily":
                    return (start.AddDays(-1), start.AddDays(-1));

                case "weekly":
                    return (start.AddDays(-7), end.AddDays(-7));

                case "monthly":
                    var monthsToSubtract = ((end.Year - start.Year) * 12) + end.Month - start.Month;
                    if (monthsToSubtract == 0) monthsToSubtract = 1; 

                    var prevStart = start.AddMonths(-monthsToSubtract);
                    var prevEnd = end.AddMonths(-monthsToSubtract);
                    return (prevStart, prevEnd);

                case "custom":
                default:
                    return (start.Subtract(duration).AddDays(-1), start.AddDays(-1));
            }
        }

        public static double CalculatePercentageChange(int current, int previous)
        {
            if (previous == 0)
            {
                return current > 0 ? 100.0 : 0.0;
            }

            return Math.Round(((double)(current - previous) / previous) * 100.0, 1);
        }
    }
}
