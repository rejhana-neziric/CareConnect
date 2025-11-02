using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace CareConnect.Services.Migrations
{
    /// <inheritdoc />
    public partial class RemovedUnusedClasses : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Payments_PaymentPurposes_PaymentPurposeId",
                table: "Payments");

            migrationBuilder.DropForeignKey(
                name: "FK_Payments_PaymentStatus_PaymentStatusId",
                table: "Payments");

            migrationBuilder.DropTable(
                name: "ChildrenDiagnoses");

            migrationBuilder.DropTable(
                name: "EmployeePayHistory");

            migrationBuilder.DropTable(
                name: "Members");

            migrationBuilder.DropTable(
                name: "PaymentPurposes");

            migrationBuilder.DropTable(
                name: "PaymentStatus");

            migrationBuilder.DropTable(
                name: "Sessions");

            migrationBuilder.DropTable(
                name: "Diagnoses");

            migrationBuilder.DropTable(
                name: "Instructors");

            migrationBuilder.DropIndex(
                name: "IX_Payments_PaymentPurposeId",
                table: "Payments");

            migrationBuilder.DropIndex(
                name: "IX_Payments_PaymentStatusId",
                table: "Payments");

            migrationBuilder.DropColumn(
                name: "PaymentPurposeId",
                table: "Payments");

            migrationBuilder.DropColumn(
                name: "PaymentStatusId",
                table: "Payments");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "PaymentPurposeId",
                table: "Payments",
                type: "int",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "PaymentStatusId",
                table: "Payments",
                type: "int",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "Diagnoses",
                columns: table => new
                {
                    DiagnosisID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Description = table.Column<string>(type: "text", nullable: true),
                    ModifiedDate = table.Column<DateTime>(type: "datetime", nullable: false, defaultValueSql: "(getdate())"),
                    Name = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Diagnose__0C54CB93F48849F6", x => x.DiagnosisID);
                });

            migrationBuilder.CreateTable(
                name: "EmployeePayHistory",
                columns: table => new
                {
                    EmployeeID = table.Column<int>(type: "int", nullable: false),
                    RateChangeDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ModifiedDate = table.Column<DateTime>(type: "datetime", nullable: false, defaultValueSql: "(getdate())"),
                    Rate = table.Column<decimal>(type: "decimal(18,2)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_EmployeePayHistory", x => new { x.EmployeeID, x.RateChangeDate });
                    table.ForeignKey(
                        name: "FK_EmployeePayHistory_Users",
                        column: x => x.EmployeeID,
                        principalTable: "Employees",
                        principalColumn: "EmployeeID");
                });

            migrationBuilder.CreateTable(
                name: "Instructors",
                columns: table => new
                {
                    InstructorID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Email = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true),
                    FirstName = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    InstitutionName = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: true),
                    LastName = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    ModifiedDate = table.Column<DateTime>(type: "datetime", nullable: false, defaultValueSql: "(getdate())"),
                    PhoneNumber = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: true),
                    ProfessionalTitle = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Instruct__9D010B7B6EBA19E2", x => x.InstructorID);
                });

            migrationBuilder.CreateTable(
                name: "Members",
                columns: table => new
                {
                    MemberID = table.Column<int>(type: "int", nullable: false),
                    JoinedDate = table.Column<DateTime>(type: "datetime", nullable: false),
                    LeftDate = table.Column<DateTime>(type: "datetime", nullable: true),
                    ModifiedDate = table.Column<DateTime>(type: "datetime", nullable: false, defaultValueSql: "(getdate())")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Members", x => new { x.MemberID, x.JoinedDate });
                    table.ForeignKey(
                        name: "FK_Members_Clients",
                        column: x => x.MemberID,
                        principalTable: "Clients",
                        principalColumn: "ClientID");
                });

            migrationBuilder.CreateTable(
                name: "PaymentPurposes",
                columns: table => new
                {
                    PaymentPurposeID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ModifiedDate = table.Column<DateTime>(type: "datetime", nullable: false, defaultValueSql: "(getdate())"),
                    Name = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__PaymentP__847171664C3B3572", x => x.PaymentPurposeID);
                });

            migrationBuilder.CreateTable(
                name: "PaymentStatus",
                columns: table => new
                {
                    PaymentStatusID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ModifiedDate = table.Column<DateTime>(type: "datetime", nullable: false, defaultValueSql: "(getdate())"),
                    Name = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__PaymentS__34F8AC1F8C1BD45C", x => x.PaymentStatusID);
                });

            migrationBuilder.CreateTable(
                name: "ChildrenDiagnoses",
                columns: table => new
                {
                    ChildID = table.Column<int>(type: "int", nullable: false),
                    DiagnosisID = table.Column<int>(type: "int", nullable: false),
                    DiagnosisDate = table.Column<DateTime>(type: "datetime", nullable: true),
                    ModifiedDate = table.Column<DateTime>(type: "datetime", nullable: false, defaultValueSql: "(getdate())"),
                    Notes = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ChildrenDiagnoses", x => new { x.ChildID, x.DiagnosisID });
                    table.ForeignKey(
                        name: "FK_ChildrenDiagnoses_Children",
                        column: x => x.ChildID,
                        principalTable: "Children",
                        principalColumn: "ChildID");
                    table.ForeignKey(
                        name: "FK_ChildrenDiagnoses_Diagnoses",
                        column: x => x.DiagnosisID,
                        principalTable: "Diagnoses",
                        principalColumn: "DiagnosisID");
                });

            migrationBuilder.CreateTable(
                name: "Sessions",
                columns: table => new
                {
                    SessionID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    EmployeeID = table.Column<int>(type: "int", nullable: true),
                    InstructorID = table.Column<int>(type: "int", nullable: true),
                    WorkshopID = table.Column<int>(type: "int", nullable: false),
                    Date = table.Column<DateTime>(type: "datetime", nullable: false),
                    Description = table.Column<string>(type: "text", nullable: false),
                    EndTime = table.Column<DateTime>(type: "datetime", nullable: false),
                    ModifiedDate = table.Column<DateTime>(type: "datetime", nullable: false, defaultValueSql: "(getdate())"),
                    Name = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    StartTime = table.Column<DateTime>(type: "datetime", nullable: false),
                    Status = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Sessions__C9F49270A1B7D6A1", x => x.SessionID);
                    table.ForeignKey(
                        name: "FK_Sessions_Employees",
                        column: x => x.EmployeeID,
                        principalTable: "Employees",
                        principalColumn: "EmployeeID");
                    table.ForeignKey(
                        name: "FK_Sessions_Instructors",
                        column: x => x.InstructorID,
                        principalTable: "Instructors",
                        principalColumn: "InstructorID");
                    table.ForeignKey(
                        name: "FK_Sessions_Workshops_WorkshopID",
                        column: x => x.WorkshopID,
                        principalTable: "Workshops",
                        principalColumn: "WorkshopID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Payments_PaymentPurposeId",
                table: "Payments",
                column: "PaymentPurposeId");

            migrationBuilder.CreateIndex(
                name: "IX_Payments_PaymentStatusId",
                table: "Payments",
                column: "PaymentStatusId");

            migrationBuilder.CreateIndex(
                name: "IX_ChildrenDiagnoses_DiagnosisID",
                table: "ChildrenDiagnoses",
                column: "DiagnosisID");

            migrationBuilder.CreateIndex(
                name: "IX_Sessions_EmployeeID",
                table: "Sessions",
                column: "EmployeeID");

            migrationBuilder.CreateIndex(
                name: "IX_Sessions_InstructorID",
                table: "Sessions",
                column: "InstructorID");

            migrationBuilder.CreateIndex(
                name: "IX_Sessions_WorkshopID",
                table: "Sessions",
                column: "WorkshopID");

            migrationBuilder.AddForeignKey(
                name: "FK_Payments_PaymentPurposes_PaymentPurposeId",
                table: "Payments",
                column: "PaymentPurposeId",
                principalTable: "PaymentPurposes",
                principalColumn: "PaymentPurposeID");

            migrationBuilder.AddForeignKey(
                name: "FK_Payments_PaymentStatus_PaymentStatusId",
                table: "Payments",
                column: "PaymentStatusId",
                principalTable: "PaymentStatus",
                principalColumn: "PaymentStatusID");
        }
    }
}
