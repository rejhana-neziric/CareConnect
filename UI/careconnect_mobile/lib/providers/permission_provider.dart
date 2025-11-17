import 'package:careconnect_mobile/models/app_permissions.dart';
import 'package:careconnect_mobile/providers/auth_provider.dart';

class PermissionProvider {
  final AuthProvider _authProvider;

  PermissionProvider(this._authProvider);

  // Employee Permissions
  bool canViewEmployeeScreen() {
    return hasPermission(AppPermissions.employeeView);
  }

  bool canEditEmployee() {
    return hasPermission(AppPermissions.employeeUpdate);
  }

  bool canInsertEmployee() {
    return hasPermission(AppPermissions.employeeInsert);
  }

  bool canDeleteEmployee() {
    return hasPermission(AppPermissions.employeeDelete);
  }

  // view employee statistics on employee screen
  bool canViewEmployeeStatistics() {
    return hasPermission(AppPermissions.employeeGetStatistics);
  }

  // view employee details on employee details screen
  bool canGetByIdEmployee() {
    return hasPermission(AppPermissions.employeeGetById);
  }

  // view employee availability screen
  bool canViewEmployeeAvailabilityScreen() {
    return hasPermission(AppPermissions.employeeViewEmployeeAvailability);
  }

  bool canManageEmployeeAvailability() {
    return hasAnyPermission([
      AppPermissions.employeeGetAvailability,
      AppPermissions.employeeCreateAvailability,
      AppPermissions.employeeUpdateAvailability,
    ]);
  }

  bool canInsertEmployeeAvailability() {
    return hasAllPermissions([
      AppPermissions.employeeCreateAvailability,
      AppPermissions.employeeUpdateAvailability,
    ]);
  }

  bool canUpdateEmployeeAvailability() {
    return hasPermission(AppPermissions.employeeUpdateAvailability);
  }

  // Employee Availability

  // can view all other employees on employee availability screen, needs to permision to get employees to see theirs availabilites
  bool canViewAllEmployeesAvailability() {
    return hasPermission(AppPermissions.employeeAvailabilityGet);
  }

  // can view own availablity on employee availability screen
  bool canViewOwnAvailability() {
    return hasPermission(AppPermissions.employeeAvailabilityGetById);
  }

  // to view availabilites on employee profile screen
  bool canViewEmployeeAvailabilities() {
    return hasPermission(AppPermissions.employeeAvailabilityGet);
  }

  bool canScheduleAppointment() {
    return hasAllPermissions([
      AppPermissions.appointmentInsert,
      AppPermissions.employeeGetAvailability,
      AppPermissions.appointmentGetAppointmentTypes,
      AppPermissions.clientGetChildren,
      AppPermissions.paymentCreatePaymentIntent,
      AppPermissions.paymentVerifyPayment,
    ]);
  }

  bool canDeactivateAccount() {
    return hasPermission(AppPermissions.clientDelete);
  }

  // Appointment Permissions
  bool canViewAppointmentScreen() {
    return hasPermission(AppPermissions.appointmentView);
  }

  bool canGetAppointments() {
    return hasPermission(AppPermissions.appointmentGet);
  }

  bool canInsertAppointment() {
    return hasPermission(AppPermissions.appointmentInsert);
  }

  bool canEditAppointment() {
    return hasPermission(AppPermissions.appointmentUpdate);
  }

  bool canDeleteAppointment() {
    return hasPermission(AppPermissions.appointmentDelete);
  }

  bool canCancelAppointment() {
    return hasPermission(AppPermissions.appointmentCancel);
  }

  bool canGetByIdAppointment() {
    return hasPermission(AppPermissions.appointmentGetById);
  }

  // check
  bool canRescheduleAppointment() {
    return hasAllPermissions([
      AppPermissions.appointmentReschedulePendingApproval,
      AppPermissions.employeeGetAvailability,
      AppPermissions.appointmentGetAppointmentTypes,
      AppPermissions.clientGetChildren,
    ]);
  }

