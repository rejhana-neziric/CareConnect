using CareConnect.Models.Responses;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareConnect.Services
{
    public interface IReportService
    {
        List<ReportData> GetReportData(DateTime start, DateTime end, string period);
        
        KpiData GetKpiData(DateTime start, DateTime end, string period);
        
        string GetInsights(DateTime start, DateTime end);
    }
}
