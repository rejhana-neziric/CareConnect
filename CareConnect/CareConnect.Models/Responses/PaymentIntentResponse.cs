using System;
using System.Collections.Generic;
using System.Text;

namespace CareConnect.Models.Responses
{
    public class PaymentIntentResponse
    {
        public string ClientSecret { get; set; } = null!;

        public string PaymentIntentId { get; set; } = null!;

        public decimal Amount { get; set; }

        public string Currency { get; set; } = null!;
    }
}
