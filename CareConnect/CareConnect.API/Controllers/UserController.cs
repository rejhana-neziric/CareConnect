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
    }
}
