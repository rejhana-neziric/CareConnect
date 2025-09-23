using CareConnect.Models.Enums;
using System;
using System.Collections.Generic;
using System.Text;

namespace CareConnect.Models.Responses
{
    public class Enrollment
    {
        public int EnrollmentId { get; set; }

        public int ClientId { get; set; }

        public int? ChildId { get; set; }

        public int WorkshopId { get; set; }
        
        public EnrollmentStatus Status { get; set; }
        
        public long AmountInCents { get; set; }
        
        public string StripePaymentIntentId { get; set; }
        
        public DateTime CreatedAt { get; set; }
        
        public DateTime? CompletedAt { get; set; }
    }
}
