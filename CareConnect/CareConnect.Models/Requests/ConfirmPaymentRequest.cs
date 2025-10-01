using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace CareConnect.Models.Requests
{
    public class ConfirmPaymentRequest
    {
        public string PaymentIntentId { get; set; }

        public string UserId { get; set; }

        public string Type { get; set; }

        public int ItemId { get; set; }
    }
}
