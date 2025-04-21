using CareConnect.Models.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareConnect.Services
{
    public interface ICRUDService<TModel, TSearch, TSearchAdditionalData,  TInsert, TUpdate> : IService<TModel, TSearch, TSearchAdditionalData> 
        where TModel : class 
        where TSearch : BaseSearchObject <TSearchAdditionalData>
        where TInsert : class 
        where TUpdate : class
        where TSearchAdditionalData : BaseAdditionalSearchRequestData
    {
        public TModel Insert(TInsert request);

        TModel Update(int id, TUpdate request);

        public bool Delete(int id); 
    }
}
