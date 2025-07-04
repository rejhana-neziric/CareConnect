using System;
using System.Collections.Generic;
using System.Text;

namespace CareConnect.Models.Responses
{
    public class AttendanceStatus
    {
        public int AttendanceStatusId { get; set; }

        public string Name { get; set; } = null!;

        public DateTime ModifiedDate { get; set; }
    }
}