  bool canManageAppointment() {
    return hasAllPermissions([
      AppPermissions.appointmentStart,
      AppPermissions.appointmentComplete,
    ]);
  }

  bool canConfirmAppointment() {
    return hasPermission(AppPermissions.appointmentConfirm);
  }

  bool canStartAppointment() {
    return hasPermission(AppPermissions.appointmentStart);
  }

  bool canCompleteAppointment() {
    return hasPermission(AppPermissions.appointmentComplete);
  }

  bool canGetAppointmentTypes() {
    return hasPermission(AppPermissions.appointmentGetAppointmentTypes);
  }

  // Workshop Permissions
  bool canViewWorkshopScreen() {
    return hasPermission(AppPermissions.workshopView);
  }

  bool canViewWorkshopStatistics() {
    return hasPermission(AppPermissions.workshopGetStatistics);
  }

  bool canInsertWorkshop() {
    return hasPermission(AppPermissions.workshopInsert);
  }

  bool canGetByIdWorkshop() {
    return hasPermission(AppPermissions.workshopGetById);
  }

  bool canPublishWorkshop() {
    return hasPermission(AppPermissions.workshopPublish);
  }

  bool canCloseWorkshop() {
    return hasPermission(AppPermissions.workshopClose);
  }

  bool canCancelWorkshop() {
    return hasPermission(AppPermissions.workshopCancel);
  }

  bool canGetEnrolledChildren() {
    return hasPermission(AppPermissions.participantGet);
  }

  bool canDeleteWorkshop() {
    return hasPermission(AppPermissions.workshopDelete);
  }

  bool canEditWorkshop() {
    return hasAnyPermission([
      AppPermissions.workshopUpdate,
      AppPermissions.workshopPublish,
      AppPermissions.workshopCancel,
      AppPermissions.workshopClose,
    ]);
  }

  bool canEnrollWorkshop() {
    return hasAllPermissions([
      AppPermissions.workshopEnroll,
      AppPermissions.paymentCreatePaymentIntent,
      AppPermissions.paymentVerifyPayment,
      AppPermissions.clientGetById,
    ]);
  }

  bool canViewWorkshopEnrollmentStatus() {
    return hasPermission(AppPermissions.workshopGetEnrollmentStatus);
  }

  // this could be deleted because on front user does not have option to train model, this call is for separate api calls
  bool canTrainWorkshopModel() {
    return hasPermission(AppPermissions.workshopTrainModel);
  }

  // predict on workshop details screen
  bool canPredictForNewWorkshop() {
    return hasPermission(AppPermissions.workshopPredictForNewWorkshop);
  }

  // Attendance Status

  // Client Permissions
  bool canViewClientScreen() {
    return hasPermission(AppPermissions.clientView);
  }

  bool canEditClient() {
    return hasPermission(AppPermissions.clientUpdate);
  }

  bool canInsertClient() {
    return hasPermission(AppPermissions.clientInsert);
  }

  bool canDeleteClient() {
    return hasPermission(AppPermissions.clientDelete);
  }

  bool canManageClientChildren() {
    return hasAnyPermission([
      AppPermissions.clientAddChildren,
      AppPermissions.clientRemoveChildren,
      AppPermissions.clientGetChildren,
    ]);
  }

  bool canViewClientsChildStatistic() {
    return hasPermission(AppPermissions.clientsChildGetStatistics);
  }

  // view all details on clients details screen
  bool canViewClientDetails() {
    return hasAnyPermission([AppPermissions.clientGetById]);
  }

  // view cleints children on client details screen and get children on workshop enrollment for children
  bool canViewClientsChildren() {
    return hasPermission(AppPermissions.clientGetChildren);
  }

  // Child Permissions
  bool canViewChildDetails() {
    return hasPermission(AppPermissions.childGetById);
  }

  bool canEditChild() {
    return hasAllPermissions([
      AppPermissions.childUpdate,
      AppPermissions.childGetById,
    ]);
  }

  bool canInsertChild() {
    return hasPermission(AppPermissions.childInsert);
  }

