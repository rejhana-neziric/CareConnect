using System;
using System.Text.Json.Serialization;

namespace CareConnect.Models.Requests
{
    public class ChildUpdateRequest
    {

        [JsonIgnore]
        public DateTime ModifiedDate { get; set; } = DateTime.Now;
    }   
}