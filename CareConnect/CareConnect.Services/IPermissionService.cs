using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareConnect.Services
{
    public interface IPermissionService
    {
        Task<bool> UserHasPermissionAsync(int userId, string permissionName);

        Task<List<string>> GetUserPermissionsAsync(int userId);
        
        Task<bool> RoleHasPermissionAsync(int roleId, string permissionName);
    }
}
