using CareConnect.Models.Responses;
using CareConnect.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareConnect.Services
{
    public class UserService : IUserService
    {
        public CareConnectContext Context { get; set; }

        public IMapper Mapper { get; }

        public UserService(CareConnectContext context, IMapper mapper)
        {
            Context = context; 
            Mapper = mapper;    
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
    }
}
