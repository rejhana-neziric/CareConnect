using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace CareConnect.Models.Requests
{
    public class EnrollmentRequest
    {
        public int ClientId { get; set; }

        public int? ChildId { get; set; }

        public int WorkshopId { get; set; }

        public string? PaymentIntentId { get; set; } // null for free workshops
    }
}

