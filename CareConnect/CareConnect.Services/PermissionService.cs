using CareConnect.Services.Database;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareConnect.Services
{
    public class PermissionService : IPermissionService
    {
        private readonly CareConnectContext _context;
        private readonly ILogger<PermissionService> _logger;

        public PermissionService(
            CareConnectContext context,
            ILogger<PermissionService> logger)
        {
            _context = context;
            _logger = logger;
        }

        public async Task<bool> UserHasPermissionAsync(int userId, string permissionName)
        {
            try
            {
                var hasPermission = await _context.UsersRoles
                    .Where(ur => ur.UserId == userId)
                    .SelectMany(ur => ur.Role.Permissions)
                    .AnyAsync(p => p.Name == permissionName);

                return hasPermission;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error checking permission {Permission} for user {UserId}",
                    permissionName, userId);
                return false;
            }
        }

        public async Task<List<string>> GetUserPermissionsAsync(int userId)
        {
            try
            {
                var permissions = await _context.UsersRoles
                    .Where(ur => ur.UserId == userId)
                    .SelectMany(ur => ur.Role.Permissions)
                    .Select(p => p.Name)
                    .Distinct()
                    .ToListAsync();

                return permissions;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting permissions for user {UserId}", userId);
                return new List<string>();
            }
        }

        public async Task<bool> RoleHasPermissionAsync(int roleId, string permissionName)
        {
            try
            {
                var hasPermission = await _context.Roles
                    .Where(r => r.RoleId == roleId)
                    .SelectMany(r => r.Permissions)
                    .AnyAsync(p => p.Name == permissionName);

                return hasPermission;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error checking permission {Permission} for role {RoleId}",
                    permissionName, roleId);
                return false;
            }
        }
    }
}
