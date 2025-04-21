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
    //public class ClientService : BaseCRUDService<Models.Responses.Client, ClientSearchObject, Database.Client, ClientInsertRequest, ClientUpdateRequest>, IClientService
    //{
    //    public ClientService(_210024Context context, IMapper mapper) : base(context, mapper) { }

    //    public override IQueryable<Database.Client> AddFilter(ClientSearchObject search, IQueryable<Database.Client> query)
    //    {

    //        query = base.AddFilter(search, query);

    //        query = query.Include(x => x.User); 

    //        return query;
    //    }
    //}
}
