using CareConnect.Models.Requests;
using CareConnect.Models.Responses;
using CareConnect.Services.Database;
using CareConnect.Services.Helpers;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace CareConnect.Services
{
    public class RolePermissionsService : IRolePermissionsService
    {
        private readonly CareConnectContext _context;

        private readonly ILogger<RolePermissionsService> _logger;

        public RolePermissionsService(CareConnectContext context, ILogger<RolePermissionsService> logger)
        {
            _context = context;
            _logger = logger;
        }


        public async Task<List<Models.Responses.Role>> GetAllRoles()
        {
            var roles = await _context.Roles
                   .Include(r => r.Permissions)
                   .Include(r => r.UsersRoles)
                   .Select(r => new Models.Responses.Role
                   {
                       RoleId = r.RoleId,
                       Name = r.Name,
                       Description = r.Description,
                       UserCount = r.UsersRoles.Count,
                       PermissionIds = r.Permissions.Select(p => p.PermissionId).ToList()
                   })
                   .OrderBy(r => r.Name)
                   .ToListAsync();

            return roles; 
        }

        public async Task<List<Models.Responses.Permission>> GetAllPermissions()
        {
            var permissions = await _context.Permissions
                  .Select(p => new Models.Responses.Permission
                  {
                      PermissionId = p.PermissionId,
                      Name = p.Name,
                      Category = PermissionNameParser.ParseCategory(p.Name),
                      Resource = PermissionNameParser.ParseResource(p.Name),
                      Action = PermissionNameParser.ParseAction(p.Name)
                  })
                  .OrderBy(p => p.Category)
                  .ThenBy(p => p.Resource)
                  .ThenBy(p => p.Action)
                  .ToListAsync();

            return permissions;
        }

        public async Task<List<PermissionGroup>> GetGroupedPermissions()
        {
             var permissions = await _context.Permissions
                    .Select(p => new Models.Responses.Permission
                    {
                        PermissionId = p.PermissionId,
                        Name = p.Name,
                        Category = PermissionNameParser.ParseCategory(p.Name), 
                        Resource = PermissionNameParser.ParseResource(p.Name), 
                        Action = PermissionNameParser.ParseAction(p.Name)      
                    })
                   .ToListAsync();

                var grouped = permissions
                    .GroupBy(p => p.Resource)
                    .Select(g => new PermissionGroup
                    {
                        Category = g.Key, 
                        Permissions = g.OrderBy(p => p.Action).ToList()
                    })
                    .OrderBy(g => g.Category)
                    .ToList();

            return grouped;
        }

        public async Task<RolePermissionsResponse> GetRolePermissions(int roleId)
        {
            var role = await _context.Roles
                  .Include(r => r.Permissions)
                  .Include(r => r.UsersRoles)
                  .FirstOrDefaultAsync(r => r.RoleId == roleId);

            if (role == null) return null; 

            var allPermissions = await _context.Permissions
                .Select(p => new Models.Responses.Permission
                {
                    PermissionId = p.PermissionId,
                    Name = p.Name,
                    Category = PermissionNameParser.ParseCategory(p.Name),
                    Resource = PermissionNameParser.ParseResource(p.Name),
                    Action = PermissionNameParser.ParseAction(p.Name)
                })
                .ToListAsync();

            var assignedPermissionIds = role.Permissions.Select(p => p.PermissionId).ToList();

            var response = new RolePermissionsResponse
            {
                Role = new Models.Responses.Role
                {
                    RoleId = role.RoleId,
                    Name = role.Name,
                    Description = role.Description,
                    UserCount = role.UsersRoles.Count,
                    PermissionIds = assignedPermissionIds
                },
                AllPermissions = allPermissions,
                AssignedPermissions = allPermissions
                    .Where(p => assignedPermissionIds.Contains(p.PermissionId))
                    .ToList()
            };

            return response;
        }

        public async Task<(bool Success, string? Message, List<int>? InvalidIds)> UpdateRolePermissionsAsync(UpdateRolePermissionsRequest request)
        {
            var role = await _context.Roles
                .Include(r => r.Permissions)
                .FirstOrDefaultAsync(r => r.RoleId == request.RoleId);

            if (role == null)
            {
                return (false, $"Role with ID {request.RoleId} not found", null);
            }

            var validPermissionIds = await _context.Permissions
                .Where(p => request.PermissionIds.Contains(p.PermissionId))
                .Select(p => p.PermissionId)
                .ToListAsync();

            var invalidIds = request.PermissionIds.Except(validPermissionIds).ToList();

            if (invalidIds.Any())
            {
                return (false, "Invalid permission IDs provided", invalidIds);
            }

            var newPermissions = await _context.Permissions
                .Where(p => request.PermissionIds.Contains(p.PermissionId))
                .ToListAsync();

            role.Permissions.Clear();

            foreach (var permission in newPermissions)
            {
                role.Permissions.Add(permission);
            }

            try
            {
                await _context.SaveChangesAsync();
                _logger.LogInformation("Updated permissions for role {RoleId}. Assigned {Count} permissions",
                    request.RoleId, newPermissions.Count);

                return (true, null, null);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error updating permissions for role {RoleId}", request.RoleId);
                return (false, "Unexpected error updating permissions", null);
            }
        }

    }
}
