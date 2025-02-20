using System;
using System.Collections.Generic;
using System.Text;

namespace CareConnect.Models.Requests
{
    public class EmployeeUpdateRequest
    {
        public string FirstName { get; set; }

        public string LastName { get; set; }

        public string Password { get; set; }

        public string ConfirmationPassword { get; set; }
    }
}
