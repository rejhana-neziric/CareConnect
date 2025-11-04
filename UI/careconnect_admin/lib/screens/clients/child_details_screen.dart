import 'package:careconnect_admin/core/layouts/master_screen.dart';
import 'package:careconnect_admin/models/requests/child_update_request.dart';
import 'package:careconnect_admin/models/responses/appointment.dart';
import 'package:careconnect_admin/models/responses/child.dart';
import 'package:careconnect_admin/models/responses/client.dart';
import 'package:careconnect_admin/models/responses/clients_child.dart';
import 'package:careconnect_admin/models/responses/search_result.dart';
import 'package:careconnect_admin/providers/child_provider.dart';
import 'package:careconnect_admin/providers/clients_child_form_provider.dart';
import 'package:careconnect_admin/providers/clients_child_provider.dart';
import 'package:careconnect_admin/core/theme/app_colors.dart';
import 'package:careconnect_admin/providers/permission_provider.dart';
import 'package:careconnect_admin/screens/no_permission_screen.dart';
import 'package:careconnect_admin/widgets/confirm_dialog.dart';
import 'package:careconnect_admin/widgets/custom_date_field.dart';
import 'package:careconnect_admin/widgets/custom_dropdown_field.dart';
import 'package:careconnect_admin/widgets/custom_text_field.dart';
import 'package:careconnect_admin/widgets/primary_button.dart';
import 'package:careconnect_admin/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

class ChildDetailsScreen extends StatefulWidget {
  final Client client;
  final Child child;

  const ChildDetailsScreen({
    super.key,
    required this.client,
    required this.child,
  });

  @override
  State<ChildDetailsScreen> createState() => _ChildDetailsScreenState();
}

class _ChildDetailsScreenState extends State<ChildDetailsScreen> {
  Map<String, dynamic> _initialValue = {};
  final _formKey = GlobalKey<FormBuilderState>();

  SearchResult<ClientsChild>? result;
  late ClientsChildProvider clientsChildProvider;
  late ClientsChildFormProvider clientsChildFormProvider;
  late ChildProvider childProvider;
  bool isLoading = true;
  ClientsChild? clientsChild;

