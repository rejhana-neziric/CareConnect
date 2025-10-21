using System;
using System.Collections.Generic;
using System.Text;

namespace CareConnect.Models.Requests
{
    public class ChangePasswordRequest
    {
        public int UserId { get; set; } 

        public string OldPassword { get; set; } = null!;
        
        public string NewPassword { get; set; } = null!;
    }
}
