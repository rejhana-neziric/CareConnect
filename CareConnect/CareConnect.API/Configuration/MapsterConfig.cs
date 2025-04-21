using CareConnect.Models.Requests;
using CareConnect.Services.Database;
using Mapster;

namespace CareConnect.API.Configuration
{
    public static class MapsterConfig
    {
        public static void RegisterMappings()
        {
            TypeAdapterConfig<EmployeeUpdateRequest, Employee>
                .NewConfig()
                .PreserveReference(true)
                .IgnoreNullValues(true)
                .Ignore(dest => dest.ModifiedDate)
                .Ignore(dest => dest.HireDate);

            TypeAdapterConfig<UserUpdateRequest, User>
                .NewConfig()
                .PreserveReference(true)
                .IgnoreNullValues(true)
                .Ignore(dest => dest.ModifiedDate);

            TypeAdapterConfig<QualificationUpdateRequest, Qualification>
                .NewConfig()
                .PreserveReference(true)
                .IgnoreNullValues(true)
                .Ignore(dest => dest.ModifiedDate);
        }
    }
}