  bool canDeleteChild() {
    return hasPermission(AppPermissions.childDelete);
  }

  // add new child to client via add child to client screen
  bool canAddChildToClient() {
    return hasPermission(AppPermissions.clientAddChildren);
  }

  //remove child on client details screen
  bool canRemoveChildFromClient() {
    return hasAllPermissions([
      AppPermissions.clientRemoveChildren,
      AppPermissions.clientGetChildren,
    ]);
  }

  // Client & Child

  // update clienta na clients details screen
  bool canUpdateClientChild() {
    return hasPermission(AppPermissions.clientsChildUpdate);
  }

  // Payment Permissions - think if needed
  bool canViewPayment() {
    return hasPermission(AppPermissions.paymentGet);
  }

  bool canEditPayment() {
    return hasPermission(AppPermissions.paymentUpdate);
  }

  bool canInsertPayment() {
    return hasPermission(AppPermissions.paymentInsert);
  }

  bool canDeletePayment() {
    return hasPermission(AppPermissions.paymentDelete);
  }

  bool canCreatePaymentIntent() {
    return hasPermission(AppPermissions.paymentCreatePaymentIntent);
  }

  bool canVerifyPayment() {
    return hasPermission(AppPermissions.paymentVerifyPayment);
  }

  // Report Permissions
  bool canViewReport() {
    return hasPermission(AppPermissions.reportView);
  }

  bool canGetReportData() {
    return hasPermission(AppPermissions.reportGetReportData);
  }

  bool canGetKPI() {
    return hasPermission(AppPermissions.reportGetKPI);
  }

  bool canGetInsights() {
    return hasPermission(AppPermissions.reportGetInsights);
  }

  bool canExportReport() {
    return hasPermission(AppPermissions.reportExport);
  }

  // Review Permissions
  bool canViewReview() {
    return hasPermission(AppPermissions.reviewView);
  }

  // reviews for employees on employee profile screen
  bool canGetReviews() {
    return hasPermission(AppPermissions.reviewGet);
  }

  bool canViewAllReviews() {
    return hasAllPermissions([
      AppPermissions.reviewViewAll,
      AppPermissions.reviewGet,
    ]);
  }

  bool canViewOwnReviews() {
    return hasAllPermissions([
      AppPermissions.reviewViewOwn,
      AppPermissions.reviewGet,
    ]);
  }

  bool canEditReview() {
    return hasPermission(AppPermissions.reviewUpdate);
  }

  bool canInsertReview() {
    return hasAllPermissions([
      AppPermissions.reviewInsert,
      AppPermissions.appointmentGet,
    ]);
  }

  bool canDeleteReview() {
    return hasPermission(AppPermissions.reviewDelete);
  }

  bool canChangeReviewVisibility() {
    return hasPermission(AppPermissions.reviewChangeVisibility);
  }

  bool canGetReviewAverage() {
    return hasPermission(AppPermissions.reviewGetAverage);
  }

  // Role & RolePermissions
  // view roles & permissions screen
  bool canViewRolePermissions() {
    return hasPermission(AppPermissions.rolePermissionsView);
  }

  // add role to user on cleints details screen
  bool canAddRoleToUser() {
    return hasAllPermissions([
      AppPermissions.userAddRoleToUser,
      AppPermissions.rolePermissionsGetAllRoles,
    ]);
  }

  // remove role from user on clients details screen
  bool canRemoveRoleFromUser() {
    return hasPermission(AppPermissions.userRemoveRoleFromUser);
  }

  // view roles for user on client details screen
  bool canViewRolesForUser() {
    return hasPermission(AppPermissions.userGetRolesForUser);
  }

  // needed for adding new role in order to display roles in dropdown list and for displaying roles on roles and permissions screen
  bool canGetAllRoles() {
    return hasPermission(AppPermissions.rolePermissionsGetAllRoles);
  }

  bool canInsertRole() {
    return hasPermission(AppPermissions.roleInsert);
  }

