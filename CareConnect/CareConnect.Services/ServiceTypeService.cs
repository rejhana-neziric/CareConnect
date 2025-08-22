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
    public class ServiceTypeService : BaseCRUDService<Models.Responses.ServiceType, ServiceTypeSearchObject, BaseAdditionalSearchRequestData, ServiceType, ServiceTypeInsertRequest, ServiceTypeUpdateRequest>, IServiceTypeService
    {
        public ServiceTypeService(CareConnectContext context, IMapper mapper) : base(context, mapper) { }

        public override IQueryable<ServiceType> AddFilter(ServiceTypeSearchObject search, IQueryable<ServiceType> query)
        {
            query = base.AddFilter(search, query);

            query = query.Include(x => x.Services); 

            if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                query = query.Where(x => x.Name.StartsWith(search.FTS));
            }

            return query;
        }
    }
}
