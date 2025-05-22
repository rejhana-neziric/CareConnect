using CareConnect.Models.Requests;
using CareConnect.Models.SearchObjects;
using CareConnect.Models.Responses;
using CareConnect.Services;
using Microsoft.AspNetCore.Mvc;

namespace CareConnect.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class UsersRoleController : BaseCRUDController<UsersRole, UsersRoleSearchObject, UsersRoleAdditionalData, UsersRoleInsertRequest, UsersRoleUpdateRequest>
    {
        public UsersRoleController(IUsersRoleService service) : base(service) { }
    }
}
