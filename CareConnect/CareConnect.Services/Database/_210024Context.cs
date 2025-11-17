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

    //    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    //#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
    //        => optionsBuilder.UseSqlServer("Data Source=DESKTOP-BRFTFE0\\MSSQLSERVER9;Initial Catalog=_210024;Trusted_Connection=True;User ID=sa;Password=QWEasd123!;MultipleActiveResultSets=true; TrustServerCertificate=true"); 
    //        //.LogTo(Console.WriteLine).EnableSensitiveDataLogging();


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
                .OnDelete(DeleteBehavior.Restrict)
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

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
