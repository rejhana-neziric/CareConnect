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

            /*
            TypeAdapterConfig<Client, Models.Responses.Client>.NewConfig()
                 .Map(dest => dest.Children, src => src.ClientsChildren.Select(cc => cc.Child));
            */

            TypeAdapterConfig<Child, Models.Responses.Child>.NewConfig()
                .Map(dest => dest.Diagnoses, src => src.ChildrenDiagnoses.Select(cd => cd.Diagnosis));

            TypeAdapterConfig<ChildUpdateRequest, Child>
                .NewConfig()
                .PreserveReference(true)
                .IgnoreNullValues(true)
                .Ignore(dest => dest.ModifiedDate)
                .Ignore(dest => dest.BirthDate);

            TypeAdapterConfig<InstructorUpdateRequest, Instructor>
                .NewConfig()
                .PreserveReference(true)
                .IgnoreNullValues(true); 

            TypeAdapterConfig<MemberInsertRequest, Member>.NewConfig()
                .Map(dest => dest.MemberId, src => src.ClientId);

            TypeAdapterConfig<WorkshopUpdateRequest, Workshop>
                .NewConfig()
                .PreserveReference(true)
                .IgnoreNullValues(true)
                .Ignore(dest => dest.ModifiedDate)
                .Ignore(dest => dest.StartDate); 

            TypeAdapterConfig<SessionUpdateRequest, Session>
                .NewConfig()
                .PreserveReference(true)
                .IgnoreNullValues(true); 
            
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

            TypeAdapterConfig<ChildrenDiagnosisUpdateRequest, ChildrenDiagnosis>
                .NewConfig()
                .PreserveReference(true)
                .IgnoreNullValues(true); 

            TypeAdapterConfig<EmployeeAvailabilityUpdateRequest, EmployeeAvailability>
                .NewConfig()
                .PreserveReference(true)
                .IgnoreNullValues(true);

            //TypeAdapterConfig<ClientsChild, Models.Responses.ClientsChild>.NewConfig()
            //    .Map(dest => dest.LastAppointment, src => src.Appointments.OrderByDescending(a => a.Date).FirstOrDefault().Date);


            TypeAdapterConfig<ServiceType, Models.Responses.ServiceType>
                .NewConfig()
                .Map(dest => dest.NumberOfServices,
                     src => src.Services != null ? src.Services.Count : 0);


            TypeAdapterConfig<User, Models.Responses.User>
                .NewConfig()
                .Map(dest => dest.Roles, src => src.UsersRoles.Select(ur => ur.Role.Name).ToList());}
    }
}