  bool canGetByIdRole() {
    return hasPermission(AppPermissions.roleGetById);
  }

  bool canEditRole() {
    return hasPermission(AppPermissions.roleUpdate);
  }

  bool canDeleteRole() {
    return hasPermission(AppPermissions.roleDelete);
  }

  // permissions listed on screen
  bool canGetPermissions() {
    return hasPermission(AppPermissions.rolePermissionsGetGroupedPermissions);
  }

  // assigning permissions
  bool canUpdatePermissions() {
    return hasPermission(AppPermissions.rolePermissionsUpdateRolePermissions);
  }

  bool canAssignRolePermission() {
    return hasPermission(AppPermissions.roleAssignPermission);
  }

  bool canUpdateRolePermissions() {
    return hasPermission(AppPermissions.rolePermissionsUpdateRolePermissions);
  }

  bool canViewAllRolePermissions() {
    return hasAnyPermission([
      AppPermissions.rolePermissionsGetAllRoles,
      AppPermissions.rolePermissionsGetAllPermissions,
      AppPermissions.rolePermissionsGetGroupedPermissions,
    ]);
  }

  bool canGetWorkshops() {
    return hasPermission(AppPermissions.workshopGet);
  }

  // Service Permissions

  // note that for viewing service, employees etc. user have to have get permission too
  bool canViewServiceScreen() {
    return hasPermission(AppPermissions.serviceView);
  }

  bool canViewServiceStatistics() {
    return hasPermission(AppPermissions.serviceGetStatistics);
  }

  bool canGetByIdService() {
    return hasPermission(AppPermissions.serviceGetById);
  }

  bool canInsertService() {
    return hasPermission(AppPermissions.serviceInsert);
  }

  bool canEditService() {
    return hasPermission(AppPermissions.serviceUpdate);
  }

  bool canDeleteService() {
    return hasPermission(AppPermissions.serviceDelete);
  }

  bool canGetServiceTypes() {
    return hasPermission(AppPermissions.serviceTypeGet);
  }

  bool canInsertServiceType() {
    return hasPermission(AppPermissions.serviceTypeInsert);
  }

  bool canGetByIdServiceType() {
    return hasPermission(AppPermissions.serviceTypeGetById);
  }

  bool canEditServiceType() {
    return hasPermission(AppPermissions.serviceTypeUpdate);
  }

  bool canGetEmployeesForService() {
    return hasPermission(AppPermissions.serviceGetEmployeesForService);
  }

  bool canDeleteServiceType() {
    return hasPermission(AppPermissions.serviceTypeDelete);
  }

  bool canGetServices() {
    return hasPermission(AppPermissions.serviceGet);
  }

  // User Permissions
  bool canViewUser() {
    return hasPermission(AppPermissions.userGet);
  }

  bool canEditUser() {
    return hasPermission(AppPermissions.userUpdate);
  }

  bool canInsertUser() {
    return hasPermission(AppPermissions.userInsert);
  }

  bool canGetByIdUser() {
    return hasPermission(AppPermissions.userGetById);
  }

  bool canDeleteUser() {
    return hasPermission(AppPermissions.userDelete);
  }

  bool canChangeUserPassword() {
    return hasPermission(AppPermissions.userChangePassword);
  }

  bool canManageUserRoles() {
    return hasAnyPermission([
      AppPermissions.userAddRoleToUser,
      AppPermissions.userRemoveRoleFromUser,
      AppPermissions.userGetRolesForUser,
    ]);
  }

  bool canViewProfile() {
    return hasAllPermissions([
      AppPermissions.clientGetById,
      AppPermissions.clientGetChildren,
    ]);
  }

  // Helper methods
  bool hasPermission(String permission) {
    return _authProvider.user?.permissions.contains(permission) ?? false;
  }

  bool hasAnyPermission(List<String> permissions) {
    return permissions.any((p) => hasPermission(p));
  }

  bool hasAllPermissions(List<String> permissions) {
    return permissions.every((p) => hasPermission(p));
  }
}
