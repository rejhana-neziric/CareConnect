using CareConnect.API.Filters;
using CareConnect.Models.Requests;
using CareConnect.Models.Responses;
using CareConnect.Services;
using CareConnect.Services.Database;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;


namespace CareConnect.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class RolePermissionsController : ControllerBase
    {
        private readonly CareConnectContext _context;

        private readonly ILogger<RolePermissionsController> _logger;

        private readonly IRolePermissionsService _service; 

        public RolePermissionsController(CareConnectContext context, ILogger<RolePermissionsController> logger, IRolePermissionsService service)
        {
            _context = context;
            _logger = logger;
            _service = service;
        }

        [HttpGet("roles")]
        [PermissionAuthorize("GetAllRoles")]
        public async Task<ActionResult<List<Models.Responses.Role>>> GetAllRoles()
        {
            try
            {
                var roles = await _service.GetAllRoles();   

                return Ok(roles);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error fetching roles");
                return StatusCode(500, new { message = "An error occurred while fetching roles" });
            }
        }

        [HttpGet("permissions")]
        [PermissionAuthorize("GetAllPermissions")]
        public async Task<ActionResult<List<Models.Responses.Permission>>> GetAllPermissions()
        {
            try
            {
                var permissions = await _service.GetAllPermissions();   

                return Ok(permissions);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error fetching permissions");
                return StatusCode(500, new { message = "An error occurred while fetching permissions" });
            }
        }

        [HttpGet("permissions/grouped")]
        [PermissionAuthorize("GetGroupedPermissions")]
        public async Task<ActionResult<List<PermissionGroup>>> GetGroupedPermissions()
        {
            try
            {
                var grouped = await _service.GetGroupedPermissions();    

                return Ok(grouped);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error fetching grouped permissions");
                return StatusCode(500, new { message = "An error occurred while fetching permissions" });
            }
        }

        [HttpGet("role/{roleId}")]
        [PermissionAuthorize("GetRolePermissions")]
        public async Task<ActionResult<RolePermissionsResponse>> GetRolePermissions(int roleId)
        {
            try
            {
                var response = _service.GetRolePermissions(roleId);

                return Ok(response);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error fetching role permissions for role {RoleId}", roleId);
                return StatusCode(500, new { message = "An error occurred while fetching role permissions" });
            }
        }

        [HttpPut("role/{roleId}")]
        [PermissionAuthorize("UpdateRolePermissions")]
        public async Task<IActionResult> UpdateRolePermissions(
            int roleId,
            [FromBody] UpdateRolePermissionsRequest request)
        {

            if (roleId != request.RoleId)
                return BadRequest(new { message = "Role ID mismatch" });

            var result = await _service.UpdateRolePermissionsAsync(request);

            if (!result.Success)
            {
                if (result.InvalidIds != null)
                {
                    return BadRequest(new { message = result.Message, invalidIds = result.InvalidIds });
                }

                if (result.Message != null && result.Message.Contains("not found"))
                {
                    return NotFound(new { message = result.Message });
                }

                return StatusCode(500, new { message = result.Message });
            }

            return NoContent();
        }
    }

}
