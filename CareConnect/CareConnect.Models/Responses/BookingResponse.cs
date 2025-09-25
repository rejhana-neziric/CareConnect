using System;
using System.Collections.Generic;
using System.Text;

namespace CareConnect.Models.Responses
{
    public class BookingResponse
    {
        public bool Success { get; set; }

        public string Message { get; set; } = string.Empty;
    }
}
