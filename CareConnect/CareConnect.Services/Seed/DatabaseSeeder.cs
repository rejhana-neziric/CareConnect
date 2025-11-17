using System;
using System.Reflection;
using System.Threading.Tasks;
using CareConnect.Services.Database;
using CareConnect.Services.Helpers;
using Microsoft.EntityFrameworkCore;


namespace CareConnect.Services.Seeders;

public static class DatabaseSeeder
{
    public static void Seed(CareConnectContext context)
    {
        // Checking if database is already seeded
        if (context.Users.Any())
        {
            Console.WriteLine("Database already seeded. Skipping seed operation.");
            return;
        }

        Console.WriteLine("Starting database seeding...");

        try
        {
            SeedAttendanceStatuses(context);
            SeedQualifications(context);
            SeedUsers(context);
            SeedRoles(context);
            SeedUsersRoles(context);
            SeedEmployees(context);
            SeedClients(context);
            SeedChildren(context);
            SeedClientsChildren(context);
            SeedServiceTypes(context);
            SeedServices(context);
            SeedWorkshops(context);
            SeedReviews(context);
            SeedParticipants(context);
            SeedEmployeeAvailabilities(context);
            SeedAppointments(context);
            SeedPermissions(context);
            SeedRolePermissions(context); 

            Console.WriteLine("Database seeding completed successfully!");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error during database seeding: {ex.Message}");
            throw;
        }
    }

    private static void SeedAttendanceStatuses(CareConnectContext context)
    {
        if (context.AttendanceStatuses.Any()) return;

        var statuses = new[]
        {
            new AttendanceStatus { Name = "Present" },
            new AttendanceStatus { Name = "Absent" },
            new AttendanceStatus { Name = "Late" },
            new AttendanceStatus { Name = "Excused" }
        };

        context.AttendanceStatuses.AddRange(statuses);
        context.SaveChanges();
        Console.WriteLine("✓ Seeded AttendanceStatuses");
    }

    private static void SeedQualifications(CareConnectContext context)
    {
        if (context.Qualifications.Any()) return;

        var qualifications = new[]
        {
            new Qualification
            {
                Name = "Bachelor of Psychology",
                InstituteName = "University of Sarajevo",
                ProcurementYear = new DateTime(2010, 6, 1)
            },
            new Qualification
            {
                Name = "Master of Speech-Language Pathology",
                InstituteName = "University of Sarajevo",
                ProcurementYear = new DateTime(2012, 6, 1)
            },
            new Qualification
            {
                Name = "Bachelor of Speech-Language Pathology",
                InstituteName = "University of Sarajevo",
                ProcurementYear = new DateTime(2018, 6, 1)
            },
            new Qualification
            {
                Name = "Bachelor of Speech and Language Therapy",
                InstituteName = "University of Mostar",
                ProcurementYear = new DateTime(2017, 6, 1)
            },
            new Qualification
            {
                Name = "Bachelor of Special Education",
                InstituteName = "University of Sarajevo",
                ProcurementYear = new DateTime(2015, 6, 1)
            },
            new Qualification
            {
                Name = "Bachelor of Pedagogy",
                InstituteName = "University of Sarajevo",
                ProcurementYear = new DateTime(2013, 6, 1)
            },
            new Qualification
            {
                Name = "Master of Pedagogy",
                InstituteName = "University of Sarajevo",
                ProcurementYear = new DateTime(2016, 6, 1)
            },
            new Qualification
            {
                Name = "Master of Psychology",
                InstituteName = "University of Sarajevo",
                ProcurementYear = new DateTime(2015, 10, 1)
            },
        };

        context.Qualifications.AddRange(qualifications);
        context.SaveChanges();
        Console.WriteLine("✓ Seeded Qualifications");
    }

    private static void SeedUsers(CareConnectContext context)
    {
        if (context.Users.Any()) return;

        var password = "test";

        var passwordSalt = SecurityHelper.GenerateSalt();
        var passwordHash = SecurityHelper.GenerateHash(passwordSalt, password);

        var users = new[]
             {
            new User { FirstName = "Aaliyah", LastName = "Smith", Email = "aaliyah.smith@email.com", PhoneNumber = "61123456", Username = "aaliyah", PasswordHash = passwordHash, PasswordSalt = passwordSalt, Status = true, BirthDate = new DateTime(1990, 5, 15), Gender = "F", Address = "123 Main St" },
            new User { FirstName = "Maryam", LastName = "Garcia", Email = "maryam.garcia@email.com", PhoneNumber = "61123456", Username = "maryam", PasswordHash = passwordHash, PasswordSalt = passwordSalt, Status = true, BirthDate = new DateTime(1988, 3, 22), Gender = "F", Address = "456 Elm St" },
            new User { FirstName = "Amina", LastName = "Johnson", Email = "amina.johnson@email.com", PhoneNumber = "61123456", Username = "amina", PasswordHash = passwordHash, PasswordSalt = passwordSalt, Status = true, BirthDate = new DateTime(1992, 7, 30), Gender = "F", Address = "789 Oak St" },
            new User { FirstName = "Safiya", LastName = "Brown", Email = "safiya.brown@email.com", PhoneNumber = "61123456", Username = "safiya", PasswordHash = passwordHash, PasswordSalt = passwordSalt, Status = true, BirthDate = new DateTime(1985, 11, 10), Gender = "F", Address = "321 Pine St" },
            new User { FirstName = "Hannah", LastName = "Williams", Email = "hannah.williams@email.com", PhoneNumber = "61123456", Username = "hannah", PasswordHash = passwordHash, PasswordSalt = passwordSalt, Status = true, BirthDate = new DateTime(1991, 8, 25), Gender = "F", Address = "654 Cedar St" },
            new User { FirstName = "Ismaa", LastName = "Miller", Email = "ismaa.miller@email.com", PhoneNumber = "61123456", Username = "ismaa", PasswordHash = passwordHash, PasswordSalt = passwordSalt, Status = true, BirthDate = new DateTime(1989, 2, 14), Gender = "F", Address = "987 Birch St" },
            new User { FirstName = "Rahma", LastName = "Davis", Email = "rahma.davis@email.com", PhoneNumber = "61123456", Username = "rahma", PasswordHash = passwordHash, PasswordSalt = passwordSalt, Status = true, BirthDate = new DateTime(1994, 12, 5), Gender = "F", Address = "246 Walnut St" },
            new User { FirstName = "Mikaeel", LastName = "Anderson", Email = "mikaeel.anderson@email.com", PhoneNumber = "61123458", Username = "mikaeel", PasswordHash = passwordHash, PasswordSalt = passwordSalt, Status = true, BirthDate = new DateTime(1980, 4, 12), Gender = "M", Address = "111 Main St" },
            new User { FirstName = "Daniyal", LastName = "Martinez", Email = "daniyal.martinez@email.com", PhoneNumber = "61123459", Username = "daniyal", PasswordHash = passwordHash, PasswordSalt = passwordSalt, Status = true, BirthDate = new DateTime(1982, 9, 9), Gender = "M", Address = "222 Elm St" },
            new User { FirstName = "Yusuf", LastName = "Hernandez", Email = "yusuf.hernandez@email.com", PhoneNumber = "61123460", Username = "yusuf", PasswordHash = passwordHash, PasswordSalt = passwordSalt, Status = true, BirthDate = new DateTime(1995, 10, 23), Gender = "M", Address = "333 Oak St" },
            new User { FirstName = "Rashid", LastName = "Lopez", Email = "rashid.lopez@email.com", PhoneNumber = "61123461", Username = "rashid", PasswordHash = passwordHash, PasswordSalt = passwordSalt, Status = true, BirthDate = new DateTime(1991, 7, 17), Gender = "M", Address = "444 Pine St" },
            new User { FirstName = "Waleed", LastName = "Clark", Email = "waleed.clark@email.com", PhoneNumber = "61123462", Username = "waleed", PasswordHash = passwordHash, PasswordSalt = passwordSalt, Status = true, BirthDate = new DateTime(1987, 5, 29), Gender = "M", Address = "555 Cedar St" },
            new User { FirstName = "David", LastName = "Lewis", Email = "david.lewis@email.com", PhoneNumber = "61123463", Username = "david", PasswordHash = passwordHash, PasswordSalt = passwordSalt, Status = true, BirthDate = new DateTime(1999, 8, 20), Gender = "M", Address = "666 Birch St" },
            new User { FirstName = "Sofia", LastName = "Walker", Email = "sofia.walker@email.com", PhoneNumber = "61123464", Username = "sofia", PasswordHash = passwordHash, PasswordSalt = passwordSalt, Status = true, BirthDate = new DateTime(1983, 1, 8), Gender = "F", Address = "777 Walnut St" },
            new User { FirstName = "Karima", LastName = "Young", Email = "karima.young@email.com", PhoneNumber = "61123465", Username = "karima", PasswordHash = passwordHash, PasswordSalt = passwordSalt, Status = true, BirthDate = new DateTime(1996, 3, 14), Gender = "F", Address = "888 Maple St" },
            new User { FirstName = "Mariam", LastName = "Hall", Email = "mariam.hall@email.com", PhoneNumber = "61123466", Username = "mariam", PasswordHash = passwordHash, PasswordSalt = passwordSalt, Status = true, BirthDate = new DateTime(1992, 6, 11), Gender = "F", Address = "999 Oak St" },
            // Test users for application
            new User { FirstName = "Amina", LastName = "Khan", Email = "admin@email.com", PhoneNumber = "61123467", Username = "admin", PasswordHash = passwordHash, PasswordSalt = passwordSalt, Status = true, BirthDate = new DateTime(1992, 6, 11), Gender = "F", Address = "100 Admin St" },
            new User { FirstName = "Aisha", LastName = "Ali", Email = "employee@email.com", PhoneNumber = "61123468", Username = "employee", PasswordHash = passwordHash, PasswordSalt = passwordSalt, Status = true, BirthDate = new DateTime(1992, 6, 11), Gender = "F", Address = "200 Employee Ave" },
            new User { FirstName = "Layla", LastName = "Hassan", Email = "client@email.com", PhoneNumber = "61123469", Username = "client", PasswordHash = passwordHash, PasswordSalt = passwordSalt, Status = true, BirthDate = new DateTime(1992, 6, 11), Gender = "F", Address = "300 Client Blvd" }
        };

        context.Users.AddRange(users);
        context.SaveChanges();
        Console.WriteLine("✓ Seeded Users");
    }

