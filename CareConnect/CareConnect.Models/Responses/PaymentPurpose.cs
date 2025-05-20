using System;

namespace CareConnect.Models.Responses
{
    public class PaymentPurpose
    {
        public string Name { get; set; } = null!;

        public DateTime ModifiedDate { get; set; }
    }
}
