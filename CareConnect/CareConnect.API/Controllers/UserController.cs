using CareConnect.API.Filters;
using CareConnect.Models.Requests;
using CareConnect.Models.SearchObjects;
using CareConnect.Services;
using CareConnect.Services.Database;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

namespace CareConnect.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    [Authorize]
    public class UserController :  BaseCRUDController<Models.Responses.User, BaseSearchObject<BaseAdditionalSearchRequestData>, BaseAdditionalSearchRequestData, UserInsertRequest, UserUpdateRequest>
    {

        public UserController(IUserService service) : base(service)
        {
        }

        [HttpPost("login")]
        [AllowAnonymous] 
        public Models.Responses.User Login (string username, string password)
        {
            return (_service as IUserService)!.Login(username, password);  
        }

        [HttpGet("permissions")]
        [AllowAnonymous]
        public List<string> GetPermissions(string username)
        {
            return (_service as IUserService)!.GetPermissions(username); 
        }

        [HttpPost("change-password")]
        [PermissionAuthorize("ChangePassword")]
        public bool ChangePassword([FromBody] ChangePasswordRequest request)
        {
            return (_service as IUserService)!.ChangePassword(request); 
        }

        [HttpGet("{userId}/roles")]
        [PermissionAuthorize("GetRolesForUser")]
        public async Task<IActionResult> GetRolesForUser(int userId)
        { 

            var roles = await (_service as IUserService)!.GetRolesForUser(userId);    

            return Ok(roles);
        }

        [HttpPost("{userId}/roles/{roleId}")]
        [PermissionAuthorize("AddRoleToUser")]
        public async Task<IActionResult> AddRoleToUser(int userId, int roleId)
        {
            var result = await (_service as IUserService)!.AddRoleToUserAsync(userId, roleId);

            if (!result.Success)
                return BadRequest(new { message = result.Message });

            return Ok(result.Message);
        }

        [HttpDelete("{userId}/roles/{roleId}")]
        [PermissionAuthorize("RemoveRoleFromUser")]
        public async Task<IActionResult> RemoveRoleFromUser(int userId, int roleId)
        {
            var result = await (_service as IUserService)!.RemoveRoleFromUserAsync(userId, roleId);

            if (!result.Success)
                return BadRequest(new { message = result.Message });

            return Ok(new { message = result.Message });
        }
    }
}
