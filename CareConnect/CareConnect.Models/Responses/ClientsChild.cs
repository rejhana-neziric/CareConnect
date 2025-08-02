using System;
using System.Collections.Generic;

namespace CareConnect.Models.Responses
{
    public class ClientsChild
    {

        public virtual Child Child { get; set; } = null!;

        public virtual Client Client { get; set; } = null!;

        //public DateTime? LastAppointment { get; set; }

        public virtual ICollection<Appointment> Appointments { get; set; } = new List<Appointment>();

    }
}
