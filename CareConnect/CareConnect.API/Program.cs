using CareConnect.API.Configuration;
using CareConnect.Models.Requests;
using CareConnect.Services;
using CareConnect.Services.Database;
using Mapster;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

MapsterConfig.RegisterMappings();

builder.Services.AddTransient<IEmployeeService, EmployeeService>();
//builder.Services.AddTransient<IAppointmentService, AppointmentService>();
//builder.Services.AddTransient<IClientService, ClientService>();

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var connectionString = builder.Configuration.GetConnectionString("_210024Connection");

builder.Services.AddDbContext<_210024Context>(options =>
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

