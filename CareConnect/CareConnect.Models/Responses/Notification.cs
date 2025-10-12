using System;
using System.Collections.Generic;
using System.Text;

namespace CareConnect.Models.Responses
{
    public class Notification
    {
        public string Title { get; set; }

        public string Body { get; set; }

        public string Type { get; set; }

        public Dictionary<string, object> Data { get; set; }
    }
}
