using System;

namespace CareConnect.Models.Responses
{
    public class ClientsChild
    {
        public DateTime ModifiedDate { get; set; }

        public virtual Child Child { get; set; } = null!;

        public virtual Client Client { get; set; } = null!;

        //public DateTime? LastAppointment { get; set; }
    }
}
