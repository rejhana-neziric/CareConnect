using CareConnect.Services;
using CareConnect.Services.Database;
using Mapster;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using CareConnect.Models;
using DbEmployee = CareConnect.Services.Database.Employee;
using ModelEmployee = CareConnect.Models.Employee;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddTransient<IEmployeeService, EmployeeService>(); 

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var connectionString = builder.Configuration.GetConnectionString("_210024Connection");

builder.Services.AddDbContext<_210024Context>(options =>
    options.UseSqlServer(connectionString));

builder.Services.AddMapster();

// Configure Mapster mappings
TypeAdapterConfig<DbEmployee, ModelEmployee>.NewConfig()
    .Map(dest => dest.FirstName, src => src.EmployeeNavigation.FirstName)
    .Map(dest => dest.LastName, src => src.EmployeeNavigation.LastName);

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
