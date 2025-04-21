using System;
using System.Collections.Generic;
using System.Text;

namespace CareConnect.Models.Responses
{
    public partial class Client
    {
        public int ClientId { get; set; }

        public virtual User User { get; set; } = null!;

        public bool EmploymentStatus { get; set; }

        public DateTime ModifiedDate { get; set; }
    }
}