    private static void SeedRoles(CareConnectContext context)
    {
        if (context.Roles.Any()) return;

        var roles = new[]
        {
            new Role { Name = "Admin", Description = "System Administrator" },
            new Role { Name = "Employee", Description = "Employee/Staff Member" },
            new Role { Name = "Client", Description = "Client/Parent" }
        };

        context.Roles.AddRange(roles);
        context.SaveChanges();
        Console.WriteLine("✓ Seeded Roles");
    }

    private static void SeedUsersRoles(CareConnectContext context)
    {
        if (context.UsersRoles.Any()) return;

        var adminUser = context.Users.First(u => u.Username == "admin");
        var employeeUser = context.Users.First(u => u.Username == "employee");
        var clientUser = context.Users.First(u => u.Username == "client");

        var adminRole = context.Roles.First(r => r.Name == "Admin");
        var employeeRole = context.Roles.First(r => r.Name == "Employee");
        var clientRole = context.Roles.First(r => r.Name == "Client");

        var usersRoles = new[]
        {
            new UsersRole { UserId = adminUser.UserId, RoleId = adminRole.RoleId },
            new UsersRole { UserId = employeeUser.UserId, RoleId = employeeRole.RoleId },
            new UsersRole { UserId = clientUser.UserId, RoleId = clientRole.RoleId }
        };

        context.UsersRoles.AddRange(usersRoles);
        context.SaveChanges();
        Console.WriteLine("✓ Seeded UsersRoles");
    }

    private static void SeedEmployees(CareConnectContext context)
    {
        if (context.Employees.Any()) return;

        var aaliyahId = context.Users.First(u => u.Username == "aaliyah").UserId;
        var maryamId = context.Users.First(u => u.Username == "maryam").UserId;
        var aminaId = context.Users.First(u => u.Username == "amina").UserId;
        var safiyaId = context.Users.First(u => u.Username == "safiya").UserId;
        var hannahId = context.Users.First(u => u.Username == "hannah").UserId;
        var ismaaId = context.Users.First(u => u.Username == "ismaa").UserId;
        var rahmaId = context.Users.First(u => u.Username == "rahma").UserId;
        var employeeId = context.Users.First(u => u.Username == "employee").UserId;

        var psychologyQualId = context.Qualifications.First(q => q.Name == "Bachelor of Psychology").QualificationId;
        var speechTherapyQualId = context.Qualifications.First(q => q.Name == "Master of Speech-Language Pathology").QualificationId;
        var speechTherapyQualIdBachelor = context.Qualifications.First(q => q.Name == "Bachelor of Speech-Language Pathology").QualificationId;
        var speechTherapyQualIdBachelor2 = context.Qualifications.First(q => q.Name == "Bachelor of Speech and Language Therapy").QualificationId;
        var specialEdQualId = context.Qualifications.First(q => q.Name == "Bachelor of Special Education").QualificationId;
        var pedagogyBachelorQualId = context.Qualifications.First(q => q.Name == "Bachelor of Pedagogy").QualificationId;
        var pedagogyMasterQualId = context.Qualifications.First(q => q.Name == "Master of Pedagogy").QualificationId;
        var psychologyMasterId = context.Qualifications.First(q => q.Name == "Master of Psychology").QualificationId;

        var employees = new[]
        {
            new Employee { EmployeeId = aaliyahId, HireDate = new DateTime(2022, 1, 15), JobTitle = "Psychologist", QualificationId = psychologyQualId },
            new Employee { EmployeeId = maryamId, HireDate = new DateTime(2021, 7, 22), JobTitle = "Pedagogue", QualificationId = pedagogyMasterQualId },
            new Employee { EmployeeId = aminaId, HireDate = new DateTime(2020, 5, 30), JobTitle = "Pedagogue", QualificationId = pedagogyBachelorQualId },
            new Employee { EmployeeId = safiyaId, HireDate = new DateTime(2019, 11, 10), JobTitle = "Speech Therapist", QualificationId = speechTherapyQualId },
            new Employee { EmployeeId = hannahId, HireDate = new DateTime(2019, 11, 10), JobTitle = "Speech Therapist", QualificationId = speechTherapyQualIdBachelor},
            new Employee { EmployeeId = ismaaId, HireDate = new DateTime(2010, 9, 12), JobTitle = "Speech Therapist", QualificationId = speechTherapyQualIdBachelor2 },
            new Employee { EmployeeId = rahmaId, HireDate = new DateTime(2021, 3, 20), JobTitle = "Special Educator", QualificationId = specialEdQualId },
            new Employee { EmployeeId = employeeId, HireDate = new DateTime(2022, 3, 20), JobTitle = "Psychologist", QualificationId = psychologyMasterId }
        };

        context.Employees.AddRange(employees);
        context.SaveChanges();
        Console.WriteLine("✓ Seeded Employees");
    }

    private static void SeedClients(CareConnectContext context)
    {
        if (context.Clients.Any()) return;

        var mikaeelId = context.Users.First(u => u.Username == "mikaeel").UserId;
        var daniyalId = context.Users.First(u => u.Username == "daniyal").UserId;
        var yusufId = context.Users.First(u => u.Username == "yusuf").UserId;
        var rashidId = context.Users.First(u => u.Username == "rashid").UserId;
        var waleedId = context.Users.First(u => u.Username == "waleed").UserId;
        var davidId = context.Users.First(u => u.Username == "david").UserId;
        var sofiaId = context.Users.First(u => u.Username == "sofia").UserId;
        var karimaId = context.Users.First(u => u.Username == "karima").UserId;
        var mariamId = context.Users.First(u => u.Username == "mariam").UserId;
        var clientTestId = context.Users.First(u => u.Username == "client").UserId;

        var clients = new[]
        {
            new Client { ClientId = mikaeelId, EmploymentStatus = true, CreatedDate = new DateTime(2025, 6, 15) },
            new Client { ClientId = daniyalId, EmploymentStatus = false,  CreatedDate = new DateTime(2025, 10, 12)},
            new Client { ClientId = yusufId, EmploymentStatus = true,  CreatedDate = new DateTime(2025, 10, 10) },
            new Client { ClientId = rashidId, EmploymentStatus = false,  CreatedDate = new DateTime(2025, 9, 5) },
            new Client { ClientId = waleedId, EmploymentStatus = true,  CreatedDate = new DateTime(2025, 9, 25) },
            new Client { ClientId = davidId, EmploymentStatus = false,  CreatedDate = new DateTime(2025, 8, 20) },
            new Client { ClientId = sofiaId, EmploymentStatus = true,  CreatedDate = new DateTime(2025, 10, 17) },
            new Client { ClientId = karimaId, EmploymentStatus = false,  CreatedDate = new DateTime(2025, 9, 10) },
            new Client { ClientId = mariamId, EmploymentStatus = false,  CreatedDate = new DateTime(2025, 10, 11) },
            new Client { ClientId = clientTestId, EmploymentStatus = true,  CreatedDate = new DateTime(2025, 11, 1) }
        };

        context.Clients.AddRange(clients);
        context.SaveChanges();
        Console.WriteLine("✓ Seeded Clients");
    }

