using CareConnect.Models.Enums;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareConnect.Services.Database
{
    public class Enrollment
    {
        public int EnrollmentId { get; set; }

        public int ClientId { get; set; }

        public int? ChildId { get; set; }

        public int WorkshopId { get; set; }

        public EnrollmentStatus Status { get; set; }

        public long Amount { get; set; }

        public Models.Enums.PaymentStatus PaymentStatus { get; set; }

        public string? StripePaymentIntentId { get; set; }

        public DateTime CreatedAt { get; set; }

        public DateTime? CompletedAt { get; set; }

        public virtual Client Client { get; set; } = null!;

        public virtual Child? Child { get; set; }

        public virtual Workshop Workshop { get; set; } = null!;
    }
}
