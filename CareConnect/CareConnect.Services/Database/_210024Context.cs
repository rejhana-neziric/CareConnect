using System;
using System.Collections.Generic;
using EasyNetQ.Logging;
using Microsoft.EntityFrameworkCore;

namespace CareConnect.Services.Database;

public partial class CareConnectContext : DbContext
{
    public CareConnectContext()
    {
    }

    public CareConnectContext(DbContextOptions<CareConnectContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Appointment> Appointments { get; set; }

    public virtual DbSet<AttendanceStatus> AttendanceStatuses { get; set; }

    public virtual DbSet<Child> Children { get; set; }

    public virtual DbSet<Client> Clients { get; set; }

    public virtual DbSet<ClientsChild> ClientsChildren { get; set; }

    public virtual DbSet<Employee> Employees { get; set; }

    public virtual DbSet<EmployeeAvailability> EmployeeAvailabilities { get; set; }

    public virtual DbSet<Participant> Participants { get; set; }

    public virtual DbSet<Payment> Payments { get; set; }

    public virtual DbSet<Permission> Permissions { get; set; }

    public virtual DbSet<Qualification> Qualifications { get; set; }

    public virtual DbSet<Review> Reviews { get; set; }

    public virtual DbSet<Role> Roles { get; set; }

    public virtual DbSet<Service> Services { get; set; }

    public virtual DbSet<ServiceType> ServiceTypes { get; set; }

    public virtual DbSet<User> Users { get; set; }

    public virtual DbSet<UsersRole> UsersRoles { get; set; }

    public virtual DbSet<Workshop> Workshops { get; set; }



    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Data Source=DESKTOP-BRFTFE0\\MSSQLSERVER9;Initial Catalog=_210024;Trusted_Connection=True;User ID=sa;Password=QWEasd123!;MultipleActiveResultSets=true; TrustServerCertificate=true"); 
        //.LogTo(Console.WriteLine).EnableSensitiveDataLogging();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Appointment>(entity =>
        {
            entity.HasKey(e => e.AppointmentId).HasName("PK__Appointm__8ECDFCA2BDE101EB");

            entity.Property(e => e.AppointmentId).HasColumnName("AppointmentID");
            entity.Property(e => e.AppointmentType).HasMaxLength(50);
            entity.Property(e => e.AttendanceStatusId).HasColumnName("AttendanceStatusID");
            entity.Property(e => e.Date).HasColumnType("datetime");
            entity.Property(e => e.Description).HasColumnType("text");
            entity.Property(e => e.EmployeeAvailabilityId).HasColumnName("EmployeeAvailabilityID");
            entity.Property(e => e.ModifiedDate)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.Note)
                .HasColumnType("text")
                .HasColumnName("NOTE");
            entity.Property(e => e.StateMachine).HasMaxLength(50);
            

            entity.HasOne(d => d.AttendanceStatus).WithMany(p => p.Appointments)
                .HasForeignKey(d => d.AttendanceStatusId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Appointments_AttendanceStatus");

            entity.HasOne(d => d.EmployeeAvailability).WithMany(p => p.Appointments)
                .HasForeignKey(d => d.EmployeeAvailabilityId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Appointments_EmployeeAvailability");

            entity.HasOne(d => d.ClientsChild)
                     .WithMany(p => p.Appointments)
                     .HasForeignKey(d => new { d.ClientId, d.ChildId })
                     .OnDelete(DeleteBehavior.Cascade)
                     .HasConstraintName("FK_Appointments_ClientsChildren");

        });

        modelBuilder.Entity<AttendanceStatus>(entity =>
        {
            entity.HasKey(e => e.AttendanceStatusId).HasName("PK__Attendan__7696A71507991871");

            entity.ToTable("AttendanceStatus");

            entity.Property(e => e.AttendanceStatusId).HasColumnName("AttendanceStatusID");
            entity.Property(e => e.ModifiedDate)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.Name).HasMaxLength(50);
        });

