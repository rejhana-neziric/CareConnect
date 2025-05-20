using CareConnect.API.Configuration;
using CareConnect.Models.Requests;
using CareConnect.Services;
using CareConnect.Services.Database;
using Mapster;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Swashbuckle.AspNetCore.SwaggerGen;
using System.Text.Json.Serialization;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

MapsterConfig.RegisterMappings();

builder.Services.AddTransient<IEmployeeService, EmployeeService>();
builder.Services.AddTransient<IEmployeeAvailabilityService, EmployeeAvailabilityService>();
builder.Services.AddTransient<IEmployeePayHistoryService, EmployeePayHistoryService>();
builder.Services.AddTransient<IAppointmentService, AppointmentService>();
builder.Services.AddTransient<IClientService, ClientService>();
builder.Services.AddTransient<IChildService, ChildService>();
builder.Services.AddTransient<IClientsChildService, ClientsChildService>();
builder.Services.AddTransient<IChildrenDiagnosisService, ChildrenDiagnosisService>();
builder.Services.AddTransient<IInstructorService, InstructorService>();
builder.Services.AddTransient<IMemberService, MemberService>();
builder.Services.AddTransient<IParticipantService, ParticipantService>();
builder.Services.AddTransient<IPaymentService, PaymentService>();
builder.Services.AddTransient<IReviewService, ReviewService>(); 
builder.Services.AddTransient<ISessionService, SessionService>(); 
builder.Services.AddTransient<IServiceService, ServiceService>(); 
builder.Services.AddTransient<IWorkshopService, WorkshopService>();


builder.Services.AddControllers()
.AddJsonOptions(options =>
    {
        options.JsonSerializerOptions.Converters.Add(new JsonStringEnumConverter());
    });
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(options =>
{
    options.UseInlineDefinitionsForEnums();
});

var connectionString = builder.Configuration.GetConnectionString("_210024Connection");

builder.Services.AddDbContext<CareConnectContext>(options =>
    options.UseSqlServer(connectionString));

builder.Services.AddMapster();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();

