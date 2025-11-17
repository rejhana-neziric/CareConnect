using CareConnect.Models.Requests;
using CareConnect.Models.SearchObjects;
using CareConnect.Services.Database;
using MapsterMapper;
using Microsoft.AspNet.SignalR.Client.Http;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;
using static Permissions;

namespace CareConnect.Services
{
    public class RoleService : BaseCRUDService<Models.Responses.Role, RoleSearchObject, RoleAdditionalData, Database.Role, RoleInsertRequest, RoleUpdateRequest>, IRoleService
    {
        public RoleService(CareConnectContext context, IMapper mapper) : base(context, mapper) { }

        protected override void AddInclude(RoleAdditionalData additionalData, ref IQueryable<Database.Role> query)
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

        public override Database.Role GetByIdWithIncludes(int id)
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

        public virtual object Delete(int id)
        {
            var entity = GetByIdWithIncludes(id);

            if (entity == null) return new { success = false, message = "Not found." };

            try
            {
                BeforeDelete(entity);

                var count = Context.Database
                    .SqlQuery<int>($"SELECT COUNT(*) as Value FROM RolePermissions WHERE RoleId = {id}")
                    .FirstOrDefault();

                bool hasChildren = count > 0;

                if (hasChildren) return new { success = false, message = "Sorry, you cannot delete this item because it is referenced by other records." };


                Context.Set<Database.Role>().Remove(entity);
                Context.SaveChanges();

                AfterDelete(id);

                return new { success = true, message = "Deleted successfully." };
            }
            catch (DbUpdateException ex)
            {
                if (ex.InnerException != null &&
                   (ex.InnerException.Message.Contains("REFERENCE constraint") ||
                    ex.InnerException.Message.Contains("FOREIGN KEY constraint")))
                {
                    return new { success = false, message = "Sorry, you cannot delete this item because it is referenced by other records." };
                }

                return new { success = false, message = "An error occurred while deleting." };
            }
        }
    }
}
