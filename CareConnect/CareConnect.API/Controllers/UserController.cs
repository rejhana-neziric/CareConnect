using CareConnect.API.Filters;
using CareConnect.Models.SearchObjects;
using CareConnect.Services;
using CareConnect.Services.Database;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace CareConnect.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    [Authorize]
    public class UserController : ControllerBase
    {
        protected readonly IUserService _userService;   

        public UserController(IUserService userService) 
        {
            _userService = userService;     
        }

        [HttpPost("login")]
        [AllowAnonymous] 
        public Models.Responses.User Login (string username, string password)
        {
            return _userService.Login(username, password);  
        }

        [HttpGet("permissions")]
        [PermissionAuthorize("GetPermission")]
        public List<string> GetPermissions(string username)
        {
            return _userService.GetPermissions(username); 
        }
    }
}
