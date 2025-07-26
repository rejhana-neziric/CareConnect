using System;
using System.Collections.Generic;
using System.Text;

namespace CareConnect.Models.SearchObjects
{
    public class ClientsChildSearchObject : BaseSearchObject<ClientsChildAdditionalData>
    {
        public ClientSearchObject? clientSearchObject { get; set; }

        public ChildSearchObject? childSearchObject { get; set; }
    }
}
