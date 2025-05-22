using CareConnect.Models.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareConnect.Services
{
    public interface IUserService
    { 
        public Models.Responses.User Login (string username, string password);

        public List<string> GetPermissions(string username); 
    }
}
