using System;
using System.Collections.Generic;
using System.Text;

namespace CareConnect.Models.Responses
{
    public class KpiData
    {
        public int TotalNewClients { get; set; }

        public int TotalAppointments { get; set; }
        
        public int TotalWorkshops { get; set; }
        
        public double NewClientsChange { get; set; }
        
        public double AppointmentsChange { get; set; }
        
        public double WorkshopsChange { get; set; }
    }
}
