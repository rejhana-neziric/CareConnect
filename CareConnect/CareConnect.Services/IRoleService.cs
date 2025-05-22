using CareConnect.Models.Requests;
using CareConnect.Models.SearchObjects;
using CareConnect.Models.Responses;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareConnect.Services
{
    public interface IRoleService : ICRUDService<Role, RoleSearchObject, RoleAdditionalData, RoleInsertRequest, RoleUpdateRequest>
    {
        public Role AssignPermission(int id, List<string> permissions); 
    }
}