  List<Appointment>? appointments;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    clientsChildProvider = context.read<ClientsChildProvider>();
    clientsChildFormProvider = context.read<ClientsChildFormProvider>();
    childProvider = context.read<ChildProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initForm();
    });

    loadAppointments();

    if (clientsChildProvider.shouldRefresh) {
      loadAppointments();

      clientsChildProvider.markRefreshed();
    }
  }

  Future<void> initForm() async {
    setState(() {
      isLoading = true;
    });

    _initialValue = {
      "childFirstName": widget.child.firstName,
      "childLastName": widget.child.lastName,
      "childBirthDate": widget.child.birthDate,
      "childGender": widget.child.gender,
    };

    setState(() {
      isLoading = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_formKey.currentState != null) {
        _formKey.currentState!.patchValue(_initialValue);
      }
    });

    setState(() {});
  }

  Future<void> loadAppointments() async {
    final result = await clientsChildProvider.getAppointment(
      clientId: widget.client.user!.userId,
      childId: widget.child.childId,
    );

    if (mounted) {
      setState(() {
        appointments = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final permissionProvider = context.watch<PermissionProvider>();

    if (!permissionProvider.canViewChildDetails()) {
      return MasterScreen(
        'Child Details',
        NoPermissionScreen(),
        currentScreen: "Clients",
      );
    }

    return MasterScreen(
      "Child Details",
      currentScreen: "Clients",
      SingleChildScrollView(
        padding: const EdgeInsets.all(64),
        scrollDirection: Axis.vertical,
        child: SizedBox(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isLoading) _buildForm(),

                      SizedBox(height: 32),

                      if (permissionProvider.canEditChild()) ...[
                        SizedBox(height: 32),
                        SizedBox(
                          width: 1200,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [_saveRow()],
                          ),
                        ),
                        SizedBox(height: 32),
                      ],

                      if (permissionProvider.canGetAppointmentsForChild()) ...[
                        appointmentSchedule(),
                        SizedBox(height: 32),
                      ],
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget infoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: AppColors.mauveGray,
            ),
          ),
          Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  Widget _buildForm() {
    final clientsChildFormProvider = Provider.of<ClientsChildFormProvider>(
      context,
    );

    return SizedBox(
      width: 1200,
      child: Center(
        child: FormBuilder(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          initialValue: _initialValue,
          onChanged: () {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ExpansionTile(
                title: Container(
                  color: AppColors.mauveGray,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Child Information',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                initiallyExpanded: true,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomTextField(
                                width: 400,
                                name: 'childFirstName',
                                label: 'First Name',
                                validator:
                                    clientsChildFormProvider.validateName,
                              ),
                              CustomDateField(
                                width: 400,
                                name: 'childBirthDate',
                                label: 'Birth Date',
                                validator:
                                    clientsChildFormProvider.validateDate,
                              ),
                            ],
                          ),
                          const SizedBox(width: 60),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomTextField(
                                width: 400,
                                name: 'childLastName',
                                label: 'Last Name',
                                validator:
                                    clientsChildFormProvider.validateName,
                              ),
                              CustomDropdownField<String>(
                                width: 400,
                                name: 'childGender',
                                label: 'Gender',
                                items: [
                                  DropdownMenuItem(
                                    value: 'M',
                                    child: Text('Male'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'F',
                                    child: Text('Female'),
                                  ),
                                ],
                                validator:
                                    clientsChildFormProvider.validateNonEmpty,
                                enabled: false,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _saveRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PrimaryButton(
          onPressed: () async {
            Navigator.pop(context);
          },
          label: 'Cancel',
        ),
        SizedBox(width: 10),
        PrimaryButton(
          onPressed: () async {
            final formState = _formKey.currentState;

            if (formState == null || !formState.saveAndValidate()) {
              debugPrint('Form is not valid or state is null');
              return;
            }

            final formData = _formKey.currentState?.value;
            try {
              if (formData == null) {
                return;
              }

              final shouldProceed = await CustomConfirmDialog.show(
                context,
                icon: Icons.info,
                iconBackgroundColor: AppColors.mauveGray,
                title: 'Edit Child Information',
                content: 'Are you sure you want to edit child?',
                confirmText: 'Save',
                cancelText: 'Cancel',
              );

              if (shouldProceed != true) return;

              final updateChildRequest = ChildUpdateRequest(
                firstName: formData['childFirstName'],
                lastName: formData['childLastName'],
                birthDate: formData['childBirthDate'],
              );

              await childProvider.update(
                widget.child.childId,
                updateChildRequest,
              );

              if (!mounted) return;

              CustomSnackbar.show(
                context,
                message: 'Successfully update child.',
                type: SnackbarType.success,
              );

              Navigator.pop(context, true);
            } catch (e) {
              if (mounted) {
                CustomSnackbar.show(
                  context,
                  message: 'Something went wrong. Please try again.',
                  type: SnackbarType.error,
                );
              }
            } finally {
              if (mounted) {
                setState(() {
                  isLoading = false;
                });
              }
            }
          },
          label: 'Save',
        ),
      ],
    );
  }

  Widget appointmentSchedule() {
    return SizedBox(
      width: 1200,
      height: 500,
      child: Card(
        margin: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Appointment Schedule',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.mauveGray,
                  ),
                ),
                SizedBox(height: 12),
                ...((appointments != null && appointments?.isNotEmpty == true)
                    ? buildAppointments(appointments!)
                    : [const Text("No appointments scheduled.")]),
                SizedBox(height: 340),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildAppointments(List<Appointment> appointments) {
    return appointments.map((item) => buildTimelineTile(item)).toList();
  }

  Widget buildTimelineTile(Appointment item) {
    return TimelineTile(
      alignment: TimelineAlign.start,
      indicatorStyle: IndicatorStyle(
        color: const Color.fromARGB(255, 155, 111, 137),
        padding: EdgeInsets.symmetric(vertical: 8),
      ),
      beforeLineStyle: LineStyle(color: Colors.grey.shade300, thickness: 2),
      endChild: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${DateFormat('d. M. y.').format(item.date).toString()} at ${item.employeeAvailability?.startTime}',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 4),
            Text(
              item.appointmentType,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Text(
              item.employeeAvailability?.service?.name ?? 'No service provided',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            Text(
              '${item.employeeAvailability?.employee.user?.firstName} ${item.employeeAvailability?.employee.user?.lastName}',
            ),
          ],
        ),
      ),
    );
  }

  // Widget workshops() {
  //   // final appointments = clientsChild?.appointments;

  //   return SizedBox(
  //     width: 1200,
  //     height: 500,
  //     child: Card(
  //       margin: EdgeInsets.all(16),
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //       child: Padding(
  //         padding: EdgeInsets.all(16),
  //         child: SingleChildScrollView(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Text(
  //                 'Appointment Schedule',
  //                 style: TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                   color: AppColors.mauveGray,
  //                 ),
  //               ),
  //               SizedBox(height: 12),
  //               ...((appointments != null && appointments?.isNotEmpty == true)
  //                   ? buildAppointments(appointments!)
  //                   : [const Text("No appointments scheduled.")]),
  //               SizedBox(height: 340),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // List<Widget> buildWorkshops(List<Workshop> workshops) {
  //   return workshops
  //       .map((item) => buildTimelineTileForWorkshops(item))
  //       .toList();
  // }

  // Widget buildTimelineTileForWorkshops(Workshop item) {
  //   return TimelineTile(
  //     alignment: TimelineAlign.start,
  //     indicatorStyle: IndicatorStyle(
  //       color: const Color.fromARGB(255, 155, 111, 137),
  //       padding: EdgeInsets.symmetric(vertical: 8),
  //     ),
  //     beforeLineStyle: LineStyle(color: Colors.grey.shade300, thickness: 2),
  //     endChild: Padding(
  //       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             DateFormat('d. M. y.').format(item.date).toString(),
  //             style: TextStyle(color: Colors.grey),
  //           ),
  //           SizedBox(height: 4),
  //           Text(
  //             item.workshopType,
  //             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
  //           ),
  //           Text(item.name, style: TextStyle(color: Colors.grey.shade600)),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
