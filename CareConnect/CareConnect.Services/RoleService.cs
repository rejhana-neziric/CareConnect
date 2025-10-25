using CareConnect.Models.Requests;
using CareConnect.Models.SearchObjects;
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
    public class RoleService : BaseCRUDService<Models.Responses.Role, RoleSearchObject, RoleAdditionalData, Role, RoleInsertRequest, RoleUpdateRequest>, IRoleService
    {
        public RoleService(CareConnectContext context, IMapper mapper) : base(context, mapper) { }

        protected override void AddInclude(RoleAdditionalData additionalData, ref IQueryable<Role> query)
        {
            if (additionalData != null)
            {
                if (additionalData.IsPermissionIncluded.HasValue && additionalData.IsPermissionIncluded == true)
                {
                    additionalData.IncludeList.Add("Permissions");
                }
            }

            base.AddInclude(additionalData, ref query);
        }

        public override Role GetByIdWithIncludes(int id)
        {
            return Context.Roles
                .Include(p => p.Permissions)
                .First(r => r.RoleId == id);
        }

        public Models.Responses.Role AssignPermission(int id, List<string> permissions)
        {
            var entity = Context.Roles.Include(x => x.Permissions).FirstOrDefault(x => x.RoleId == id);

            if (entity == null) return null; 

            var entityPermissions = entity.Permissions.Select(x => x.Name).ToList();

            foreach(var permission in permissions) 
            {
                if(!entityPermissions.Contains(permission))
                {
                    entity.Permissions.Add(new Permission { Name = permission });   
                }
            }

            Context.SaveChanges();  

            return Mapper.Map<Models.Responses.Role>(entity);   
        }


    }
}
