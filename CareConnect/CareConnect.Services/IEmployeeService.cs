using Microsoft.EntityFrameworkCore.Infrastructure;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CareConnect.Models.Requests;
using CareConnect.Models.SearchObjects;
using CareConnect.Models.Responses;

namespace CareConnect.Services
{
    public interface IEmployeeService : ICRUDService<Employee, EmployeeSearchObject, EmployeeAdditionalData, EmployeeInsertRequest, EmployeeUpdateRequest>
    {
      
    }
}
