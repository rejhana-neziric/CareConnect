using System; 

namespace CareConnect.Models.Responses
{
    public class Payment
    {
        public decimal Amount { get; set; }

        public DateTime PaymentDate { get; set; }

        public DateTime ModifiedDate { get; set; }

        public string Status { get; set; }

        public virtual User User { get; set; } = null!;
    }
}