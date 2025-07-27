using CareConnect.Models.Responses;
using System;
using System.Collections.Generic;
using System.Text;
using System.Text.Json.Serialization;
using static System.Collections.Specialized.BitVector32;

namespace CareConnect.Models.Requests
{
    public class EmployeeInsertRequest
    {
        public DateTime HireDate { get; set; }

        public string JobTitle { get; set; } = string.Empty;

        [JsonIgnore]
        public bool Employed { get; set; } = true; 

        [JsonIgnore]
        public DateTime CreatedAt { get; set; } = DateTime.Now;

        public UserInsertRequest User {  get; set; }

        public QualificationInsertRequest? Qualification { get; set; }
    }
}
