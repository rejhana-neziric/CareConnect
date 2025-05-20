using System;
using System.Collections.Generic;
using System.Text;

namespace CareConnect.Models.Responses
{
    public class Client
    {
        public bool EmploymentStatus { get; set; }

        public virtual User User { get; set; } = null!;

        //public virtual ICollection<ClientsChild> ClientsChildren { get; set; } = new List<ClientsChild>();
        //public virtual ICollection<Child> Children { get; set; } = new List<Child>();

    }
}