    private static void SeedChildren(CareConnectContext context)
    {
        if (context.Children.Any()) return;

        var children = new[]
      {
            new Child { FirstName = "Adam", LastName = "Smith", BirthDate = new DateTime(2015, 2, 10), Gender = "M" },
            new Child { FirstName = "Yusuf", LastName = "Garcia", BirthDate = new DateTime(2017, 6, 22), Gender = "M" },
            new Child { FirstName = "Aisha", LastName = "Johnson", BirthDate = new DateTime(2018, 4, 15), Gender = "F" },
            new Child { FirstName = "Omar", LastName = "Brown", BirthDate = new DateTime(2016, 9, 30), Gender = "M" },
            new Child { FirstName = "Ibrahim", LastName = "Williams", BirthDate = new DateTime(2019, 11, 5), Gender = "M" },
            new Child { FirstName = "Zayd", LastName = "Miller", BirthDate = new DateTime(2014, 12, 20), Gender = "M" },
            new Child { FirstName = "Ehsan", LastName = "Davis", BirthDate = new DateTime(2015, 7, 8), Gender = "M" },
            new Child { FirstName = "Hamza", LastName = "Wilson", BirthDate = new DateTime(2018, 3, 14), Gender = "M" },
            new Child { FirstName = "Ali", LastName = "Anderson", BirthDate = new DateTime(2017, 8, 26), Gender = "M" },
            new Child { FirstName = "Salim", LastName = "Martinez", BirthDate = new DateTime(2020, 2, 5), Gender = "M" },
            new Child { FirstName = "Fatimah", LastName = "Hernandez", BirthDate = new DateTime(2015, 9, 17), Gender = "F" },
            new Child { FirstName = "Layla", LastName = "Lopez", BirthDate = new DateTime(2017, 6, 2), Gender = "F" },
            new Child { FirstName = "Sofia", LastName = "Clark", BirthDate = new DateTime(2016, 10, 29), Gender = "F" },
            new Child { FirstName = "Mariam", LastName = "Lewis", BirthDate = new DateTime(2019, 4, 23), Gender = "F" },
            new Child { FirstName = "Zainab", LastName = "Walker", BirthDate = new DateTime(2021, 1, 15), Gender = "F" }
        };

        context.Children.AddRange(children);
        context.SaveChanges();
        Console.WriteLine("✓ Seeded Children");
    }

    private static void SeedClientsChildren(CareConnectContext context)
    {
        if (context.ClientsChildren.Any()) return;

        var mikaeelId = context.Users.First(u => u.Username == "mikaeel").UserId;
        var daniyalId = context.Users.First(u => u.Username == "daniyal").UserId;
        var yusufId = context.Users.First(u => u.Username == "yusuf").UserId;
        var rashidId = context.Users.First(u => u.Username == "rashid").UserId;
        var waleedId = context.Users.First(u => u.Username == "waleed").UserId;
        var davidId = context.Users.First(u => u.Username == "david").UserId;
        var sofiaId = context.Users.First(u => u.Username == "sofia").UserId;
        var karimaId = context.Users.First(u => u.Username == "karima").UserId;
        var mariamId = context.Users.First(u => u.Username == "mariam").UserId;
        var clientTestId = context.Users.First(u => u.Username == "client").UserId;

        var children = context.Children.OrderBy(c => c.ChildId).ToList();

        var clientsChildren = new[]
       {
            new ClientsChild { ClientId = mikaeelId, ChildId = children[0].ChildId },
            new ClientsChild { ClientId = daniyalId, ChildId = children[1].ChildId },
            new ClientsChild { ClientId = yusufId, ChildId = children[2].ChildId },
            new ClientsChild { ClientId = rashidId, ChildId = children[3].ChildId },
            new ClientsChild { ClientId = waleedId, ChildId = children[4].ChildId },
            new ClientsChild { ClientId = davidId, ChildId = children[5].ChildId },
            new ClientsChild { ClientId = sofiaId, ChildId = children[6].ChildId },
            new ClientsChild { ClientId = karimaId, ChildId = children[7].ChildId },
            new ClientsChild { ClientId = mariamId, ChildId = children[8].ChildId },
            new ClientsChild { ClientId = clientTestId, ChildId = children[9].ChildId },
            new ClientsChild { ClientId = clientTestId, ChildId = children[10].ChildId },
            new ClientsChild { ClientId = karimaId, ChildId = children[11].ChildId },
            new ClientsChild { ClientId = mariamId, ChildId = children[12].ChildId },
            new ClientsChild { ClientId = rashidId, ChildId = children[13].ChildId },
            new ClientsChild { ClientId = yusufId, ChildId = children[14].ChildId },
        };

        context.ClientsChildren.AddRange(clientsChildren);
        context.SaveChanges();
        Console.WriteLine("✓ Seeded ClientsChildren");
    }

    private static void SeedServiceTypes(CareConnectContext context)
    {
        if (context.ServiceTypes.Any()) return;

        var serviceTypes = new[]
        {
            new ServiceType { Name = "Diagnostic Services", Description = "Identifying needs, challenges, and strengths through evaluations and screenings." },
            new ServiceType { Name = "Therapy Services", Description = "Providing targeted treatments and therapies to address specific issues." },
            new ServiceType { Name = "Educational Services", Description = "Assisting with learning, skills development, and academic progress." },
            new ServiceType { Name = "Counseling & Guidance", Description = "Offering emotional, psychological, and behavioral support.." },
            new ServiceType { Name = "Follow-up & Monitoring", Description = "Tracking progress and adjusting interventions as needed." },
        };

        context.ServiceTypes.AddRange(serviceTypes);
        context.SaveChanges();
        Console.WriteLine("✓ Seeded ServiceTypes");
    }

    private static void SeedServices(CareConnectContext context)
    {
        if (context.Services.Any()) return;

        var diagnosticTypeId = context.ServiceTypes.First(st => st.Name == "Diagnostic Services").ServiceTypeId;
        var therapyTypeId = context.ServiceTypes.First(st => st.Name == "Therapy Services").ServiceTypeId;
        var educationalTypeId = context.ServiceTypes.First(st => st.Name == "Educational Services").ServiceTypeId;
        var counselingTypeId = context.ServiceTypes.First(st => st.Name == "Counseling & Guidance").ServiceTypeId; 
        var followUpTypesId = context.ServiceTypes.First(st => st.Name == "Follow-up & Monitoring").ServiceTypeId;

        var services = new[]
        {
            new Service { Name = "Observation Protocol for Autism Diagnosis - ADOS-2", Description = "Standardized protocol for diagnosing autism spectrum disorders.", Price = 160.00m, ServiceTypeId = diagnosticTypeId },
            new Service { Name = "Speech Therapy Observation", Description = "Assessment of speech and language abilities.", Price = 70.00m, ServiceTypeId = therapyTypeId },
            new Service { Name = "Special Education Observation", Description = "Assessment of specific developmental and learning difficulties.", Price = 70.00m, ServiceTypeId = educationalTypeId },
            new Service { Name = "Psychological Observation and Assessment", Description = "Evaluation of cognitive and emotional abilities.", Price = 80.00m, ServiceTypeId = diagnosticTypeId },
            new Service { Name = "Educational Observation", Description = "Analysis of educational needs and potential.", Price = 65.00m, ServiceTypeId = educationalTypeId },
            new Service { Name = "Speech Therapy Treatment", Description = "Individual treatment to improve speech and language abilities.", Price = 40.00m, ServiceTypeId = therapyTypeId },
            new Service { Name = "Follow-up Speech Therapy Session", Description = "Monitoring progress after previous treatment.", Price = 40.00m, ServiceTypeId = followUpTypesId },
            new Service { Name = "Diagnostic Assessment and Report on Articulation Difficulties", Description = "Assessment of articulation difficulties and preparation of a report.", Price = 40.00m, ServiceTypeId = diagnosticTypeId },
            new Service { Name = "Speech Therapy Counseling", Description = "Parental counseling on speech and language development.", Price = 40.00m, ServiceTypeId = counselingTypeId },
            new Service { Name = "Speech Therapy Evaluation", Description = "Comprehensive assessment of speech and language abilities.", Price = 40.00m, ServiceTypeId = diagnosticTypeId },
        };

        context.Services.AddRange(services);
        context.SaveChanges();
        Console.WriteLine("✓ Seeded Services");
    }

