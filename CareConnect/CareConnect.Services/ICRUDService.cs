using CareConnect.Models.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareConnect.Services
{
    public interface ICRUDService<TModel, TSearch, TInsert, TUpdate> : IService<TModel, TSearch> 
        where TModel : class where TSearch : BaseSearchObject where TInsert : class where TUpdate : class
    {
        public TModel Insert(TInsert request);

        TModel Update(int id, TUpdate request);
    }
}
