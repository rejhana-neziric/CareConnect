using System;

namespace CareConnect.Models.Responses
{
    public class PaymentStatus
    {
        public string Name { get; set; } = null!;

        public DateTime ModifiedDate { get; set; }
    }
}