    private static void SeedWorkshops(CareConnectContext context)
    {
        if (context.Workshops.Any()) return;

        var workshops = new[]
        {
            new Workshop
            {
                Name = "Supporting Children with Autism",
                Description = "A comprehensive workshop for parents on understanding and supporting children with autism.",
                Status = "Closed",
                Date = new DateTime(2024, 10, 10, 14, 0, 0),
                Price = 200.00m,
                MaxParticipants = 10,
                Participants = 5,
                WorkshopType = "Parents",
            },
            new Workshop
            {
                Name = "Social Skills Development for Children",
                Description = "Interactive activities designed to improve social skills in children with disabilities.",
                Status = "Closed",
                Participants = 10,
                Date = new DateTime(2024, 11, 5, 10, 0, 0),
                Price = 180.00m,
                WorkshopType = "Children",
            },
            new Workshop
            {
                Name = "Parenting Strategies for Children with Special Needs",
                Description = "Guidance for parents on effective strategies for children with special needs.",
                Status = "Closed",
                Date = new DateTime(2024, 12, 1, 18, 0, 0),
                MaxParticipants = 12,
                Participants = 7,
                Price = 220.00m,
                WorkshopType = "Parents",
            },
            new Workshop
            {
                Name = "Learning Through Play",
                Description = "Interactive session for children focusing on developing communication and problem-solving skills.",
                Status = "Closed",
                Date = new DateTime(2025, 9, 10, 13, 0, 0),
                Price = 80.00m,
                MaxParticipants = 8,
                Participants = 4,
                WorkshopType = "Children"
            },
            new Workshop
            {
                Name = "Managing Challenging Behaviors at Home",
                Description = "Helping parents understand the reasons behind challenging behaviors and how to respond positively.",
                Status = "Closed",
                Date = new DateTime(2025, 8, 2, 11, 0, 0),
                Price = 150.00m,
                MaxParticipants = 11,
                Participants = 7,
                WorkshopType = "Parents"
            },
            new Workshop
            {
                Name = "Art Therapy for Emotional Expression",
                Description = "Creative art activities to help children express emotions and build confidence.",
                Status = "Canceled",
                Date = new DateTime(2025, 7, 15, 12, 0, 0),
                Price = 90.00m,
                MaxParticipants = 13,
                Participants = 3,
                WorkshopType = "Children"
            },
            new Workshop
            {
                Name = "Building Daily Routines",
                Description = "Guidance for parents on creating structured and calming daily routines for their children.",
                Status = "Closed",
                Date = new DateTime(2025, 9, 25, 17, 0, 0),
                Price = 100.00m,
                MaxParticipants = 9,
                Participants = 5,
                WorkshopType = "Parents"
            },
            new Workshop
            {
                Name = "Sensory Play Adventures",
                Description = "Hands-on sensory activities designed to improve coordination and focus in children.",
                Status = "Closed",
                Date = new DateTime(2025, 8, 18, 12, 0, 0),
                Price = 70.00m,
                MaxParticipants = 10,
                Participants = 5,
                WorkshopType = "Children"
            },
            new Workshop
            {
                Name = "Parent-Child Communication Skills",
                Description = "A parent-focused session on improving listening, understanding, and responding effectively.",
                Status = "Closed",
                Date = new DateTime(2025, 10, 5, 14, 0, 0),
                Price = 120.00m,
                MaxParticipants = 13,
                Participants = 6,
                WorkshopType = "Parents"
            },
            new Workshop
            {
                Name = "Developing Fine Motor Skills",
                Description = "Activity-based workshop for children to enhance coordination and hand strength.",
                Status = "Closed",
                Date = new DateTime(2025, 10, 10, 13, 0, 0),
                Price = 60.00m,
                MaxParticipants = 6,
                Participants = 4,
                WorkshopType = "Children"
            },
            new Workshop
            {
                Name = "Supporting Emotional Regulation",
                Description = "Helping parents teach children to recognize and manage their emotions calmly.",
                Status = "Closed",
                Date = new DateTime(2025, 9, 20, 15, 0, 0),
                Price = 130.00m,
                MaxParticipants = 8,
                Participants = 7,
                WorkshopType = "Parents"
            },
            new Workshop
            {
                Name = "Creative Movement for Kids",
                Description = "Dance and movement exercises promoting confidence and social interaction.",
                Status = "Closed",
                Date = new DateTime(2025, 9, 10, 10, 0, 0),
                Price = 90.00m,
                MaxParticipants = 8,
                Participants = 7,
                WorkshopType = "Children"
            },
            new Workshop
            {
                Name = "Positive Parenting Strategies",
                Description = "Parent workshop on building strong, respectful, and supportive relationships.",
                Status = "Closed",
                Date = new DateTime(2025, 9, 5, 15, 0, 0),
                Price = 110.00m,
                MaxParticipants = 10,
                Participants = 7,
                WorkshopType = "Parents"
            },
            new Workshop
            {
                Name = "Storytelling for Imagination Development",
                Description = "Children's session using storytelling to encourage creativity and expression.",
                Status = "Closed",
                Date = new DateTime(2025, 10, 25, 12, 0, 0),
                Price = 70.00m,
                MaxParticipants = 6,
                Participants = 3,
                WorkshopType = "Children"
            },
            new Workshop
            {
                Name = "Managing Screen Time",
                Description = "Parents learn techniques for balancing technology use with family and learning time.",
                Status = "Closed",
                Date = new DateTime(2025, 10, 5, 17, 0, 0),
                Price = 90.00m,
                MaxParticipants = 9,
                Participants = 5,
                WorkshopType = "Parents"
            },
            new Workshop
            {
                Name = "Mindfulness for Kids",
                Description = "Interactive mindfulness activities to help children reduce stress and improve focus.",
                Status = "Closed",
                Date = new DateTime(2025, 11, 2, 12, 0, 0),
                Price = 80.00m,
                MaxParticipants = 10,
                Participants = 7,
                WorkshopType = "Children"
            },
            new Workshop
            {
                Name = "Nutrition and Healthy Habits",
                Description = "A parent-focused workshop on nutrition, sleep, and building healthy daily routines.",
                Status = "Closed",
                Date = new DateTime(2025, 9, 15, 17, 0, 0),
                Price = 100.00m,
                MaxParticipants = 12,
                Participants = 6,
                WorkshopType = "Parents"
            },
            new Workshop
            {
                Name = "Confidence Building Games",
                Description = "Games and teamwork activities designed to increase children's self-esteem.",
                Status = "Closed",
                Date = new DateTime(2025, 10, 22, 11, 0, 0),
                Price = 85.00m,
                MaxParticipants = 15,
                Participants = 6,
                WorkshopType = "Children"
            },
            new Workshop
            {
                Name = "Stress Management for Parents",
                Description = "Helping parents cope with stress and maintain emotional balance while caregiving.",
                Status = "Closed",
                Date = new DateTime(2025, 9, 28, 16, 0, 0),
                Price = 100.00m,
                MaxParticipants = 15,
                Participants = 8,
                WorkshopType = "Parents"
            },
            new Workshop
            {
                Name = "Movement for Children",
                Description = "Fun rhythmic activities that promote coordination and language development.",
                Status = "Closed",
                Date = new DateTime(2025, 7, 12, 9, 0, 0),
                Price = 75.00m,
                MaxParticipants = 9,
                Participants = 9,
                WorkshopType = "Children"
            },
            new Workshop
            {
                Name = "Understanding Sensory Overload",
                Description = "Parents learn to recognize sensory triggers and how to help children self-regulate.",
                Status = "Published",
                Date = new DateTime(2025, 12, 18, 15, 0, 0),
                Price = 130.00m,
                MaxParticipants = 14,
                Participants = 9,
                WorkshopType = "Parents"
            },
            new Workshop
            {
                Name = "Exploring Emotions Through Art",
                Description = "Art-based activities helping children identify and communicate feelings.",
                Status = "Published",
                Date = new DateTime(2025, 12, 30, 10, 0, 0),
                Price = 90.00m,
                MaxParticipants = 8,
                Participants = 6,
                WorkshopType = "Children"
            },
            new Workshop
            {
                Name = "Emotional Intelligence for Children",
                Description = "Activities to help children recognize and manage their emotions.",
                Status = "Closed",
                Date = new DateTime(2025, 11, 5, 10, 0, 0),
                Price = 95.00m,
                MaxParticipants = 12,
                Participants = 8,
                WorkshopType = "Children"
            },
            new Workshop
            {
                Name = "Positive Discipline Techniques",
                Description = "Parent-focused session on disciplining children constructively.",
                Status = "Closed",
                Date = new DateTime(2025, 10, 15, 17, 0, 0),
                Price = 120.00m,
                MaxParticipants = 15,
                Participants = 10,
                WorkshopType = "Parents"
            },
            new Workshop
            {
                Name = "Music and Rhythm Therapy",
                Description = "Interactive session for children to develop coordination and rhythm skills.",
                Status = "Published",
                Date = new DateTime(2025, 12, 5, 14, 0, 0),
                Price = 85.00m,
                MaxParticipants = 10,
                Participants = 6,
                WorkshopType = "Children"
            },
            new Workshop
            {
                Name = "Parent Support Group",
                Description = "Monthly meeting for parents to share experiences and strategies.",
                Status = "Closed",
                Date = new DateTime(2025, 9, 20, 18, 0, 0),
                Price = 50.00m,
                MaxParticipants = 20,
                Participants = 15,
                WorkshopType = "Parents"
            },
            new Workshop
            {
                Name = "STEM Fun for Kids",
                Description = "Hands-on science, technology, engineering, and math activities for children.",
                Status = "Closed",
                Date = new DateTime(2025, 11, 1, 11, 0, 0),
                Price = 90.00m,
                MaxParticipants = 8,
                Participants = 5,
                WorkshopType = "Children"
            },
            new Workshop
            {
                Name = "Mindfulness and Relaxation for Parents",
                Description = "Techniques to reduce stress and maintain calm in parenting.",
                Status = "Closed",
                Date = new DateTime(2025, 10, 10, 16, 0, 0),
                Price = 100.00m,
                MaxParticipants = 12,
                Participants = 9,
                WorkshopType = "Parents"
            },
            new Workshop
            {
                Name = "Creative Writing for Children",
                Description = "Encouraging imagination and literacy through storytelling and writing.",
                Status = "Published",
                Date = new DateTime(2025, 12, 12, 10, 0, 0),
                Price = 75.00m,
                MaxParticipants = 10,
                Participants = 7,
                WorkshopType = "Children"
            },
            new Workshop
            {
                Name = "Healthy Eating Habits for Families",
                Description = "Practical guidance for parents to promote nutrition and wellness at home.",
                Status = "Published",
                Date = new DateTime(2025, 11, 25, 15, 0, 0),
                Price = 110.00m,
                MaxParticipants = 14,
                Participants = 10,
                WorkshopType = "Parents"
            },
            new Workshop
            {
                Name = "Outdoor Adventure and Play",
                Description = "Encouraging children to explore nature and develop motor skills.",
                Status = "Closed",
                Date = new DateTime(2025, 10, 22, 9, 0, 0),
                Price = 80.00m,
                MaxParticipants = 12,
                Participants = 9,
                WorkshopType = "Children"
            },
            new Workshop
            {
                Name = "Stress-Free Homework Strategies",
                Description = "Helping parents guide their children through homework without stress.",
                Status = "Closed",
                Date = new DateTime(2025, 9, 30, 17, 0, 0),
                Price = 95.00m,
                MaxParticipants = 10,
                Participants = 6,
                WorkshopType = "Parents"
            }

        };

        context.Workshops.AddRange(workshops);
        context.SaveChanges();
        Console.WriteLine("✓ Seeded Workshops");
    }

