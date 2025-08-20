using System;
using System.Collections.Generic;
using System.Text;

namespace CareConnect.Models.Responses
{
    public class WorkshopStatistics
    {
        public int TotalWorkshops { get; set; }

        public int Upcoming { get; set; }

        public int AverageParticipants { get; set; }
    }
}
