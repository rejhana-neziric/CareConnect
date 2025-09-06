using CareConnect.API.Filters;
using CareConnect.Models.Responses;
using CareConnect.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace CareConnect.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    [Authorize]
    public class ReportController
    {
        protected readonly IReportService _reportService;

        public ReportController(IReportService reportService)
        {
            _reportService = reportService;
        }

        [HttpGet("data")]
        [PermissionAuthorize("GetReportData")]
        public List<ReportData> GetReportData([FromQuery] DateTime start_date, [FromQuery] DateTime end_date, [FromQuery] string period)
        {
            return _reportService.GetReportData(start_date, end_date, period);   
        }

        [HttpGet("kpi")]
        [PermissionAuthorize("GetKPI")]
        public KpiData GetKPI([FromQuery] DateTime start_date, [FromQuery] DateTime end_date, [FromQuery] string period)
        {
            return _reportService.GetKpiData(start_date, end_date, period); 
        }

        [HttpGet("insights")]
        [PermissionAuthorize("GetInsights")]
        public string GetInsights([FromQuery] DateTime start_date, [FromQuery] DateTime end_date)
        {
            return _reportService.GetInsights(start_date, end_date);   
        }
    }
}