    private static void SeedReviews(CareConnectContext context)
    {
        if (context.Reviews.Any()) return;

        var mikaeelId = context.Users.First(u => u.Username == "mikaeel").UserId;
        var daniyalId = context.Users.First(u => u.Username == "daniyal").UserId;
        var yusufId = context.Users.First(u => u.Username == "yusuf").UserId;
        var clientId = context.Users.First(u => u.Username == "client").UserId;

        var maryamId = context.Users.First(u => u.Username == "maryam").UserId;
        var ismaaId = context.Users.First(u => u.Username == "ismaa").UserId;
        var rahmaId = context.Users.First(u => u.Username == "rahma").UserId;
        var employeeId = context.Users.First(u => u.Username == "employee").UserId;


        var reviews = new[]
        {
            new Review
            {
                UserId = mikaeelId,
                Title = "Outstanding Support",
                Content = "The employee was extremely professional and attentive. They provided clear guidance and handled all questions efficiently.",
                PublishDate = new DateTime(2025, 9, 1),
                EmployeeId = ismaaId, 
                Stars = 5
            },
            new Review
            {
                UserId = daniyalId,
                Title = "Very Helpful",
                Content = "The employee was very helpful and patient. Their advice was practical and easy to understand.",
                PublishDate = new DateTime(2025, 3, 5),
                EmployeeId = maryamId,
                Stars = 4
            },
            new Review
            {
                UserId = yusufId,
                Title = "Positive Experience",
                Content = "The employee was friendly and professional. I felt supported throughout the process.",
                PublishDate = new DateTime(2025, 1, 2),
                EmployeeId = rahmaId, 
                Stars = 4
            },
            new Review
            {
                UserId = daniyalId,
                Title = "Excellent Assistance",
                Content = "The employee provided excellent assistance and made everything easy to follow. Highly recommended.",
                PublishDate = new DateTime(2025, 9, 12),
                EmployeeId = employeeId,
                Stars = 4
            },
            new Review
            {
                UserId = daniyalId,
                Title = "Professional and Knowledgeable",
                Content = "The employee was very knowledgeable and professional. Their guidance was extremely valuable.",
                PublishDate = new DateTime(2025, 9, 10),
                EmployeeId = employeeId,
                Stars = 5
            },
            new Review
            {
                UserId = clientId,
                Title = "Professional and Knowledgeable",
                Content = "The employee was very knowledgeable and professional. Highly recommended.",
                PublishDate = new DateTime(2025, 10, 10),
                EmployeeId = employeeId,
                Stars = 5
            }
        };

        context.Reviews.AddRange(reviews);
        context.SaveChanges();
        Console.WriteLine("✓ Seeded Reviews");
    }

