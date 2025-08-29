using System;
using System.Collections.Generic;
using System.Text;

namespace CareConnect.Models.Requests
{
    public class EmployeeAvailabilityChanges
    {
        public List<EmployeeAvailabilityInsertRequest> toCreate { get; set; } = new List<EmployeeAvailabilityInsertRequest>();  


        public Dictionary<int, EmployeeAvailabilityUpdateRequest> toUpdate { get; set; } = new Dictionary<int, EmployeeAvailabilityUpdateRequest>();


        public List<int> toDelete { get; set; } = new List<int>();
    }
}
