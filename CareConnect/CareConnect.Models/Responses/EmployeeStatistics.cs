using System;
using System.Collections.Generic;
using System.Text;

namespace CareConnect.Models.Responses
{
    public class EmployeeStatistics
    {
        public int TotalEmployees { get; set; }

        public int EmployedThisMonth { get; set; }

        public int CurrentlyEmployed { get; set; }
    }
}