    private static void SeedParticipants(CareConnectContext context)
    {
        if (context.Participants.Any()) return;

        var workshops = context.Workshops.OrderBy(w => w.WorkshopId).ToList();
        var clients = context.Clients.ToList();
        var clientsChildren = context.ClientsChildren.Include(cc => cc.Child).ToList();
        var presentStatusId = context.AttendanceStatuses.First(a => a.Name == "Present").AttendanceStatusId;

        var participants = new List<Participant>();
        var random = new Random();

        foreach (var workshop in workshops)
        {
            int numberOfParticipants = workshop.Participants.Value;

            if (numberOfParticipants == 0) continue; 

            if (workshop.WorkshopType == "Parents")
            {
                var parentClients = clients.OrderBy(_ => random.Next()).Take(numberOfParticipants).ToList();

                foreach (var client in parentClients)
                {
                    var daysBefore = random.Next(1, 61);
                    var registrationDate = workshop.Date.AddDays(-daysBefore);

                        
                    if(workshop.Price != null)
                    {
                        participants.Add(new Participant
                        {
                            UserId = client.ClientId,
                            WorkshopId = workshop.WorkshopId,
                            ChildId = null,
                            AttendanceStatusId = presentStatusId,
                            RegistrationDate = registrationDate,
                            ModifiedDate = registrationDate, 
                            PaymentIntentId = "pi_3SD9ww14TOVbfgZv1BcvMmbn"
                        });
                    }
                    else
                    {
                        participants.Add(new Participant
                        {
                            UserId = client.ClientId,
                            WorkshopId = workshop.WorkshopId,
                            ChildId = null,
                            AttendanceStatusId = presentStatusId,
                            RegistrationDate = registrationDate,
                            ModifiedDate = registrationDate
                        });
                    }
                }
            }
            else if (workshop.WorkshopType == "Children")
            {
                var eligibleClients = clientsChildren.OrderBy(_ => random.Next()).Take(numberOfParticipants).ToList();

                foreach (var cc in eligibleClients)
                {
                    var daysBefore = random.Next(1, 61);
                    var registrationDate = workshop.Date.AddDays(-daysBefore);

                    if (workshop.Price != null)
                    {

                        participants.Add(new Participant
                        {
                            UserId = cc.ClientId,
                            ChildId = cc.ChildId,
                            WorkshopId = workshop.WorkshopId,
                            AttendanceStatusId = presentStatusId,
                            RegistrationDate = registrationDate,
                            ModifiedDate = registrationDate,
                            PaymentIntentId = "pi_3SD9ww14TOVbfgZv1BcvMmbn"
                        });
                    }
                    else
                    {
                        participants.Add(new Participant
                        {
                            UserId = cc.ClientId,
                            ChildId = cc.ChildId,
                            WorkshopId = workshop.WorkshopId,
                            AttendanceStatusId = presentStatusId,
                            RegistrationDate = registrationDate,
                            ModifiedDate = registrationDate
                        });
                    }

                }
            }
        }

        context.Participants.AddRange(participants);
        context.SaveChanges();
        Console.WriteLine("✓ Seeded Participants");
    }

    private static void SeedEmployeeAvailabilities(CareConnectContext context)
    {
        if (context.EmployeeAvailabilities.Any()) return;

        var aaliyahId = context.Users.First(u => u.Username == "aaliyah").UserId;
        var maryamId = context.Users.First(u => u.Username == "maryam").UserId;
        var aminaId = context.Users.First(u => u.Username == "amina").UserId;
        var safiyaId = context.Users.First(u => u.Username == "safiya").UserId;
        var hannahId = context.Users.First(u => u.Username == "hannah").UserId;
        var ismaaId = context.Users.First(u => u.Username == "ismaa").UserId;
        var rahmaId = context.Users.First(u => u.Username == "rahma").UserId;
        var employeeId = context.Users.First(u => u.Username == "employee").UserId;

        var services = context.Services.OrderBy(s => s.ServiceId).ToList();

        var availabilities = new[]
        {
            new EmployeeAvailability { EmployeeId = aaliyahId, ServiceId = services[0].ServiceId, DayOfWeek = "Monday", StartTime = "10:00", EndTime = "12:00"},
            new EmployeeAvailability { EmployeeId = aaliyahId, ServiceId = services[0].ServiceId, DayOfWeek = "Tuesday", StartTime = "12:00", EndTime = "14:00"},
            new EmployeeAvailability { EmployeeId = aaliyahId, ServiceId = services[1].ServiceId, DayOfWeek = "Monday", StartTime = "14:00", EndTime = "16:00"},

            new EmployeeAvailability { EmployeeId = maryamId, ServiceId = services[2].ServiceId, DayOfWeek = "Wednesday", StartTime = "10:00", EndTime = "11:00"},
            new EmployeeAvailability { EmployeeId = maryamId, ServiceId = services[3].ServiceId, DayOfWeek = "Monday", StartTime = "8:00", EndTime = "9:00"},
            new EmployeeAvailability { EmployeeId = maryamId, ServiceId = services[3].ServiceId, DayOfWeek = "Friday", StartTime = "9:00", EndTime = "10:00"},

            new EmployeeAvailability { EmployeeId = aminaId, ServiceId = services[4].ServiceId, DayOfWeek = "Thursday", StartTime = "10:00", EndTime = "12:00"},
            new EmployeeAvailability { EmployeeId = aminaId, ServiceId = services[0].ServiceId, DayOfWeek = "Monday", StartTime = "9:00", EndTime = "11:00"},
            new EmployeeAvailability { EmployeeId = aminaId, ServiceId = services[5].ServiceId, DayOfWeek = "Thursday", StartTime = "12:00", EndTime = "14:00"},

            new EmployeeAvailability { EmployeeId = safiyaId, ServiceId = services[6].ServiceId, DayOfWeek = "Friday", StartTime = "8:00", EndTime = "9:00"},
            new EmployeeAvailability { EmployeeId = safiyaId, ServiceId = services[7].ServiceId, DayOfWeek = "Monday", StartTime = "11:00", EndTime = "13:00"},
            new EmployeeAvailability { EmployeeId = safiyaId, ServiceId = services[1].ServiceId, DayOfWeek = "Tuesday", StartTime = "16:00", EndTime = "18:00"},

            new EmployeeAvailability { EmployeeId = hannahId, ServiceId = services[2].ServiceId, DayOfWeek = "Monday", StartTime = "9:00", EndTime = "10:00"},
            new EmployeeAvailability { EmployeeId = hannahId, ServiceId = services[8].ServiceId, DayOfWeek = "Tuesday", StartTime = "10:00", EndTime = "11:00"},
            new EmployeeAvailability { EmployeeId = hannahId, ServiceId = services[9].ServiceId, DayOfWeek = "Wednesday", StartTime = "8:00", EndTime = "10:00"},

            new EmployeeAvailability { EmployeeId = ismaaId, ServiceId = services[4].ServiceId, DayOfWeek = "Thursday", StartTime = "9:00", EndTime = "11:00"},
            new EmployeeAvailability { EmployeeId = ismaaId, ServiceId = services[5].ServiceId, DayOfWeek = "Tuesday", StartTime = "10:00", EndTime = "12:00"},
            new EmployeeAvailability { EmployeeId = ismaaId, ServiceId = services[6].ServiceId, DayOfWeek = "Wednesday", StartTime = "9:00", EndTime = "10:00"},

            new EmployeeAvailability { EmployeeId = rahmaId, ServiceId = services[7].ServiceId, DayOfWeek = "Monday", StartTime = "9:00", EndTime = "11:00"},
            new EmployeeAvailability { EmployeeId = rahmaId, ServiceId = services[8].ServiceId, DayOfWeek = "Tuesday", StartTime = "11:00", EndTime = "12:00"},
            new EmployeeAvailability { EmployeeId = rahmaId, ServiceId = services[9].ServiceId, DayOfWeek = "Monday", StartTime = "12:00", EndTime = "14:00"},

            new EmployeeAvailability { EmployeeId = employeeId, ServiceId = services[4].ServiceId, DayOfWeek = "Monday", StartTime = "9:00", EndTime = "11:00"},
            new EmployeeAvailability { EmployeeId = employeeId, ServiceId = services[6].ServiceId, DayOfWeek = "Tuesday", StartTime = "10:00", EndTime = "11:00"},
            new EmployeeAvailability { EmployeeId = employeeId, ServiceId = services[8].ServiceId, DayOfWeek = "Friday", StartTime = "8:00", EndTime = "9:00"},
            new EmployeeAvailability { EmployeeId = employeeId, ServiceId = services[1].ServiceId, DayOfWeek = "Friday", StartTime = "10:00", EndTime = "14:00"},
        };

        context.EmployeeAvailabilities.AddRange(availabilities);
        context.SaveChanges();
        Console.WriteLine("✓ Seeded EmployeeAvailabilities");
    }

