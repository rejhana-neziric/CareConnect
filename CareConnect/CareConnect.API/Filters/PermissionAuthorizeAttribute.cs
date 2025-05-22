using Microsoft.AspNetCore.Mvc;

namespace CareConnect.API.Filters
{
    public class PermissionAuthorizeAttribute : TypeFilterAttribute
    {
        public PermissionAuthorizeAttribute(string action) : base(typeof(PermissionAuthorizeFilter))
        {
            Arguments = new object[] { action };    
        }
    }
}
