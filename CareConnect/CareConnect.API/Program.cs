using CareConnect.API;
using CareConnect.API.Configuration;
using CareConnect.API.Filters;
using CareConnect.Models;
using CareConnect.Models.Responses;
using CareConnect.Services;
using CareConnect.Services.AppointmentStateMachine;
using CareConnect.Services.Database;
using CareConnect.Api.Hubs;
using CareConnect.Services.WorkshopStateMachine;
using CareConnect.Subscriber;
using DotNetEnv;
using EasyNetQ;
using Mapster;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Hosting;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;
using Serilog;
using Stripe;
using System.Reflection;
using System.Text.Json.Serialization;
using Microsoft.AspNetCore.SignalR;

var envFilePath = Path.Combine(Directory.GetParent(Directory.GetCurrentDirectory())!.FullName, ".env");
Env.Load(envFilePath);

var builder = WebApplication.CreateBuilder(args);

builder.Configuration
       .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true)
       .AddEnvironmentVariables();

// Stripe key
var stripeSettings = builder.Configuration.GetSection("Stripe");
StripeConfiguration.ApiKey = stripeSettings["SecretKey"];

MapsterConfig.RegisterMappings();

// Add services to the container.

builder.Services.AddTransient<IUserService, UserService>(); 
builder.Services.AddTransient<IEmployeeService, EmployeeService>();
builder.Services.AddTransient<IEmployeeAvailabilityService, EmployeeAvailabilityService>();
builder.Services.AddTransient<IEmployeePayHistoryService, EmployeePayHistoryService>();
builder.Services.AddTransient<IAppointmentService, AppointmentService>();
builder.Services.AddTransient<IAttendanceStatusService, AttendanceStatusService>();
builder.Services.AddTransient<IClientService, ClientService>();
builder.Services.AddTransient<IChildService, ChildService>();
builder.Services.AddTransient<IClientsChildService, ClientsChildService>();
builder.Services.AddTransient<IChildrenDiagnosisService, ChildrenDiagnosisService>();
builder.Services.AddTransient<IInstructorService, InstructorService>();
builder.Services.AddTransient<IMemberService, MemberService>();
builder.Services.AddTransient<IParticipantService, ParticipantService>();
builder.Services.AddTransient<IPaymentService, PaymentService>();
builder.Services.AddTransient<IReviewService, CareConnect.Services.ReviewService>();
builder.Services.AddTransient<IRoleService, RoleService>();
builder.Services.AddTransient<IUsersRoleService, UsersRoleService>();
builder.Services.AddTransient<ISessionService, SessionService>();
builder.Services.AddTransient<IServiceService, ServiceService>();
builder.Services.AddTransient<IServiceTypeService, ServiceTypeService>();
builder.Services.AddTransient<IWorkshopService, WorkshopService>();
builder.Services.AddTransient<IReportService, ReportService>();

builder.Services.AddTransient<BaseAppointmentState>();
builder.Services.AddTransient<InitialAppointmentState>();
builder.Services.AddTransient<ScheduledAppointmentState>();
builder.Services.AddTransient<ConfirmedAppointmentState>();
builder.Services.AddTransient<RescheduledAppointmentState>();
builder.Services.AddTransient<RescheduleRequestedAppointmentState>();
builder.Services.AddTransient<ReschedulePendingApprovalAppointmentState>();
builder.Services.AddTransient<StartedAppointmentService>();
builder.Services.AddTransient<CompletedAppointmentState>();
builder.Services.AddTransient<CanceledAppointmentState>();

builder.Services.AddTransient<BaseWorkshopState>(); 
builder.Services.AddTransient<InitialWorkshopState>();
builder.Services.AddTransient<DraftWorkshopState>();    
builder.Services.AddTransient<PublishedWorkshopState>();
builder.Services.AddTransient<CanceledWorkshopState>(); 
builder.Services.AddTransient<ClosedWorkshopState>();

builder.Services.AddSingleton<IRabbitMqService, RabbitMqService>();

builder.Services.AddSignalR();

builder.WebHost.UseUrls("http://0.0.0.0:5241");

builder.Services.AddSingleton<IUserIdProvider, CustomUserIdProvider>();

// RabbitMQ connection
builder.Services.AddSingleton<IBus>(provider =>
{
    var connectionString = builder.Configuration.GetConnectionString("RabbitMQ");
    return RabbitHutch.CreateBus(connectionString);
});

builder.Services.AddHostedService<CareConnect.Services.BackgroundTasks.AppointmentStatusUpdater>();

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

    options.AddSecurityDefinition("BasicAuthentication", new OpenApiSecurityScheme
    {
        Name = "Authorization",
        Type = SecuritySchemeType.Http,
        Scheme = "basic",
        In = ParameterLocation.Header,
        Description = "Basic Authorization header using the Bearer scheme."
    });
    options.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme 
            { 
                Reference = new OpenApiReference 
                { 
                    Type = ReferenceType.SecurityScheme, 
                    Id = "BasicAuthentication" 
                } 
            },
            new string[] { }
        }
    });

});

var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");

builder.Services.AddDbContext<CareConnectContext>(options =>
    options.UseSqlServer(connectionString));

builder.Services.AddMapster();

builder.Services.AddSerilog(options =>
{
    options.ReadFrom.Configuration(builder.Configuration); 
});

builder.Services.AddAuthentication("BasicAuthentication")
    .AddScheme<AuthenticationSchemeOptions, BasicAuthenticationHandler>("BasicAuthentication", null);

builder.Services.AddAuthorization(options =>
{
    var permissionConstants = typeof(Permissions)
        .GetNestedTypes(BindingFlags.Public | BindingFlags.Static)
        .SelectMany(nestedType => nestedType
            .GetFields(BindingFlags.Public | BindingFlags.Static | BindingFlags.FlattenHierarchy))
        .Where(f => f.IsLiteral && !f.IsInitOnly && f.FieldType == typeof(string))
        .Select(f => f.GetRawConstantValue()?.ToString())
        .Where(value => !string.IsNullOrWhiteSpace(value))
        .ToList();

    foreach (var permission in permissionConstants)
    {
        options.AddPolicy(permission, builder =>
        {
            builder.AddRequirements(new PermissionRequirement(permission));
        });
    }
});

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowFlutter", policy =>
    {
        policy.WithOrigins("http://localhost:*", "https://localhost:*", "http://10.0.2.2:*" )
              .AllowAnyHeader()
              .AllowAnyMethod()
              .AllowCredentials();
    });
});

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

//app.UseRouting();

app.UseAuthentication();    

app.UseAuthorization();

app.UseSerilogRequestLogging();

app.MapControllers();

app.UseCors();

app.MapHub<NotificationHub>("/notificationHub");

using (var scope = app.Services.CreateScope())
{
    var dataContext = scope.ServiceProvider.GetRequiredService<CareConnectContext>();
   
    dataContext.Database.Migrate(); 
}

app.Run();

