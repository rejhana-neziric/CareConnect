using System;
using System.Collections.Generic;
using System.Text;

namespace CareConnect.Models.Responses
{
    public class ServiceStatistics
    {
        public int TotalServices { get; set; }

        public decimal? AveragePrice { get; set; }

        public decimal? AverageMemberPrice { get; set; }

    }
}
