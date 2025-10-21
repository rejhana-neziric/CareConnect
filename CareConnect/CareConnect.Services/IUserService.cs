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
    }
}
