using CareConnect.Models.Requests;
using CareConnect.Models.SearchObjects;
using CareConnect.Models.Responses;
using CareConnect.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using CareConnect.API.Filters;

namespace CareConnect.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class RoleController : BaseCRUDController<Role, RoleSearchObject, RoleAdditionalData, RoleInsertRequest, RoleUpdateRequest>
    {
        public RoleController(IRoleService service) : base(service) { }

        [HttpPost("{id}/permissions")]
        [PermissionAuthorize("AssignPermission")]
        public Role AssignPermission(int id, List<string> permissions)
        {
            return (_service as RoleService)!.AssignPermission(id, permissions); 
        }
    }
}
