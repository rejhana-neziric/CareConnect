using System;
using System.Collections.Generic;
using System.Text;

namespace CareConnect.Models.Requests
{
    public class PaymentIntentRequest
    {
        public int ClientId { get; set; }

        public int? ChildId { get; set; }

        public int? ItemId { get; set; } // workshop

        public string ItemType { get; set; } = null!;  // "workshop" or "appointment"

        public AppointmentInsertRequest? Appointment { get; set; }
    }
}
