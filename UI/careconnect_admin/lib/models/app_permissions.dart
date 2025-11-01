class AppPermissions {
  // Appointment
  static const appointmentGet = 'Permissions.Appointment.Get';
  static const appointmentGetById = 'Permissions.Appointment.GetById';
  static const appointmentInsert = 'Permissions.Appointment.Insert';
  static const appointmentUpdate = 'Permissions.Appointment.Update';
  static const appointmentDelete = 'Permissions.Appointment.Delete';
  static const appointmentCancel = 'Permissions.Appointment.Cancel';
  static const appointmentConfirm = 'Permissions.Appointment.Confirm';
  static const appointmentStart = 'Permissions.Appointment.Start';
  static const appointmentComplete = 'Permissions.Appointment.Complete';
  static const appointmentReschedule = 'Permissions.Appointment.Reschedule';
  static const appointmentRescheduleRequested =
      'Permissions.Appointment.RescheduleRequested';
  static const appointmentReschedulePendingApproval =
      'Permissions.Appointment.ReschedulePendingApproval';
  static const appointmentAllowedActions =
      'Permissions.Appointment.AllowedActions';
  static const appointmentGetAppointmentTypes =
      'Permissions.Appointment.GetAppointmentTypes';
  static const appointmentView = 'Permissions.Appointment.View';

  // Child
  static const childGet = 'Permissions.Child.Get';
  static const childGetById = 'Permissions.Child.GetById';
  static const childInsert = 'Permissions.Child.Insert';
  static const childUpdate = 'Permissions.Child.Update';
  static const childDelete = 'Permissions.Child.Delete';

  // ChildrenDiagnosis
  static const childrenDiagnosisGet = 'Permissions.ChildrenDiagnosis.Get';
  static const childrenDiagnosisGetById =
      'Permissions.ChildrenDiagnosis.GetById';
  static const childrenDiagnosisInsert = 'Permissions.ChildrenDiagnosis.Insert';
  static const childrenDiagnosisUpdate = 'Permissions.ChildrenDiagnosis.Update';
  static const childrenDiagnosisDelete = 'Permissions.ChildrenDiagnosis.Delete';

  // ClientsChild
  static const clientsChildGet = 'Permissions.ClientsChild.Get';
  static const clientsChildGetById = 'Permissions.ClientsChild.GetById';
  static const clientsChildInsert = 'Permissions.ClientsChild.Insert';
  static const clientsChildUpdate = 'Permissions.ClientsChild.Update';
  static const clientsChildDelete = 'Permissions.ClientsChild.Delete';
  static const clientsChildGetStatistics =
      'Permissions.ClientsChild.GetStatistics';
  static const clientsChildGetClientAndChildByIds =
      'Permissions.ClientsChild.GetClientAndChildByIds';
  static const clientsChildGetAppointment =
      'Permissions.ClientsChild.GetAppointment';

  // Client
  static const clientGet = 'Permissions.Client.Get';
  static const clientGetById = 'Permissions.Client.GetById';
  static const clientInsert = 'Permissions.Client.Insert';
  static const clientUpdate = 'Permissions.Client.Update';
  static const clientDelete = 'Permissions.Client.Delete';
  static const clientGetChildren = 'Permissions.Client.GetChildren';
  static const clientAddChildren = 'Permissions.Client.AddChildren';
  static const clientRemoveChildren = 'Permissions.Client.RemoveChildren';
  static const clientView = 'Permissions.Client.View';

  // EmployeeAvailability
  static const employeeAvailabilityGet = 'Permissions.EmployeeAvailability.Get';
  static const employeeAvailabilityGetById =
      'Permissions.EmployeeAvailability.GetById';
  static const employeeAvailabilityInsert =
      'Permissions.EmployeeAvailability.Insert';
  static const employeeAvailabilityUpdate =
      'Permissions.EmployeeAvailability.Update';
  static const employeeAvailabilityDelete =
      'Permissions.EmployeeAvailability.Delete';

  // Employee
  static const employeeGet = 'Permissions.Employee.Get';
  static const employeeGetBasic = 'Permissions.Employee.GetBasic';
  static const employeeGetById = 'Permissions.Employee.GetById';
  static const employeeInsert = 'Permissions.Employee.Insert';
  static const employeeUpdate = 'Permissions.Employee.Update';
  static const employeeDelete = 'Permissions.Employee.Delete';
  static const employeeGetStatistics = 'Permissions.Employee.GetStatistics';
  static const employeeGetAvailability =
      'Permissions.Employee.GetEmployeeAvailability';
  static const employeeCreateAvailability =
      'Permissions.Employee.CreateEmployeeAvailability';
  static const employeeUpdateAvailability =
      'Permissions.Employee.UpdateEmployeeAvailability';
  static const employeeView = 'Permissions.Employee.View';
  static const employeeViewEmployeeAvailability =
      'Permissions.Employee.ViewEmployeeAvailability';

  // EmployeePayHistory
  static const employeePayHistoryGet = 'Permissions.EmployeePayHistory.Get';
  static const employeePayHistoryGetById =
      'Permissions.EmployeePayHistory.GetById';
  static const employeePayHistoryInsert =
      'Permissions.EmployeePayHistory.Insert';
  static const employeePayHistoryUpdate =
      'Permissions.EmployeePayHistory.Update';
  static const employeePayHistoryDelete =
      'Permissions.EmployeePayHistory.Delete';

  // Instructor
  static const instructorGet = 'Permissions.Instructor.Get';
  static const instructorGetById = 'Permissions.Instructor.GetById';
  static const instructorInsert = 'Permissions.Instructor.Insert';
  static const instructorUpdate = 'Permissions.Instructor.Update';
  static const instructorDelete = 'Permissions.Instructor.Delete';

  // Member
  static const memberGet = 'Permissions.Member.Get';
  static const memberGetById = 'Permissions.Member.GetById';
  static const memberInsert = 'Permissions.Member.Insert';
  static const memberUpdate = 'Permissions.Member.Update';
  static const memberDelete = 'Permissions.Member.Delete';

  // Participant
  static const participantGet = 'Permissions.Participant.Get';
  static const participantGetById = 'Permissions.Participant.GetById';
  static const participantInsert = 'Permissions.Participant.Insert';
  static const participantUpdate = 'Permissions.Participant.Update';
  static const participantDelete = 'Permissions.Participant.Delete';

  // Payment
  static const paymentGet = 'Permissions.Payment.Get';
  static const paymentGetById = 'Permissions.Payment.GetById';
  static const paymentInsert = 'Permissions.Payment.Insert';
  static const paymentUpdate = 'Permissions.Payment.Update';
  static const paymentDelete = 'Permissions.Payment.Delete';
  static const paymentCreatePaymentIntent =
      'Permissions.Payment.CreatePaymentIntent';
  static const paymentVerifyPayment = 'Permissions.Payment.VerifyPayment';

  // Report
  static const reportGetReportData = 'Permissions.Report.GetReportData';
  static const reportGetKPI = 'Permissions.Report.GetKPI';
  static const reportGetInsights = 'Permissions.Report.GetInsights';
  static const reportView = 'Permissions.Report.View';
  static const reportExport = 'Permissions.Report.Export';

  // Review
  static const reviewGet = 'Permissions.Review.Get';
  static const reviewGetById = 'Permissions.Review.GetById';
  static const reviewInsert = 'Permissions.Review.Insert';
  static const reviewUpdate = 'Permissions.Review.Update';
  static const reviewDelete = 'Permissions.Review.Delete';
  static const reviewChangeVisibility = 'Permissions.Review.ChangeVisibility';
  static const reviewGetAverage = 'Permissions.Review.GetAverage';
  static const reviewView = 'Permissions.Review.View';
  static const reviewViewAll = 'Permissions.Review.ViewAll';
  static const reviewViewOwn = 'Permissions.Review.ViewOwn';

  // Role
  static const roleGet = 'Permissions.Role.Get';
  static const roleGetById = 'Permissions.Role.GetById';
  static const roleInsert = 'Permissions.Role.Insert';
  static const roleUpdate = 'Permissions.Role.Update';
  static const roleDelete = 'Permissions.Role.Delete';
  static const roleAssignPermission = 'Permissions.Role.AssignPermission';

  // RolePermissions
  static const rolePermissionsGetAllRoles =
      'Permissions.RolePermissions.GetAllRoles';
  static const rolePermissionsGetAllPermissions =
      'Permissions.RolePermissions.GetAllPermissions';
  static const rolePermissionsGetGroupedPermissions =
      'Permissions.RolePermissions.GetGroupedPermissions';
  static const rolePermissionsGetRolePermissions =
      'Permissions.RolePermissions.GetRolePermissions';
  static const rolePermissionsUpdateRolePermissions =
      'Permissions.RolePermissions.UpdateRolePermissions';
  static const rolePermissionsView = 'Permissions.RolePermissions.View';

  // UsersRole
  static const usersRoleGet = 'Permissions.UsersRole.Get';
  static const usersRoleGetById = 'Permissions.UsersRole.GetById';
  static const usersRoleInsert = 'Permissions.UsersRole.Insert';
  static const usersRoleUpdate = 'Permissions.UsersRole.Update';
  static const usersRoleDelete = 'Permissions.UsersRole.Delete';

  // Service
  static const serviceGet = 'Permissions.Service.Get';
  static const serviceGetById = 'Permissions.Service.GetById';
  static const serviceInsert = 'Permissions.Service.Insert';
  static const serviceUpdate = 'Permissions.Service.Update';
  static const serviceDelete = 'Permissions.Service.Delete';
  static const serviceGetStatistics = 'Permissions.Service.GetStatistics';
  static const serviceGetEmployeesForService =
      'Permissions.Service.GetEmployeesForService';
  static const serviceView = 'Permissions.Service.View';

  // ServiceType
  static const serviceTypeGet = 'Permissions.ServiceType.Get';
  static const serviceTypeGetById = 'Permissions.ServiceType.GetById';
  static const serviceTypeInsert = 'Permissions.ServiceType.Insert';
  static const serviceTypeUpdate = 'Permissions.ServiceType.Update';
  static const serviceTypeDelete = 'Permissions.ServiceType.Delete';

  // Session
  static const sessionGet = 'Permissions.Session.Get';
  static const sessionGetById = 'Permissions.Session.GetById';
  static const sessionInsert = 'Permissions.Session.Insert';
  static const sessionUpdate = 'Permissions.Session.Update';
  static const sessionDelete = 'Permissions.Session.Delete';

  // User
  static const userLogin = 'Permissions.User.Login';
  static const userGetPermission = 'Permissions.User.GetPermission';
  static const userGet = 'Permissions.User.Get';
  static const userGetById = 'Permissions.User.GetById';
  static const userInsert = 'Permissions.User.Insert';
  static const userUpdate = 'Permissions.User.Update';
  static const userDelete = 'Permissions.User.Delete';
  static const userChangePassword = 'Permissions.User.ChangePassword';
  static const userGetRolesForUser = 'Permissions.User.GetRolesForUser';
  static const userAddRoleToUser = 'Permissions.User.AddRoleToUser';
  static const userRemoveRoleFromUser = 'Permissions.User.RemoveRoleFromUser';

  // Workshop
  static const workshopGet = 'Permissions.Workshop.Get';
  static const workshopGetById = 'Permissions.Workshop.GetById';
  static const workshopInsert = 'Permissions.Workshop.Insert';
  static const workshopUpdate = 'Permissions.Workshop.Update';
  static const workshopDelete = 'Permissions.Workshop.Delete';
  static const workshopPublish = 'Permissions.Workshop.Publish';
  static const workshopCancel = 'Permissions.Workshop.Cancel';
  static const workshopClose = 'Permissions.Workshop.Close';
  static const workshopAllowedActions = 'Permissions.Workshop.AllowedActions';
  static const workshopGetStatistics = 'Permissions.Workshop.GetStatistics';
  static const workshopEnroll = 'Permissions.Workshop.Enroll';
  static const workshopGetEnrollmentStatus =
      'Permissions.Workshop.GetWorkshopEnrollmentStatus';
  static const workshopTrainModel = 'Permissions.Workshop.TrainModel';
  static const workshopPredictForNewWorkshop =
      'Permissions.Workshop.PredictForNewWorkshop';
  static const workshopView = 'Permissions.Workshop.View';
}
