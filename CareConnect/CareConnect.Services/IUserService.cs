using CareConnect.Models.Requests;
using CareConnect.Models.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareConnect.Services
{
    public interface IUserService : ICRUDService<Models.Responses.User, BaseSearchObject<BaseAdditionalSearchRequestData>, BaseAdditionalSearchRequestData, UserInsertRequest, UserUpdateRequest>
    { 
        public Models.Responses.User Login (string username, string password);

        public List<string> GetPermissions(string username);

        public bool ChangePassword(ChangePasswordRequest request);

        public Task<List<Models.Responses.Role>?> GetRolesForUser(int userId);

        public Task<(bool Success, string Message)> AddRoleToUserAsync(int userId, int roleId);

        Task<(bool Success, string Message)> RemoveRoleFromUserAsync(int userId, int roleId);
    }
}
