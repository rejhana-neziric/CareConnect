using System; 

namespace CareConnect.Models.Responses
{
    public class Payment
    {
        public decimal Amount { get; set; }

        public DateTime PaymentDate { get; set; }

        public DateTime ModifiedDate { get; set; }

        public virtual PaymentPurpose PaymentPurpose { get; set; } = null!;

        public virtual PaymentStatus PaymentStatus { get; set; } = null!;

        public virtual User User { get; set; } = null!;
    }
}