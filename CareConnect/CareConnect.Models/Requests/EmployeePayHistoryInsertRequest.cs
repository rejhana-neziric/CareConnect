using System;
using System.Text.Json.Serialization;

namespace CareConnect.Models.Requests
{
    public class EmployeePayHistoryInsertRequest
    {
        public int EmployeeId { get; set; }

        public DateTime RateChangeDate { get; set; }

        public decimal Rate { get; set; }

        [JsonIgnore]
        public DateTime ModifiedDate { get; set; } = DateTime.Now; 
    }
}
