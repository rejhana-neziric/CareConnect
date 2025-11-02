using CareConnect.Models.Requests;
using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;
using CareConnect.Services.Database;
using CareConnect.Services.Helpers;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.ML;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace CareConnect.Services
{
    public class UserService : BaseCRUDService<Models.Responses.User, BaseSearchObject<BaseAdditionalSearchRequestData>, BaseAdditionalSearchRequestData, Database.User, UserInsertRequest, UserUpdateRequest>, IUserService
    {
        public UserService(CareConnectContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public Models.Responses.User Login(string username, string password)
        {
            var entity = Context.Users.Include(x => x.UsersRoles)
                                      .ThenInclude(x => x.Role)
                                      .FirstOrDefault(x => x.Username == username);

            if (entity == null) return null; 

            var hash = Helpers.SecurityHelper.GenerateHash(entity.PasswordSalt, password);

            if (hash != entity.PasswordHash) return null; 

            return Mapper.Map<Models.Responses.User>(entity);    
        }

        public List<string> GetPermissions(string username)
        {
            var entity = Context.Users.Include(x => x.UsersRoles).ThenInclude(x => x.Role).ThenInclude(x => x.Permissions).FirstOrDefault(x => x.Username == username);

            if (entity == null) return null; 

            var permissions = new List<string>();   

            foreach(var role in entity.UsersRoles)
            {
                foreach(var permission in role.Role.Permissions) 
                {
                    permissions.Add(permission.Name);   
                }
            }

            return permissions;
        }

        public override void BeforeInsert(UserInsertRequest request, Database.User entity)
        {
            if (request.Password != request.ConfirmationPassword)
                throw new Exception("Password and confirmation password must be same.");

            entity.PasswordSalt = SecurityHelper.GenerateSalt();
            entity.PasswordHash = SecurityHelper.GenerateHash(entity.PasswordSalt, request.Password);

            base.BeforeInsert(request, entity);
        }

        public bool ChangePassword(ChangePasswordRequest request)
        {
            var user = Context.Users.FirstOrDefault(x => x.UserId == request.UserId); 

            if (user == null) return false;

            var oldHash = SecurityHelper.GenerateHash(user.PasswordSalt, request.OldPassword);

            if (oldHash != user.PasswordHash) return false; 

            var newSalt = SecurityHelper.GenerateSalt();
            var newHash = SecurityHelper.GenerateHash(newSalt, request.NewPassword);

            user.PasswordSalt = newSalt;
            user.PasswordHash = newHash;
            user.ModifiedDate = DateTime.Now;

            Context.SaveChanges();

            return true;
        }

        public async Task<List<Models.Responses.Role>?> GetRolesForUser(int userId)
        {
            var user = await Context.Users.Include(x => x.UsersRoles).ThenInclude(x => x.Role).FirstOrDefaultAsync(x => x.UserId== userId);

            if (user == null) return null;

            var roles = await Context.Roles
                .Include(r => r.Permissions)
                .Include(r => r.UsersRoles)
                .Where(r => r.UsersRoles.Any(ur => ur.UserId == userId)) 
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

        public async Task<(bool Success, string Message)> AddRoleToUserAsync(int userId, int roleId)
        {
            var user = await Context.Users
                .Include(u => u.UsersRoles)
                .FirstOrDefaultAsync(u => u.UserId == userId);

            if (user == null)
                return (false, $"User with ID {userId} not found");

            var role = await Context.Roles.FirstOrDefaultAsync(r => r.RoleId == roleId);
            if (role == null)
                return (false, $"Role with ID {roleId} not found");

            var alreadyHasRole = user.UsersRoles.Any(ur => ur.RoleId == roleId);
            if (alreadyHasRole)
                return (false, "User already has this role");

            user.UsersRoles.Add(new Database.UsersRole
            {
                UserId = userId,
                RoleId = roleId
            });

            await Context.SaveChangesAsync();

            return (true, $"Role '{role.Name}' added to user successfully");
        }

        public async Task<(bool Success, string Message)> RemoveRoleFromUserAsync(int userId, int roleId)
        {
            var user = await Context.Users
                .Include(u => u.UsersRoles)
                .FirstOrDefaultAsync(u => u.UserId == userId);

            if (user == null)
                return (false, $"User with ID {userId} not found");

            var userRole = user.UsersRoles.FirstOrDefault(ur => ur.RoleId == roleId);

            if (userRole == null)
                return (false, "User does not have this role");

            Context.UsersRoles.Remove(userRole);
            await Context.SaveChangesAsync();

            return (true, $"Role removed from user successfully");
        }
    }
}
