using CareConnect.API.Configuration;
using CareConnect.API.Filters;
using CareConnect.Services;
using CareConnect.Services.AppointmentStateMachine;
using CareConnect.Services.Database;
using Mapster;
using Microsoft.AspNetCore.Hosting;
using Microsoft.EntityFrameworkCore;
using Serilog;
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

builder.Services.AddTransient<BaseAppointmentState>();
builder.Services.AddTransient<InitialAppointmentState>();
builder.Services.AddTransient<ScheduledAppointmentState>();
builder.Services.AddTransient<ConfirmedAppointmentState>();
builder.Services.AddTransient<RescheduledAppointmedState>();
builder.Services.AddTransient<StartedAppointmentService>();
builder.Services.AddTransient<CompletedAppointmentState>();
builder.Services.AddTransient<CanceledAppointmentState>();

builder.Services.AddControllers(x =>
{
    x.Filters.Add<ExceptionFilter>();
})
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

builder.Services.AddSerilog(options =>
{
    options.ReadFrom.Configuration(builder.Configuration); 
});

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.UseSerilogRequestLogging();

app.MapControllers();

app.Run();

