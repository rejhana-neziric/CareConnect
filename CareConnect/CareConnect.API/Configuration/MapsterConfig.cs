using CareConnect.Models.Requests;
using CareConnect.Services.Database;
using Mapster;
using Microsoft.OpenApi.Models;

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

            TypeAdapterConfig<ChildUpdateRequest, Child>
                .NewConfig()
                .PreserveReference(true)
                .IgnoreNullValues(true)
                .Ignore(dest => dest.ModifiedDate); 

            TypeAdapterConfig<WorkshopUpdateRequest, Workshop>
                .NewConfig()
                .PreserveReference(true)
                .IgnoreNullValues(true)
                .Ignore(dest => dest.ModifiedDate)
                .Ignore(dest => dest.Date); 
            
            TypeAdapterConfig<ServiceUpdateRequest, Service>
                .NewConfig()
                .PreserveReference(true)
                .IgnoreNullValues(true); 

            TypeAdapterConfig<ReviewUpdateRequest, Review>
                .NewConfig()
                .PreserveReference(true)
                .IgnoreNullValues(true); 

                
            TypeAdapterConfig<PaymentUpdateRequest, Payment>
                .NewConfig()
                .PreserveReference(true)
                .IgnoreNullValues(true); 

            TypeAdapterConfig<ParticipantUpdateRequest, Participant>
                .NewConfig()
                .PreserveReference(true)
                .IgnoreNullValues(true); 

            TypeAdapterConfig<AppointmentUpdateRequest, Appointment>
                .NewConfig()
                .PreserveReference(true)
                .IgnoreNullValues(true); 

            TypeAdapterConfig<EmployeeAvailabilityUpdateRequest, EmployeeAvailability>
                .NewConfig()
                .PreserveReference(true)
                .IgnoreNullValues(true);

            TypeAdapterConfig<ServiceType, Models.Responses.ServiceType>
                .NewConfig()
                .Map(dest => dest.NumberOfServices,
                     src => src.Services != null ? src.Services.Count : 0);

            TypeAdapterConfig<User, Models.Responses.User>
                .NewConfig()
                .Map(dest => dest.Roles, src => src.UsersRoles.Select(ur => ur.Role.Name).ToList());
        }
    }
}