        modelBuilder.Entity<Child>(entity =>
        {
            entity.HasKey(e => e.ChildId).HasName("PK__Children__BEFA0736EA5ECDD8");

            entity.Property(e => e.ChildId).HasColumnName("ChildID");
            entity.Property(e => e.BirthDate).HasColumnType("datetime");
            entity.Property(e => e.FirstName).HasMaxLength(50);
            entity.Property(e => e.Gender)
                .HasMaxLength(1)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.LastName).HasMaxLength(50);
            entity.Property(e => e.ModifiedDate)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
        });

        modelBuilder.Entity<Client>(entity =>
        {
            entity.Property(e => e.ClientId)
                .ValueGeneratedNever()
                .HasColumnName("ClientID");
            entity.Property(e => e.ModifiedDate)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");

            entity.HasOne(d => d.User).WithOne(p => p.Client)
                .HasForeignKey<Client>(d => d.ClientId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Clients_Users");
        });

        modelBuilder.Entity<ClientsChild>(entity =>
        {
            entity.HasKey(e => new { e.ClientId, e.ChildId });

            entity.Property(e => e.ClientId).HasColumnName("ClientID");
            entity.Property(e => e.ChildId).HasColumnName("ChildID");
            entity.Property(e => e.ModifiedDate)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");

            entity.HasOne(d => d.Child).WithMany(p => p.ClientsChildren)
                .HasForeignKey(d => d.ChildId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ClientsChildren_Children");

            entity.HasOne(d => d.Client).WithMany(p => p.ClientsChildren)
                .HasForeignKey(d => d.ClientId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ClientsChildren_Clients");
        });

        modelBuilder.Entity<Employee>(entity =>
        {
            entity.Property(e => e.EmployeeId)
                .ValueGeneratedNever()
                .HasColumnName("EmployeeID");
            entity.Property(e => e.HireDate).HasColumnType("datetime");
            entity.Property(e => e.JobTitle).HasMaxLength(50);
            entity.Property(e => e.ModifiedDate)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.QualificationId).HasColumnName("QualificationID");

            entity.HasOne(d => d.User).WithOne(p => p.Employee)
                .HasForeignKey<Employee>(d => d.EmployeeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Employees_Users");

            entity.HasOne(d => d.Qualification).WithMany(p => p.Employees)
                .HasForeignKey(d => d.QualificationId)
                .HasConstraintName("FK_Employees_Qualifications");
        });

        modelBuilder.Entity<EmployeeAvailability>(entity =>
        {
            entity.HasKey(e => e.EmployeeAvailabilityId).HasName("PK__Employee__A9E4B8771C174821");

            entity.ToTable("EmployeeAvailability");

            entity.Property(e => e.EmployeeAvailabilityId).HasColumnName("EmployeeAvailabilityID");
            entity.Property(e => e.DayOfWeek).HasMaxLength(20);
            entity.Property(e => e.EmployeeId).HasColumnName("EmployeeID");
            entity.Property(e => e.EndTime).HasMaxLength(20);
            entity.Property(e => e.ModifiedDate)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.ServiceId).HasColumnName("ServiceID");
            entity.Property(e => e.StartTime).HasMaxLength(20);

            entity.HasOne(d => d.Employee).WithMany(p => p.EmployeeAvailabilities)
                .HasForeignKey(d => d.EmployeeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_EmployeeAvailability_Employees");

            entity.HasOne(d => d.Service).WithMany(p => p.EmployeeAvailabilities)
                .HasForeignKey(d => d.ServiceId)
                .HasConstraintName("FK_EmployeeAvailability_Services");
        });

        modelBuilder.Entity<Participant>(entity =>
        {
            entity.HasKey(e => e.ParticipantId);

            entity.Property(e => e.ParticipantId).ValueGeneratedOnAdd(); 

            entity.Property(e => e.UserId).HasColumnName("UserID");
            entity.Property(e => e.WorkshopId).HasColumnName("WorkshopID");
            entity.Property(e => e.AttendanceStatusId).HasColumnName("AttendanceStatusID");
            entity.Property(e => e.ModifiedDate)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.RegistrationDate).HasColumnType("datetime");

            entity.HasOne(d => d.AttendanceStatus).WithMany(p => p.Participants)
                .HasForeignKey(d => d.AttendanceStatusId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Participants_AttendanceStatus");

            entity.HasOne(d => d.User).WithMany(p => p.Participants)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Participants_Users");

            entity.HasOne(d => d.Workshop).WithMany(p => p.ParticipantsNavigation)
                .HasForeignKey(d => d.WorkshopId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Participants_Workshops");
        });

        modelBuilder.Entity<Payment>(entity =>
        {
            entity.HasKey(e => e.PaymentId).HasName("PK__Payments__9B556A581C157F0D");

            entity.Property(e => e.PaymentId).HasColumnName("PaymentID");
            entity.Property(e => e.PaymentIntentId).IsRequired().HasMaxLength(255);
            entity.Property(e => e.ItemType).IsRequired().HasMaxLength(100); 
            entity.Property(e => e.WorkshopId).IsRequired(false);
            entity.Property(e => e.Amount).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.Currency).IsRequired().HasMaxLength(10);
            entity.Property(e => e.Status).IsRequired().HasMaxLength(50);
            entity.Property(e => e.CreatedAt).HasColumnType("datetime").HasDefaultValueSql("(getdate())"); 
            entity.Property(e => e.CompletedAt).HasColumnType("datetime");
            entity.Property(e => e.UserId).HasColumnName("UserID");

            entity.HasOne(d => d.User).WithMany(p => p.Payments)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Payments_Users");

            entity.Property(e => e.ChildId).HasColumnName("ChildID");
        });

        modelBuilder.Entity<Permission>(entity =>
        {
            entity.HasKey(e => e.PermissionId).HasName("PK__Permissi__EFA6FB2FD9DF3E33");

            entity.Property(e => e.Name).HasMaxLength(200);
        });

        modelBuilder.Entity<Qualification>(entity =>
        {
            entity.HasKey(e => e.QualificationId).HasName("PK__Qualific__C95C128ACC47C0D4");

            entity.Property(e => e.QualificationId).HasColumnName("QualificationID");
            entity.Property(e => e.InstituteName).HasMaxLength(200);
            entity.Property(e => e.ModifiedDate)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.Name).HasMaxLength(200);
            entity.Property(e => e.ProcurementYear).HasColumnType("datetime");
        });

        modelBuilder.Entity<Review>(entity =>
        {
            entity.HasKey(e => e.ReviewId).HasName("PK__Reviews__74BC79AE38912645");

            entity.Property(e => e.ReviewId).HasColumnName("ReviewID");
            entity.Property(e => e.Content).HasMaxLength(300);
            entity.Property(e => e.EmployeeId).HasColumnName("EmployeeID");
            entity.Property(e => e.ModifiedDate)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.PublishDate).HasColumnType("datetime");
            entity.Property(e => e.Title).HasMaxLength(50);
            entity.Property(e => e.UserId).HasColumnName("UserID");

            entity.HasOne(d => d.Employee).WithMany(p => p.Reviews)
                .HasForeignKey(d => d.EmployeeId)
                .HasConstraintName("FK_Reviews_Employees");

            entity.HasOne(d => d.User).WithMany(p => p.Reviews)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Reviews_Users");
        });

        modelBuilder.Entity<Role>(entity =>
        {
            entity.HasKey(e => e.RoleId).HasName("PK__Roles__8AFACE3A1FCEAE44");

            entity.Property(e => e.RoleId).HasColumnName("RoleID");
            entity.Property(e => e.Description).HasMaxLength(50);
            entity.Property(e => e.Name).HasMaxLength(20);

            entity.HasMany(d => d.Permissions).WithMany(p => p.Roles)
                .UsingEntity<Dictionary<string, object>>(
                    "RolePermission",
                    r => r.HasOne<Permission>().WithMany()
                        .HasForeignKey("PermissionId")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK__RolePermi__Permi__3F115E1A"),
                    l => l.HasOne<Role>().WithMany()
                        .HasForeignKey("RoleId")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK__RolePermi__RoleI__3E1D39E1"),
                    j =>
                    {
                        j.HasKey("RoleId", "PermissionId").HasName("PK__RolePerm__6400A1A8026A7CAE");
                        j.ToTable("RolePermissions");
                    });
        });

        modelBuilder.Entity<Service>(entity =>
        {
            entity.HasKey(e => e.ServiceId).HasName("PK__Services__C51BB0EAAE76A19D");

            entity.Property(e => e.ServiceId).HasColumnName("ServiceID");
            entity.Property(e => e.Description).HasColumnType("text");
            entity.Property(e => e.ModifiedDate)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.Name).HasMaxLength(100);
            entity.Property(e => e.Price).HasColumnType("decimal(18, 2)");


            entity.HasOne(d => d.ServiceType).WithMany(p => p.Services)
                .HasForeignKey(d => d.ServiceTypeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Services_ServiceTypes");
        });

        modelBuilder.Entity<ServiceType>(entity =>
        {
            entity.HasKey(e => e.ServiceTypeId); 

            entity.Property(e => e.ServiceTypeId).HasColumnName("ServiceTypeId");
            entity.Property(e => e.Description).HasColumnType("text");
            entity.Property(e => e.Name).HasMaxLength(200);
        });

        modelBuilder.Entity<User>(entity =>
        {
            entity.HasKey(e => e.UserId).HasName("PK__Users__1788CCAC3071E9A0");

            entity.Property(e => e.UserId).HasColumnName("UserID");
            entity.Property(e => e.Address).HasMaxLength(50);
            entity.Property(e => e.BirthDate).HasColumnType("datetime");
            entity.Property(e => e.Email).HasMaxLength(100);
            entity.Property(e => e.FirstName).HasMaxLength(50);
            entity.Property(e => e.Gender)
                .HasMaxLength(1)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.LastName).HasMaxLength(50);
            entity.Property(e => e.ModifiedDate)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.PasswordHash).HasMaxLength(256);
            entity.Property(e => e.PasswordSalt).HasMaxLength(256);
            entity.Property(e => e.PhoneNumber).HasMaxLength(20);
            entity.Property(e => e.Username).HasMaxLength(50);
        });

        modelBuilder.Entity<UsersRole>(entity =>
        {
            entity.HasKey(e => new { e.UserId, e.RoleId });

            entity.Property(e => e.UserId).HasColumnName("UserID");
            entity.Property(e => e.RoleId).HasColumnName("RoleID");
            entity.Property(e => e.ModifiedDate)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");

            entity.HasOne(d => d.Role).WithMany(p => p.UsersRoles)
                .HasForeignKey(d => d.RoleId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_UsersRoles_Roles");

            entity.HasOne(d => d.User).WithMany(p => p.UsersRoles)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_UsersRoles_Users");
        });

        modelBuilder.Entity<Workshop>(entity =>
        {
            entity.HasKey(e => e.WorkshopId).HasName("PK__Workshop__7A008C2A3EFF4987");

            entity.Property(e => e.WorkshopId).HasColumnName("WorkshopID");
            entity.Property(e => e.Description).HasColumnType("text");
            entity.Property(e => e.ModifiedDate)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.Name).HasMaxLength(200);
            entity.Property(e => e.Notes).HasColumnType("text");
            entity.Property(e => e.Price).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.Date).HasColumnType("datetime");
            entity.Property(e => e.Status).HasMaxLength(50);
            entity.Property(e => e.WorkshopType).HasMaxLength(50);
        });

       // SeedData(modelBuilder);


        OnModelCreatingPartial(modelBuilder);
    }

    private void SeedData(ModelBuilder modelBuilder)
    {
        // Seed AttendanceStatus
        modelBuilder.Entity<AttendanceStatus>().HasData(
            new AttendanceStatus { AttendanceStatusId = 1, Name = "Present" },
            new AttendanceStatus { AttendanceStatusId = 2, Name = "Absent" },
            new AttendanceStatus { AttendanceStatusId = 3, Name = "Late" },
            new AttendanceStatus { AttendanceStatusId = 4, Name = "Excused" }
        );

        // Seed Qualifications
        modelBuilder.Entity<Qualification>().HasData(
            new Qualification { QualificationId = 1, Name = "Bachelor of Psychology", InstituteName = "University of Sarajevo", ProcurementYear = new DateTime(2010, 6, 1) },
            new Qualification { QualificationId = 2, Name = "Master of Speech-Language Pathology", InstituteName = "University of Sarajevo", ProcurementYear = new DateTime(2012, 6, 1) },
            new Qualification { QualificationId = 3, Name = "Bachelor of Special Education", InstituteName = "University of Sarajevo", ProcurementYear = new DateTime(2015, 6, 1) },
            new Qualification { QualificationId = 4, Name = "Bachelor of Pedagogy", InstituteName = "University of Sarajevo", ProcurementYear = new DateTime(2013, 6, 1) },
            new Qualification { QualificationId = 5, Name = "Master of Pedagogy", InstituteName = "University of Sarajevo", ProcurementYear = new DateTime(2016, 6, 1) }
        );

        // Seed Users
        modelBuilder.Entity<User>().HasData(
            new User { UserId = 1, FirstName = "Anna", LastName = "Smith", Email = "anna.smith@email.com", PhoneNumber = "123456789", Username = "annasmith", PasswordHash = "hash1", PasswordSalt = "salt1", Status = true, BirthDate = new DateTime(1990, 5, 15), Gender = "F", Address = "123 Main St" },
            new User { UserId = 2, FirstName = "Maria", LastName = "Garcia", Email = "maria.garcia@email.com", PhoneNumber = "123456788", Username = "mariagarcia", PasswordHash = "hash2", PasswordSalt = "salt2", Status = true, BirthDate = new DateTime(1988, 3, 22), Gender = "F", Address = "456 Elm St" },
            new User { UserId = 3, FirstName = "Emily", LastName = "Johnson", Email = "emily.johnson@email.com", PhoneNumber = "123456787", Username = "emilyj", PasswordHash = "hash3", PasswordSalt = "salt3", Status = true, BirthDate = new DateTime(1992, 7, 30), Gender = "F", Address = "789 Oak St" },
            new User { UserId = 4, FirstName = "Sophie", LastName = "Brown", Email = "sophie.brown@email.com", PhoneNumber = "123456786", Username = "sophieb", PasswordHash = "hash4", PasswordSalt = "salt4", Status = true, BirthDate = new DateTime(1985, 11, 10), Gender = "F", Address = "321 Pine St" },
            new User { UserId = 5, FirstName = "Emma", LastName = "Williams", Email = "emma.williams@email.com", PhoneNumber = "123456785", Username = "emmaw", PasswordHash = "hash5", PasswordSalt = "salt5", Status = true, BirthDate = new DateTime(1991, 8, 25), Gender = "F", Address = "654 Cedar St" },
            new User { UserId = 6, FirstName = "Olivia", LastName = "Miller", Email = "olivia.miller@email.com", PhoneNumber = "123456784", Username = "oliviam", PasswordHash = "hash6", PasswordSalt = "salt6", Status = true, BirthDate = new DateTime(1989, 2, 14), Gender = "F", Address = "987 Birch St" },
            new User { UserId = 7, FirstName = "Isabella", LastName = "Davis", Email = "isabella.davis@email.com", PhoneNumber = "123456783", Username = "isabellad", PasswordHash = "hash7", PasswordSalt = "salt7", Status = true, BirthDate = new DateTime(1994, 12, 5), Gender = "F", Address = "246 Walnut St" },
            new User { UserId = 8, FirstName = "Ava", LastName = "Wilson", Email = "ava.wilson@email.com", PhoneNumber = "123456782", Username = "avawilson", PasswordHash = "hash8", PasswordSalt = "salt8", Status = true, BirthDate = new DateTime(1993, 6, 18), Gender = "F", Address = "369 Maple St" },
            new User { UserId = 9, FirstName = "Michael", LastName = "Anderson", Email = "michael.anderson@email.com", PhoneNumber = "223456789", Username = "michaela", PasswordHash = "hash9", PasswordSalt = "salt9", Status = true, BirthDate = new DateTime(1980, 4, 12), Gender = "M", Address = "111 Main St" },
            new User { UserId = 10, FirstName = "Daniel", LastName = "Martinez", Email = "daniel.martinez@email.com", PhoneNumber = "223456788", Username = "danielm", PasswordHash = "hash10", PasswordSalt = "salt10", Status = true, BirthDate = new DateTime(1982, 9, 9), Gender = "M", Address = "222 Elm St" },
            new User { UserId = 11, FirstName = "James", LastName = "Hernandez", Email = "james.hernandez@email.com", PhoneNumber = "223456787", Username = "jamesh", PasswordHash = "hash11", PasswordSalt = "salt11", Status = true, BirthDate = new DateTime(1995, 10, 23), Gender = "M", Address = "333 Oak St" },
            new User { UserId = 12, FirstName = "Robert", LastName = "Lopez", Email = "robert.lopez@email.com", PhoneNumber = "223456786", Username = "robertl", PasswordHash = "hash12", PasswordSalt = "salt12", Status = true, BirthDate = new DateTime(1991, 7, 17), Gender = "M", Address = "444 Pine St" },
            new User { UserId = 13, FirstName = "William", LastName = "Clark", Email = "william.clark@email.com", PhoneNumber = "223456785", Username = "williamc", PasswordHash = "hash13", PasswordSalt = "salt13", Status = true, BirthDate = new DateTime(1987, 5, 29), Gender = "M", Address = "555 Cedar St" },
            new User { UserId = 14, FirstName = "David", LastName = "Lewis", Email = "david.lewis@email.com", PhoneNumber = "223456784", Username = "davidl", PasswordHash = "hash14", PasswordSalt = "salt14", Status = true, BirthDate = new DateTime(1999, 8, 20), Gender = "M", Address = "666 Birch St" },
            new User { UserId = 15, FirstName = "Sophia", LastName = "Walker", Email = "sophia.walker@email.com", PhoneNumber = "223456783", Username = "sophiaw", PasswordHash = "hash15", PasswordSalt = "salt15", Status = true, BirthDate = new DateTime(1983, 1, 8), Gender = "F", Address = "777 Walnut St" },
            new User { UserId = 16, FirstName = "Charlotte", LastName = "Young", Email = "charlotte.young@email.com", PhoneNumber = "223456782", Username = "charlottey", PasswordHash = "hash16", PasswordSalt = "salt16", Status = true, BirthDate = new DateTime(1996, 3, 14), Gender = "F", Address = "888 Maple St" },
            new User { UserId = 17, FirstName = "Mia", LastName = "Hall", Email = "mia.hall@email.com", PhoneNumber = "223456781", Username = "miah", PasswordHash = "hash17", PasswordSalt = "salt17", Status = true, BirthDate = new DateTime(1992, 6, 11), Gender = "F", Address = "999 Oak St" }
        );

        // Seed Employees
        modelBuilder.Entity<Employee>().HasData(
            new Employee { EmployeeId = 1, HireDate = new DateTime(2022, 1, 15), JobTitle = "Psychologist", QualificationId = 1 },
            new Employee { EmployeeId = 2, HireDate = new DateTime(2021, 7, 22), JobTitle = "Pedagogue", QualificationId = 5 },
            new Employee { EmployeeId = 3, HireDate = new DateTime(2020, 5, 30), JobTitle = "Pedagogue", QualificationId = 4 },
            new Employee { EmployeeId = 4, HireDate = new DateTime(2019, 11, 10), JobTitle = "Speech Therapist", QualificationId = 2 },
            new Employee { EmployeeId = 5, HireDate = new DateTime(2010, 9, 12), JobTitle = "Speech Therapist", QualificationId = 2 },
            new Employee { EmployeeId = 6, HireDate = new DateTime(2021, 3, 20), JobTitle = "Special Educator", QualificationId = 3 },
            new Employee { EmployeeId = 7, HireDate = new DateTime(2022, 3, 20), JobTitle = "Psychologist", QualificationId = 1 }
        );

        // Seed Clients
        modelBuilder.Entity<Client>().HasData(
            new Client { ClientId = 9, EmploymentStatus = true },
            new Client { ClientId = 10, EmploymentStatus = false },
            new Client { ClientId = 11, EmploymentStatus = true },
            new Client { ClientId = 12, EmploymentStatus = false },
            new Client { ClientId = 13, EmploymentStatus = true },
            new Client { ClientId = 14, EmploymentStatus = false },
            new Client { ClientId = 15, EmploymentStatus = true },
            new Client { ClientId = 16, EmploymentStatus = false },
            new Client { ClientId = 17, EmploymentStatus = false }
        );

        // Seed Children
        modelBuilder.Entity<Child>().HasData(
            new Child { ChildId = 1, FirstName = "Liam", LastName = "Smith", BirthDate = new DateTime(2015, 2, 10), Gender = "M" },
            new Child { ChildId = 2, FirstName = "Noah", LastName = "Garcia", BirthDate = new DateTime(2017, 6, 22), Gender = "M" },
            new Child { ChildId = 3, FirstName = "Molly", LastName = "Johnson", BirthDate = new DateTime(2018, 4, 15), Gender = "F" },
            new Child { ChildId = 4, FirstName = "Oliver", LastName = "Brown", BirthDate = new DateTime(2016, 9, 30), Gender = "M" },
            new Child { ChildId = 5, FirstName = "Lucas", LastName = "Williams", BirthDate = new DateTime(2019, 11, 5), Gender = "M" },
            new Child { ChildId = 6, FirstName = "Mason", LastName = "Miller", BirthDate = new DateTime(2014, 12, 20), Gender = "M" },
            new Child { ChildId = 7, FirstName = "Ethan", LastName = "Davis", BirthDate = new DateTime(2015, 7, 8), Gender = "M" },
            new Child { ChildId = 8, FirstName = "James", LastName = "Wilson", BirthDate = new DateTime(2018, 3, 14), Gender = "M" },
            new Child { ChildId = 9, FirstName = "Benjamin", LastName = "Anderson", BirthDate = new DateTime(2017, 8, 26), Gender = "M" },
            new Child { ChildId = 10, FirstName = "William", LastName = "Martinez", BirthDate = new DateTime(2020, 2, 5), Gender = "M" },
            new Child { ChildId = 11, FirstName = "Charlotte", LastName = "Hernandez", BirthDate = new DateTime(2015, 9, 17), Gender = "F" },
            new Child { ChildId = 12, FirstName = "Amelia", LastName = "Lopez", BirthDate = new DateTime(2017, 6, 2), Gender = "F" },
            new Child { ChildId = 13, FirstName = "Sophia", LastName = "Clark", BirthDate = new DateTime(2016, 10, 29), Gender = "F" },
            new Child { ChildId = 14, FirstName = "Mia", LastName = "Lewis", BirthDate = new DateTime(2019, 4, 23), Gender = "F" },
            new Child { ChildId = 15, FirstName = "Isabella", LastName = "Walker", BirthDate = new DateTime(2021, 1, 15), Gender = "F" }
        );

        // Seed ClientsChildren
        modelBuilder.Entity<ClientsChild>().HasData(
            new ClientsChild { ClientId = 9, ChildId = 1 },
            new ClientsChild { ClientId = 10, ChildId = 2 },
            new ClientsChild { ClientId = 11, ChildId = 3 },
            new ClientsChild { ClientId = 12, ChildId = 4 },
            new ClientsChild { ClientId = 13, ChildId = 5 },
            new ClientsChild { ClientId = 14, ChildId = 6 },
            new ClientsChild { ClientId = 15, ChildId = 7 },
            new ClientsChild { ClientId = 16, ChildId = 8 },
            new ClientsChild { ClientId = 17, ChildId = 9 }
        );

        // Seed ServiceTypes (you'll need to add this based on your schema)
        modelBuilder.Entity<ServiceType>().HasData(
            new ServiceType { ServiceTypeId = 1, Name = "Diagnostic Services", Description = "Services for diagnosis and assessment" },
            new ServiceType { ServiceTypeId = 2, Name = "Therapy Services", Description = "Therapeutic intervention services" },
            new ServiceType { ServiceTypeId = 3, Name = "Educational Services", Description = "Educational support services" }
        );

        // Seed Services
        modelBuilder.Entity<Service>().HasData(
            new Service { ServiceId = 1, Name = "Observation Protocol for Autism Diagnosis - ADOS-2", Description = "Standardized protocol for diagnosing autism spectrum disorders.", Price = 160.00m,  ServiceTypeId = 1 },
            new Service { ServiceId = 2, Name = "Speech Therapy Observation", Description = "Assessment of speech and language abilities.", Price = 70.00m,  ServiceTypeId = 1 },
            new Service { ServiceId = 3, Name = "Special Education Observation", Description = "Assessment of specific developmental and learning difficulties.", Price = 70.00m, ServiceTypeId = 1 },
            new Service { ServiceId = 4, Name = "Psychological Observation and Assessment", Description = "Evaluation of cognitive and emotional abilities.", Price = 80.00m,ServiceTypeId = 1 },
            new Service { ServiceId = 5, Name = "Educational Observation", Description = "Analysis of educational needs and potential.", Price = 65.00m,  ServiceTypeId = 3 },
            new Service { ServiceId = 6, Name = "Speech Therapy Treatment", Description = "Individual treatment to improve speech and language abilities.", Price = 40.00m, ServiceTypeId = 2 },
            new Service { ServiceId = 7, Name = "Follow-up Speech Therapy Session", Description = "Monitoring progress after previous treatment.", Price = 40.00m, ServiceTypeId = 2 }
        );

        // Seed Workshops
        modelBuilder.Entity<Workshop>().HasData(
            new Workshop { WorkshopId = 1, Name = "Supporting Children with Autism", Description = "A comprehensive workshop for parents on understanding and supporting children with autism.", Status = "Finished", Date = new DateTime(2024, 10, 10), Price = 200.00m, WorkshopType = "Workshop for Parents", Notes = "Bring a notebook." },
            new Workshop { WorkshopId = 2, Name = "Social Skills Development for Children", Description = "Interactive activities designed to improve social skills in children with disabilities.", Status = "Finished", Date = new DateTime(2024, 11, 5), Price = 180.00m, WorkshopType = "Workshop for Children", Notes = "Materials will be provided." },
            new Workshop { WorkshopId = 3, Name = "Parenting Strategies for Children with Special Needs", Description = "Guidance for parents on effective strategies for children with special needs.", Status = "Finished", Date = new DateTime(2024, 12, 1), Price = 220.00m, WorkshopType = "Workshop for Parents", Notes = "Refreshments included." }
        );

        // Seed Reviews
        modelBuilder.Entity<Review>().HasData(
            new Review { ReviewId = 1, UserId = 9, Title = "Excellent Workshop", Content = "The workshop was incredibly informative and engaging. The instructor was very supportive and answered all questions thoroughly.", PublishDate = new DateTime(2024, 9, 1), Stars = 5 },
            new Review { ReviewId = 2, UserId = 10, Title = "Very Helpful", Content = "I found the session very helpful, especially the practical exercises. It really helped me understand how to support my child better.", PublishDate = new DateTime(2024, 9, 5), EmployeeId = 2, Stars = 4 },
            new Review { ReviewId = 3, UserId = 11, Title = "Good Experience", Content = "The staff was friendly and the workshop was well-structured. I would recommend this to other parents.", PublishDate = new DateTime(2024, 9, 10), Stars = 4 }
        );

        // Seed Participants
        modelBuilder.Entity<Participant>().HasData(
            new Participant { ParticipantId = 1, UserId = 9, WorkshopId = 1, AttendanceStatusId = 1, RegistrationDate = new DateTime(2024, 2, 1) },
            new Participant { ParticipantId = 2, UserId = 8, WorkshopId = 2, AttendanceStatusId = 1, RegistrationDate = new DateTime(2024, 2, 5) },
            new Participant { ParticipantId = 3, UserId = 10, WorkshopId = 3, AttendanceStatusId = 1, RegistrationDate = new DateTime(2024, 2, 10) },
            new Participant { ParticipantId = 4, UserId = 11, WorkshopId = 1, AttendanceStatusId = 1, RegistrationDate = new DateTime(2024, 2, 15) },
            new Participant { ParticipantId = 5, UserId = 12, WorkshopId = 2, AttendanceStatusId = 1, RegistrationDate = new DateTime(2024, 2, 20) }
        );

        // Seed EmployeeAvailability
        modelBuilder.Entity<EmployeeAvailability>().HasData(
            new EmployeeAvailability { EmployeeAvailabilityId = 1, EmployeeId = 1, ServiceId = 1, DayOfWeek = "Monday", StartTime = "09:00", EndTime = "17:00"},
            new EmployeeAvailability { EmployeeAvailabilityId = 2, EmployeeId = 2, ServiceId = 2, DayOfWeek = "Monday", StartTime = "08:00", EndTime = "16:00"},
            new EmployeeAvailability { EmployeeAvailabilityId = 3, EmployeeId = 3, ServiceId = 3, DayOfWeek = "Tuesday", StartTime = "10:00", EndTime = "18:00"},
            new EmployeeAvailability { EmployeeAvailabilityId = 4, EmployeeId = 4, ServiceId = null, DayOfWeek = "Wednesday", StartTime = "09:00", EndTime = "12:00"},
            new EmployeeAvailability { EmployeeAvailabilityId = 5, EmployeeId = 5, ServiceId = 1, DayOfWeek = "Thursday", StartTime = "08:30", EndTime = "17:30"},
            new EmployeeAvailability { EmployeeAvailabilityId = 6, EmployeeId = 6, ServiceId = 2, DayOfWeek = "Friday", StartTime = "09:00", EndTime = "15:00"},
            new EmployeeAvailability { EmployeeAvailabilityId = 7, EmployeeId = 7, ServiceId = 3, DayOfWeek = "Saturday", StartTime = "10:00", EndTime = "14:00"}
        );

        // Note: Appointments seed data requires ClientId and ChildId which come from Users
        // Since we're seeding based on composite keys, we use the actual IDs
        modelBuilder.Entity<Appointment>().HasData(
            new Appointment { AppointmentId = 1, ClientId = 9, ChildId = 1, EmployeeAvailabilityId = 1, AppointmentType = "Consultation", AttendanceStatusId = 1, Date = new DateTime(2025, 2, 1), Description = "Initial consultation regarding project progress", Note = "No special notes" },
            new Appointment { AppointmentId = 2, ClientId = 10, ChildId = 2, EmployeeAvailabilityId = 2, AppointmentType = "Follow-up", AttendanceStatusId = 2, Date = new DateTime(2025, 2, 3), Description = "Follow-up on previous meeting regarding design feedback", Note = "Absent due to illness" },
            new Appointment { AppointmentId = 3, ClientId = 11, ChildId = 3, EmployeeAvailabilityId = 3, AppointmentType = "Interview", AttendanceStatusId = 3, Date = new DateTime(2025, 2, 5), Description = "Job interview for Software Engineer position", Note = "Late arrival due to traffic" },
            new Appointment { AppointmentId = 4, ClientId = 12, ChildId = 4, EmployeeAvailabilityId = 4, AppointmentType = "Consultation", AttendanceStatusId = 1, Date = new DateTime(2025, 2, 7), Description = "Consultation on marketing strategy", Note = "On time, very productive" },
            new Appointment { AppointmentId = 5, ClientId = 13, ChildId = 5, EmployeeAvailabilityId = 5, AppointmentType = "Training", AttendanceStatusId = 4, Date = new DateTime(2025, 2, 10), Description = "Training session for new software", Note = "Excused absence, rescheduled to next week" },
            new Appointment { AppointmentId = 6, ClientId = 14, ChildId = 6, EmployeeAvailabilityId = 6, AppointmentType = "Consultation", AttendanceStatusId = 1, Date = new DateTime(2025, 2, 12), Description = "Meeting to discuss the upcoming product launch", Note = "All points covered" },
            new Appointment { AppointmentId = 7, ClientId = 15, ChildId = 7, EmployeeAvailabilityId = 7, AppointmentType = "Follow-up", AttendanceStatusId = 2, Date = new DateTime(2025, 2, 15), Description = "Follow-up meeting on last weeks workshop", Note = "Absent due to vacation" }
        );
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