    private static void SeedAppointments(CareConnectContext context)
    {
        if (context.Appointments.Any()) return;

        var mikaeelId = context.Users.First(u => u.Username == "mikaeel").UserId;
        var daniyalId = context.Users.First(u => u.Username == "daniyal").UserId;
        var yusufId = context.Users.First(u => u.Username == "yusuf").UserId;
        var rashidId = context.Users.First(u => u.Username == "rashid").UserId;
        var waleedId = context.Users.First(u => u.Username == "waleed").UserId;
        var davidId = context.Users.First(u => u.Username == "david").UserId;
        var sofiaId = context.Users.First(u => u.Username == "sofia").UserId;
        var karimaId = context.Users.First(u => u.Username == "karima").UserId;
        var mariamId = context.Users.First(u => u.Username == "mariam").UserId;
        var clientTestId = context.Users.First(u => u.Username == "client").UserId;

        var clientsChildren = context.ClientsChildren.OrderBy(cc => cc.ClientId).ThenBy(cc => cc.ChildId).ToList();
        var availabilities = context.EmployeeAvailabilities.OrderBy(ea => ea.EmployeeAvailabilityId).ToList();

        var presentStatusId = context.AttendanceStatuses.First(a => a.Name == "Present").AttendanceStatusId;
        var absentStatusId = context.AttendanceStatuses.First(a => a.Name == "Absent").AttendanceStatusId;
        var lateStatusId = context.AttendanceStatuses.First(a => a.Name == "Late").AttendanceStatusId;
        var excusedStatusId = context.AttendanceStatuses.First(a => a.Name == "Excused").AttendanceStatusId;

        var appointments = new[]
        {
            new Appointment
            {
                ClientId = clientsChildren[0].ClientId,
                ChildId = clientsChildren[0].ChildId,
                EmployeeAvailabilityId = availabilities[0].EmployeeAvailabilityId,
                AppointmentType = "Consultation",
                AttendanceStatusId = presentStatusId,
                Date = new DateTime(2025, 10, 1),
                StateMachine = "Completed",
                PaymentIntentId = "pi_3SDPrZ14TOVbfgZv0OyC0K7C"
            },
            new Appointment
            {
                ClientId = clientsChildren[1].ClientId,
                ChildId = clientsChildren[1].ChildId,
                EmployeeAvailabilityId = availabilities[1].EmployeeAvailabilityId,
                AppointmentType = "Followup",
                AttendanceStatusId = absentStatusId,
                StateMachine = "Canceled", 
                Date = new DateTime(2025, 6, 3),
                Note = "Absent due to illness",
                PaymentIntentId = "pi_3SDPrZ14TOVbfgZv0OyC0K7C"
            },
            new Appointment
            {
                ClientId = clientsChildren[2].ClientId,
                ChildId = clientsChildren[2].ChildId,
                EmployeeAvailabilityId = availabilities[2].EmployeeAvailabilityId,
                AppointmentType = "Checkup",
                AttendanceStatusId = lateStatusId,
                Date = new DateTime(2025, 8, 5),
                Note = "Late arrival due to traffic", 
                StateMachine = "Completed",
                PaymentIntentId = "pi_3SDPrZ14TOVbfgZv0OyC0K7C"
            },
            new Appointment
            {
                ClientId = clientsChildren[3].ClientId,
                ChildId = clientsChildren[3].ChildId,
                EmployeeAvailabilityId = availabilities[3].EmployeeAvailabilityId,
                AppointmentType = "Consultation",
                AttendanceStatusId = presentStatusId,
                Date = new DateTime(2025, 10, 7),
                Note = "On time, very productive", 
                StateMachine = "Completed",
                PaymentIntentId = "pi_3SDPrZ14TOVbfgZv0OyC0K7C"
            },
            new Appointment
            {
                ClientId = clientsChildren[4].ClientId,
                ChildId = clientsChildren[4].ChildId,
                EmployeeAvailabilityId = availabilities[4].EmployeeAvailabilityId,
                AppointmentType = "Training",
                AttendanceStatusId = excusedStatusId,
                Date = new DateTime(2025, 10, 15),
                StateMachine = "Canceled",
                PaymentIntentId = "pi_3SDPrZ14TOVbfgZv0OyC0K7C"
            },
            new Appointment
            {
                ClientId = clientsChildren[5].ClientId,
                ChildId = clientsChildren[5].ChildId,
                EmployeeAvailabilityId = availabilities[5].EmployeeAvailabilityId,
                AppointmentType = "Consultation",
                AttendanceStatusId = presentStatusId,
                Date = new DateTime(2025, 9, 21),
                StateMachine = "Completed",
                PaymentIntentId = "pi_3SDPrZ14TOVbfgZv0OyC0K7C"
            },
            new Appointment
            {
                ClientId = clientsChildren[6].ClientId,
                ChildId = clientsChildren[6].ChildId,
                EmployeeAvailabilityId = availabilities[6].EmployeeAvailabilityId,
                AppointmentType = "Followup",
                AttendanceStatusId = absentStatusId,
                Date = new DateTime(2025, 9, 15),
                Note = "Absent due to vacation",
                StateMachine = "Canceled",
                PaymentIntentId = "pi_3SDPrZ14TOVbfgZv0OyC0K7C"
            },
            new Appointment
            {
                ClientId = clientsChildren[10].ClientId,
                ChildId = clientsChildren[10].ChildId,
                EmployeeAvailabilityId = availabilities[21].EmployeeAvailabilityId,
                AppointmentType = "Consultation",
                AttendanceStatusId = presentStatusId,
                Date = new DateTime(2025, 10, 1),
                StateMachine = "Completed",
                PaymentIntentId = "pi_3SDPrZ14TOVbfgZv0OyC0K7C"
            },
            new Appointment
            {
                ClientId = clientsChildren[8].ClientId,
                ChildId = clientsChildren[8].ChildId,
                EmployeeAvailabilityId = availabilities[8].EmployeeAvailabilityId,
                AppointmentType = "Followup",
                AttendanceStatusId = absentStatusId,
                Date = new DateTime(2025, 8, 3),
                Note = "Absent due to illness", 
                StateMachine = "Canceled",
                PaymentIntentId = "pi_3SDPrZ14TOVbfgZv0OyC0K7C"
            },
            new Appointment
            {
                ClientId = clientsChildren[9].ClientId,
                ChildId = clientsChildren[9].ChildId,
                EmployeeAvailabilityId = availabilities[9].EmployeeAvailabilityId,
                AppointmentType = "Training",
                AttendanceStatusId = lateStatusId,
                Date = new DateTime(2025, 10, 5),
                StateMachine = "Completed",
                PaymentIntentId = "pi_3SDPrZ14TOVbfgZv0OyC0K7C"

            },
            new Appointment
            {
                ClientId = clientsChildren[10].ClientId,
                ChildId = clientsChildren[10].ChildId,
                EmployeeAvailabilityId = availabilities[10].EmployeeAvailabilityId,
                AppointmentType = "Consultation",
                AttendanceStatusId = presentStatusId,
                Date = new DateTime(2025, 9, 7),
                StateMachine = "Completed",
                PaymentIntentId = "pi_3SDPrZ14TOVbfgZv0OyC0K7C"

            },
            new Appointment
            {
                ClientId = clientsChildren[11].ClientId,
                ChildId = clientsChildren[11].ChildId,
                EmployeeAvailabilityId = availabilities[11].EmployeeAvailabilityId,
                AppointmentType = "Training",
                AttendanceStatusId = presentStatusId,
                Date = new DateTime(2025, 12, 15),
                StateMachine = "Scheduled",
                PaymentIntentId = "pi_3SDPrZ14TOVbfgZv0OyC0K7C"
            },
            new Appointment
            {
                ClientId = clientsChildren[12].ClientId,
                ChildId = clientsChildren[12].ChildId,
                EmployeeAvailabilityId = availabilities[12].EmployeeAvailabilityId,
                AppointmentType = "Consultation",
                AttendanceStatusId = presentStatusId,
                Date = new DateTime(2025, 12, 12),
                StateMachine = "Confirmed",
                PaymentIntentId = "pi_3SDPrZ14TOVbfgZv0OyC0K7C"
            },
            new Appointment
            {
                ClientId = clientsChildren[13].ClientId,
                ChildId = clientsChildren[13].ChildId,
                EmployeeAvailabilityId = availabilities[13].EmployeeAvailabilityId,
                AppointmentType = "Followup",
                AttendanceStatusId = presentStatusId,
                Date = new DateTime(2025, 12, 15),
                StateMachine = "Confirmed",
                PaymentIntentId = "pi_3SDPrZ14TOVbfgZv0OyC0K7C"
            },
            new Appointment
            {
                ClientId = clientsChildren[14].ClientId,
                ChildId = clientsChildren[14].ChildId,
                EmployeeAvailabilityId = availabilities[14].EmployeeAvailabilityId,
                AppointmentType = "Followup",
                AttendanceStatusId = presentStatusId,
                Date = new DateTime(2025, 12, 16),
                StateMachine = "Scheduled", 
                PaymentIntentId = "pi_3SDPrZ14TOVbfgZv0OyC0K7C"
            },
            new Appointment
            {
                ClientId = clientsChildren[12].ClientId,
                ChildId = clientsChildren[12].ChildId,
                EmployeeAvailabilityId = availabilities[21].EmployeeAvailabilityId,
                AppointmentType = "Consultation",
                AttendanceStatusId = presentStatusId,
                Date = new DateTime(2025, 12, 15),
                StateMachine = "Scheduled",
                PaymentIntentId = "pi_3SDPrZ14TOVbfgZv0OyC0K7C"
            },
            new Appointment
            {
                ClientId = clientsChildren[13].ClientId,
                ChildId = clientsChildren[13].ChildId,
                EmployeeAvailabilityId = availabilities[22].EmployeeAvailabilityId,
                AppointmentType = "Followup",
                AttendanceStatusId = presentStatusId,
                Date = new DateTime(2025, 12, 16),
                StateMachine = "Confirmed",
                PaymentIntentId = "pi_3SDPrZ14TOVbfgZv0OyC0K7C"
            },
            new Appointment
            {
                ClientId = clientsChildren[14].ClientId,
                ChildId = clientsChildren[14].ChildId,
                EmployeeAvailabilityId = availabilities[23].EmployeeAvailabilityId,
                AppointmentType = "Followup",
                AttendanceStatusId = presentStatusId,
                StateMachine = "Scheduled",
                Date = new DateTime(2025, 12, 26),
                PaymentIntentId = "pi_3SDPrZ14TOVbfgZv0OyC0K7C"
            }
        };

        context.Appointments.AddRange(appointments);
        context.SaveChanges();
        Console.WriteLine("✓ Seeded Appointments");
    }

