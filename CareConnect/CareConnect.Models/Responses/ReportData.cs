using System;
using System.Collections.Generic;
using System.Text;

namespace CareConnect.Models.Responses
{
    public class ReportData
    {
        public DateTime Date { get; set; }

        public int NewClients { get; set; }

        public int Appointments { get; set; }

        public int Workshops { get; set; }
    }
}
