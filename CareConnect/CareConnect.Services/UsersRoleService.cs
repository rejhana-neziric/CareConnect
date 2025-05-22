using CareConnect.Models.Requests;
using CareConnect.Models.SearchObjects;
using CareConnect.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareConnect.Services
{
    public class UsersRoleService : BaseCRUDService<Models.Responses.UsersRole, UsersRoleSearchObject, UsersRoleAdditionalData, UsersRole, UsersRoleInsertRequest, UsersRoleUpdateRequest>, IUsersRoleService
    {
        public UsersRoleService(CareConnectContext context, IMapper mapper) : base(context, mapper) { }

        protected override void AddInclude(UsersRoleAdditionalData additionalData, ref IQueryable<UsersRole> query)
        {
            if (additionalData != null)
            {

                if (additionalData.IsRoleIncluded.HasValue && additionalData.IsRoleIncluded == true)
                {
                    additionalData.IncludeList.Add("Role");
                }
            }

            base.AddInclude(additionalData, ref query);
        }
    }
}
