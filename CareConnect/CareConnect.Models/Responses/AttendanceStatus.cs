using System;
using System.Collections.Generic;
using System.Text;

namespace CareConnect.Models.Responses
{
    public class AttendanceStatus
    {
        public string Name { get; set; } = null!;

        public DateTime ModifiedDate { get; set; }
    }
}
