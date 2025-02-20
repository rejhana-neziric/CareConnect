using Microsoft.EntityFrameworkCore.Infrastructure;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CareConnect.Models;
using CareConnect.Models.Requests;
using CareConnect.Models.SearchObjects;

namespace CareConnect.Services
{
    public interface IEmployeeService : ICRUDService<Models.Employee, EmployeeSearchObject, EmployeeInsertRequest, EmployeeUpdateRequest>
    {
      
    }
}
