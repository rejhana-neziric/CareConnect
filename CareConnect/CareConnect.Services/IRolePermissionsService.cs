using CareConnect.Models.Requests;
using CareConnect.Models.Responses;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareConnect.Services
{
    public interface IRolePermissionsService
    {
        public Task<List<Models.Responses.Role>> GetAllRoles();

        public Task<List<Models.Responses.Permission>> GetAllPermissions();

        public Task<List<PermissionGroup>> GetGroupedPermissions();

        public Task<RolePermissionsResponse> GetRolePermissions(int roleId);

        Task<(bool Success, string? Message, List<int>? InvalidIds)> UpdateRolePermissionsAsync(UpdateRolePermissionsRequest request);
    }
}
