using System;
using System.Collections.Generic;
using System.Text;

namespace CareConnect.Models.Responses
{
    public class Client
    {
        public bool EmploymentStatus { get; set; }

        public virtual User User { get; set; } = null!;
    }
}