    private static void SeedPermissions(CareConnectContext context)
    {
        if (context.Permissions.Any())
            return;

        var permissionNames = typeof(Permissions)
            .GetNestedTypes(BindingFlags.Public | BindingFlags.Static)
            .SelectMany(nested =>
                nested.GetFields(BindingFlags.Public | BindingFlags.Static | BindingFlags.FlattenHierarchy)
                    .Where(f => f.IsLiteral && !f.IsInitOnly && f.FieldType == typeof(string))
                    .Select(f => (string)f.GetRawConstantValue()!)
            )
            .ToList();

        var permissionEntities = permissionNames
            .Select((name, index) => new Permission
            {
                Name = name
            })
            .ToList();

        context.Permissions.AddRange(permissionEntities);
        context.SaveChanges();
    }

    private static void SeedRolePermissions(CareConnectContext context)
    {
        var admin = context.Roles.Include(r => r.Permissions).FirstOrDefault(r => r.Name == "Admin");
        var employee = context.Roles.Include(r => r.Permissions).FirstOrDefault(r => r.Name == "Employee");
        var client = context.Roles.Include(r => r.Permissions).FirstOrDefault(r => r.Name == "Client");

        if (admin == null || employee == null || client == null)
            return;

        var allPermissions = context.Permissions.ToList();

        admin.Permissions = allPermissions;

        employee.Permissions = allPermissions
            .Where(p => p.Name == "Permissions.Child.Get" ||
                        p.Name == "Permissions.Employee.ViewEmployeeAvailability" ||
                        p.Name == "Permissions.EmployeeAvailability.GetById" ||
                        p.Name == "Permissions.Appointment.View" ||
                        p.Name == "Permissions.Appointment.Get" ||
                        p.Name == "Permissions.Appointment.Update" ||
                        p.Name == "Permissions.Appointment.Cancel" ||
                        p.Name == "Permissions.Appointment.GetById" ||
                        p.Name == "Permissions.Appointment.Reschedule" ||
                        p.Name == "Permissions.Appointment.RescheduleRequested" ||
                        p.Name == "Permissions.Appointment.Confirm" ||
                        p.Name == "Permissions.ClientsChild.Get" ||
                        p.Name == "Permissions.ClientsChild.GetAppointment" ||
                        p.Name == "Permissions.Appointment.Start" ||
                        p.Name == "Permissions.Appointment.Complete" ||
                        p.Name == "Permissions.Appointment.GetAppointmentTypes" ||
                        p.Name == "Permissions.Workshop.View" ||
                        p.Name == "Permissions.Workshop.Get" ||
                        p.Name == "Permissions.Workshop.GetStatistics" ||
                        p.Name == "Permissions.Workshop.Insert" ||
                        p.Name == "Permissions.Workshop.GetById" ||
                        p.Name == "Permissions.Workshop.Publish" ||
                        p.Name == "Permissions.Workshop.Close" ||
                        p.Name == "Permissions.Workshop.Cancel" ||
                        p.Name == "Permissions.Participant.Get" ||
                        p.Name == "Permissions.Participant.Update" ||
                        p.Name == "Permissions.Participant.GetById" ||
                        p.Name == "Permissions.Workshop.Update" ||
                        p.Name == "Permissions.Workshop.PredictForNewWorkshop" ||
                        p.Name == "Permissions.Client.View" ||
                        p.Name == "Permissions.Client.Insert" ||
                        p.Name == "Permissions.ClientsChild.GetStatistics" ||
                        p.Name == "Permissions.Client.GetById" ||
                        p.Name == "Permissions.Client.GetChildren" ||
                        p.Name == "Permissions.Child.GetById" ||
                        p.Name == "Permissions.Child.Update" ||
                        p.Name == "Permissions.Client.AddChildren" ||
                        p.Name == "Permissions.ClientsChild.Update" ||
                        p.Name == "Permissions.Review.View" ||
                        p.Name == "Permissions.Review.Get" || 
                        p.Name == "Permissions.Review.ViewOwn" ||
                        p.Name == "Permissions.Review.GetAverage" ||
                        p.Name == "Permissions.Service.View" ||
                        p.Name == "Permissions.Service.Get" ||
                        p.Name == "Permissions.Service.GetStatistics" ||
                        p.Name == "Permissions.Service.GetById" ||
                        p.Name == "Permissions.ServiceType.Get" ||
                        p.Name == "Permissions.User.Update" ||
                        p.Name == "Permissions.User.GetById" ||
                        p.Name == "Permissions.User.ChangePassword")
            .ToList();

        client.Permissions = allPermissions
            .Where(p => p.Name == "Permissions.Appointment.Get" ||
                        p.Name == "Permissions.ServiceType.Get" ||
                        p.Name == "Permissions.Appointment.GetById" ||
                        p.Name == "Permissions.Appointment.Cancel" ||
                        p.Name == "Permissions.Appointment.ReschedulePendingApproval" ||
                        p.Name == "Permissions.Workshop.Get" ||
                        p.Name == "Permissions.Participant.Get" || 
                        p.Name == "Permissions.Workshop.GetById" ||
                        p.Name == "Permissions.Client.GetChildren" ||
                        p.Name == "Permissions.Workshop.Enroll" ||
                        p.Name == "Permissions.Payment.CreatePaymentIntent" ||
                        p.Name == "Permissions.Payment.VerifyPayment" ||
                        p.Name == "Permissions.Client.GetById" ||
                        p.Name == "Permissions.Client.Delete" ||
                        p.Name == "Permissions.Child.Delete" ||
                        p.Name == "Permissions.Service.Get" ||
                        p.Name == "Permissions.Service.GetById" ||
                        p.Name == "Permissions.Service.GetEmployeesForService" ||
                        p.Name == "Permissions.Appointment.Insert" ||
                        p.Name == "Permissions.Employee.GetEmployeeAvailability" ||
                        p.Name == "Permissions.Appointment.GetAppointmentTypes" ||
                        p.Name == "Permissions.Review.Get" || 
                        p.Name == "Permissions.EmployeeAvailability.Get" ||
                        p.Name == "Permissions.Review.Insert" ||
                        p.Name == "Permissions.Review.Delete" ||
                        p.Name == "Permissions.Review.Update" ||
                        p.Name == "Permissions.Client.Update" ||
                        p.Name == "Permissions.Client.AddChildren" || 
                        p.Name == "Permissions.Child.Update" || 
                        p.Name == "Permissions.Child.GetById" ||
                        p.Name == "Permissions.Client.RemoveChildren")
            .ToList();

        context.SaveChanges();
    }

}
