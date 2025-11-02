import 'package:careconnect_admin/core/layouts/master_screen.dart';
import 'package:careconnect_admin/models/responses/child.dart';
import 'package:careconnect_admin/models/responses/clients_child.dart';
import 'package:careconnect_admin/models/responses/role.dart';
import 'package:careconnect_admin/models/responses/search_result.dart';
import 'package:careconnect_admin/providers/client_provider.dart';
import 'package:careconnect_admin/providers/clients_child_form_provider.dart';
import 'package:careconnect_admin/providers/clients_child_provider.dart';
import 'package:careconnect_admin/providers/permission_provider.dart';
import 'package:careconnect_admin/providers/role_permissions_provider.dart';
import 'package:careconnect_admin/providers/user_provider.dart';
import 'package:careconnect_admin/screens/clients/add_child_for_client_screen.dart';
import 'package:careconnect_admin/screens/clients/child_details_screen.dart';
import 'package:careconnect_admin/core/theme/app_colors.dart';
import 'package:careconnect_admin/core/utils.dart';
import 'package:careconnect_admin/screens/no_permission_screen.dart';
import 'package:careconnect_admin/widgets/confirm_dialog.dart';
import 'package:careconnect_admin/widgets/custom_checkbox_field.dart';
import 'package:careconnect_admin/widgets/custom_date_field.dart';
import 'package:careconnect_admin/widgets/custom_dropdown_field.dart';
import 'package:careconnect_admin/widgets/custom_text_field.dart';
import 'package:careconnect_admin/widgets/primary_button.dart';
import 'package:careconnect_admin/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class ClientDetailsScreen extends StatefulWidget {
  final ClientsChild? clientsChild;

  const ClientDetailsScreen({super.key, this.clientsChild});

  @override
  State<ClientDetailsScreen> createState() => _ClientDetailsScreenState();
}

class _ClientDetailsScreenState extends State<ClientDetailsScreen> {
  Map<String, dynamic> _initialValue = {};
  SearchResult<ClientsChild>? result;
  List<Child>? otherChildren;
  List<Role> userRoles = [];
  List<Role> roles = [];
  bool isAccessAllowed = false;
  late ClientsChildProvider clientsChildProvider;
  late ClientsChildFormProvider clientsChildFormProvider;
  late ClientProvider clientProvider;
  late UserProvider userProvider;
  late RolePermissionsProvider rolePermissionsProvider;
  bool isLoading = true;
  late PermissionProvider permissionProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    clientsChildProvider = context.read<ClientsChildProvider>();
    clientsChildFormProvider = context.read<ClientsChildFormProvider>();
    clientProvider = context.read<ClientProvider>();
    userProvider = context.read<UserProvider>();
    rolePermissionsProvider = context.read<RolePermissionsProvider>();
    permissionProvider = context.read<PermissionProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.clientsChild != null) {
        if (permissionProvider.canViewRolesForUser()) getUserRoles();
        if (permissionProvider.canGetAllRoles()) getRoles();
      }

      initForm();
    });
  }

  Future<void> initForm() async {
    if (widget.clientsChild == null) {
      clientsChildFormProvider.setForInsert();
    } else {
      clientsChildFormProvider.setForUpdate({
        "username": widget.clientsChild?.client.user?.username,
        "firstName": widget.clientsChild?.client.user?.firstName,
        "lastName": widget.clientsChild?.client.user?.lastName,
        "status": widget.clientsChild?.client.user?.status,
        "email": widget.clientsChild?.client.user?.email,
        "phoneNumber": widget.clientsChild?.client.user?.phoneNumber,
        "birthDate": widget.clientsChild?.client.user?.birthDate,
        "gender": widget.clientsChild?.client.user?.gender,
        "address": widget.clientsChild?.client.user?.address,
        "employmentStatus": widget.clientsChild?.client.employmentStatus,
        "childFirstName": null,
        "childLastName": null,
        "childBirthDate": null,
        "childGender": null,
      });

      isAccessAllowed = widget.clientsChild!.client.user!.status;
    }

    setState(() {
      _initialValue = Map<String, dynamic>.from(
        clientsChildFormProvider.initialData,
      );
      isLoading = false;

      if (permissionProvider.canViewClientsChildren()) getChildren();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (clientsChildFormProvider.formKey.currentState != null) {
        clientsChildFormProvider.formKey.currentState!.patchValue(
          _initialValue,
        );
      }
    });

    setState(() {});
  }

  dynamic getChildren() async {
    dynamic children;

    if (widget.clientsChild?.client.user != null) {
      children = await clientsChildProvider.getChildren(
        widget.clientsChild!.client.user!.userId,
      );
    }

    setState(() {
      otherChildren = children;
    });
  }

  void getUserRoles() async {
    setState(() {
      isLoading = true;
    });

    final response = await userProvider.getRoles(
      userId: widget.clientsChild!.client.user!.userId,
    );

    userRoles = response;

    setState(() {
      isLoading = false;
    });
  }

  void getRoles() async {
    setState(() {
      isLoading = true;
    });

    final allRoles = await rolePermissionsProvider.getRoles();

    roles = allRoles;

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final permissionProvider = context.watch<PermissionProvider>();

    // !permissionProvider.canViewClientDetails()

    if (!permissionProvider.canViewClientDetails() &&
        !(permissionProvider.canInsertClient() &&
            widget.clientsChild == null)) {
      return MasterScreen(
        'Clients Details',
        NoPermissionScreen(),
        currentScreen: "Clients Details",
      );
    }

    return MasterScreen(
      "Clients Details",
      currentScreen: "Clients",

      SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (!isLoading)
                  Consumer<ClientsChildProvider>(
                    builder: (context, clientsChildProvider, child) {
                      return _buildForm();
                    },
                  ),
                const SizedBox(height: 20),
                if ((permissionProvider.canUpdateClientChild() &&
                        widget.clientsChild != null) ||
                    (permissionProvider.canInsertClient() &&
                        widget.clientsChild == null))
                  _saveRow(),
                const SizedBox(height: 20),
                if (permissionProvider.canDeleteClient() &&
                    widget.clientsChild != null)
                  _buildDeactivateAccount(),
              ],
            ),
          ),
        ),
      ),
      onBackPressed: () => clientsChildFormProvider.handleBackPressed(context),
    );
  }

  Widget _buildForm() {
    final clientsChildFormProvider = Provider.of<ClientsChildFormProvider>(
      context,
    );

    final permissionProvider = context.watch<PermissionProvider>();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return FormBuilder(
      key: clientsChildFormProvider.formKey,
      autovalidateMode: AutovalidateMode.disabled,
      initialValue: _initialValue,
      onChanged: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExpansionTile(
            title: Container(
              color: AppColors.mauveGray,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Parent Information",
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildSectionTitle("Personal Information", colorScheme),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            width: 400,
                            name: 'firstName',
                            label: 'First Name',
                            required: true,
                            validator: clientsChildFormProvider.validateName,
                            //  enabled: !clientsChildFormProvider.isUpdate,
                          ),
                          CustomDateField(
                            width: 400,
                            name: 'birthDate',
                            label: 'Birth Date',
                            enabled: !clientsChildFormProvider.isUpdate,
                          ),
                          CustomTextField(
                            width: 400,
                            name: 'address',
                            label: 'Address',
                            validator: clientsChildFormProvider.validateAddress,
                          ),
                          CustomTextField(
                            width: 400,
                            name: 'email',
                            label: 'Email',
                            validator: clientsChildFormProvider.validateEmail,
                          ),
                          CustomTextField(
                            width: 400,
                            name: 'username',
                            label: 'Username',
                            required: true,
                            validator:
                                clientsChildFormProvider.validateUsername,
                          ),
                        ],
                      ),
                      const SizedBox(width: 60),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            width: 400,
                            name: 'lastName',
                            label: 'Last Name',
                            required: true,
                            validator: clientsChildFormProvider.validateName,
                            //   enabled: !clientsChildFormProvider.isUpdate,
                          ),
                          CustomDropdownField<String>(
                            width: 400,
                            name: 'gender',
                            label: 'Gender',
                            required: true,
                            items: [
                              DropdownMenuItem(value: 'M', child: Text('Male')),
                              DropdownMenuItem(
                                value: 'F',
                                child: Text('Female'),
                              ),
                            ],
                            validator:
                                clientsChildFormProvider.validateNonEmpty,
                            enabled: !clientsChildFormProvider.isUpdate,
                          ),
                          CustomTextField(
                            width: 400,
                            name: 'phoneNumber',
                            hintText: '61234567',
                            prefixText: '+387 ',
                            label: 'Phone Number',
                            validator:
                                clientsChildFormProvider.validatePhoneNumber,
                          ),
                          CustomTextField(
                            width: 400,
                            name: 'password',
                            label: 'Password',
                            required: clientsChildFormProvider.isUpdate == true
                                ? false
                                : true,
                            validator: (value) => clientsChildFormProvider
                                .validatePassword(value),
                          ),
                          CustomTextField(
                            width: 400,
                            name: 'confirmationPassword',
                            label: 'Confirmation Password',
                            required: clientsChildFormProvider.isUpdate == true
                                ? false
                                : true,
                            validator: (value) {
                              final password = clientsChildFormProvider
                                  .formKey
                                  .currentState
                                  ?.fields['password']
                                  ?.value;

                              return clientsChildFormProvider
                                  .validateConfirmationPassword(
                                    value,
                                    password,
                                  );
                            },
                            enabled: !clientsChildFormProvider.isUpdate,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(width: 40, height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildSectionTitle("Employment", colorScheme),
                          CustomCheckboxField(
                            width: 400,
                            name: 'employmentStatus',
                            label: "Is Client Employeed",
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(width: 40, height: 40),

                  if (clientsChildFormProvider.isUpdate)
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: isAccessAllowed,
                                  onChanged: (value) {
                                    setState(() {
                                      isAccessAllowed = value!;
                                    });
                                  },
                                ),
                                const Text(
                                  'Allow access to application',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'If unchecked, the user will not be able to log in. This action is reversible and can be undone at any time.',
                              style: TextStyle(
                                fontSize: 16,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                  if (widget.clientsChild != null &&
                      permissionProvider.canViewRolesForUser() &&
                      isLoading == false) ...[
                    const SizedBox(width: 40, height: 40),

                    buildSectionTitle("Roles", colorScheme),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        //  if (userRoles.isEmpty && isLoading == false)
                        //     Text('This user does not have assigned roles yet.')
                        //   else
                        ...userRoles.map((role) {
                          return InputChip(
                            label: Text(role.name),
                            onDeleted: () async {
                              if (permissionProvider.canRemoveRoleFromUser()) {
                                final shouldProceed =
                                    await CustomConfirmDialog.show(
                                      context,
                                      icon: Icons.error,
                                      title: 'Remove role',
                                      content:
                                          'Are you sure you want to remove from this user?',
                                      confirmText: 'Remove',
                                      cancelText: 'Cancel',
                                    );

                                if (shouldProceed != true) return;

                                if (shouldProceed == true) {
                                  final success = await userProvider.removeRole(
                                    widget.clientsChild!.client.user!.userId,
                                    role.roleId,
                                  );
                                  if (success) {
                                    setState(() {
                                      getRoles();
                                    });
                                    CustomSnackbar.show(
                                      context,
                                      message: 'Role removed successfully.',
                                      type: SnackbarType.success,
                                    );
                                  } else {
                                    CustomSnackbar.show(
                                      context,
                                      message:
                                          'Failed to remove role. Please try again.',
                                      type: SnackbarType.error,
                                    );
                                  }
                                }
                              }
                            },
                            deleteIcon:
                                permissionProvider.canRemoveRoleFromUser() ==
                                    true
                                ? const Icon(Icons.close, size: 18)
                                : null,
                            backgroundColor: colorScheme.surfaceContainerLowest,
                          );
                        }),

                        if (permissionProvider.canAddRoleToUser())
                          PrimaryButton(
                            onPressed: () async {
                              await _showAddRoleDialog(context);
                            },
                            label: 'Add Role',
                            icon: Icons.add,
                          ),
                      ],
                    ),
                  ],

                  const SizedBox(width: 40, height: 20),
                  if (clientsChildFormProvider.isUpdate &&
                      permissionProvider.canAddChildToClient())
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,

                      children: [
                        PrimaryButton(
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChangeNotifierProvider(
                                  create: (_) =>
                                      ClientsChildFormProvider()
                                        ..setForInsert(),
                                  child: AddChildForClientScreen(
                                    client: widget.clientsChild!.client,
                                  ),
                                ),
                              ),
                            );

                            if (result == true) getChildren();
                          },
                          label: 'Add Child',
                          icon: Icons.person_add_alt_1,
                        ),
                      ],
                    ),
                  const SizedBox(width: 40, height: 20),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Sekcija: Dijete
          if (!clientsChildFormProvider.isUpdate)
            ExpansionTile(
              title: Container(
                color: AppColors.mauveGray,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Child Information",
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
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildSectionTitle("Personal Information", colorScheme),
                      ],
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextField(
                              width: 400,
                              name: 'childFirstName',
                              label: 'First Name',
                              required: true,
                              validator: clientsChildFormProvider.validateName,
                              enabled: !clientsChildFormProvider.isUpdate,
                            ),
                            CustomDateField(
                              width: 400,
                              name: 'childBirthDate',
                              label: 'Birth Date',
                              required: true,
                              validator: clientsChildFormProvider.validateDate,
                              enabled: !clientsChildFormProvider.isUpdate,
                            ),
                          ],
                        ),
                        const SizedBox(width: 60),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextField(
                              width: 400,
                              name: 'childLastName',
                              label: 'Last Name',
                              required: true,
                              validator: clientsChildFormProvider.validateName,
                              enabled: !clientsChildFormProvider.isUpdate,
                            ),
                            CustomDropdownField<String>(
                              width: 400,
                              name: 'childGender',
                              label: 'Gender',
                              required: true,
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
                              enabled: !clientsChildFormProvider.isUpdate,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          const SizedBox(height: 16),
          if (clientsChildFormProvider.isUpdate &&
              permissionProvider.canViewClientsChildren())
            ExpansionTile(
              title: Container(
                color: colorScheme.secondary,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Children",
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
                if (otherChildren == null || otherChildren?.isEmpty == true)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("No other children found."),
                  )
                else
                  ...otherChildren!.map(
                    (child) => Material(
                      color: Colors.transparent,
                      child: Tooltip(
                        message: "View child details.",
                        child: ListTile(
                          title: Text("${child.firstName} ${child.lastName}"),
                          subtitle: Text(
                            "Birthdate: ${child.birthDate.day}. ${child.birthDate.month}. ${child.birthDate.year}",
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChangeNotifierProvider(
                                  create: (_) =>
                                      ClientsChildFormProvider()
                                        ..setForInsert(),
                                  child: ChildDetailsScreen(
                                    client: widget.clientsChild!.client,
                                    child: child,
                                  ),
                                ),
                              ),
                            );
                          },
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Center(
                                child: PopupMenuButton<String>(
                                  onSelected: (value) async {
                                    if (value == 'details') {
                                      if (!permissionProvider
                                          .canViewChildDetails()) {
                                        CustomSnackbar.show(
                                          context,
                                          message:
                                              'You do not have permission to perform this action.',
                                          type: SnackbarType.error,
                                        );
                                      } else {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                ChangeNotifierProvider(
                                                  create: (_) =>
                                                      ClientsChildFormProvider()
                                                        ..setForInsert(),
                                                  child: ChildDetailsScreen(
                                                    client: widget
                                                        .clientsChild!
                                                        .client,
                                                    child: child,
                                                  ),
                                                ),
                                          ),
                                        );

                                        // if i add edit child option fix this
                                        // if (result == true &&
                                        //     onPageChanged != null) {
                                        //   onPageChanged!(currentPage);
                                        // }
                                      }
                                    } else if (value == 'delete') {
                                      if (!permissionProvider
                                          .canRemoveChildFromClient()) {
                                        CustomSnackbar.show(
                                          context,
                                          message:
                                              'You do not have permission to perform this action.',
                                          type: SnackbarType.error,
                                        );
                                      } else {
                                        // Confirm delete
                                        final clientId = widget
                                            .clientsChild
                                            ?.client
                                            .user
                                            ?.userId;
                                        final childId = child.childId;

                                        if (clientId == null) {
                                          return;
                                        }

                                        if (otherChildren?.length != 1) {
                                          final shouldProceed =
                                              await CustomConfirmDialog.show(
                                                context,
                                                icon: Icons.info,

                                                title: 'Delete Child',
                                                content:
                                                    'Are you sure you want to delete this child?',
                                                confirmText: 'Delete',
                                                cancelText: 'Cancel',
                                              );

                                          if (shouldProceed != true) return;

                                          final success =
                                              await clientsChildProvider
                                                  .removeChildFromClient(
                                                    clientId,
                                                    childId,
                                                  );

                                          if (!mounted) return;

                                          CustomSnackbar.show(
                                            context,
                                            message: success
                                                ? 'Child successfully deleted.'
                                                : 'Something went wrong. Please try again.',
                                            type: success
                                                ? SnackbarType.success
                                                : SnackbarType.error,
                                          );

                                          if (success) {
                                            setState(() {
                                              getChildren();
                                            });
                                          }
                                        } else {
                                          final shouldProceed =
                                              await CustomConfirmDialog.show(
                                                context,
                                                icon: Icons.info,

                                                title: 'Delete Child',
                                                content:
                                                    'Are you sure you want to delete this child? Deleting this child will also delete information about parent!',
                                                confirmText: 'Delete',
                                                cancelText: 'Cancel',
                                              );

                                          if (shouldProceed != true) return;

                                          final success = await clientProvider
                                              .delete(clientId);

                                          if (!mounted) return;

                                          CustomSnackbar.show(
                                            context,
                                            message: success
                                                ? 'Client and child successfully deleted.'
                                                : 'Something went wrong. Please try again.',
                                            type: success
                                                ? SnackbarType.success
                                                : SnackbarType.error,
                                          );

                                          if (success) {
                                            Navigator.of(context).pop(success);
                                          }
                                        }
                                      }
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 'details',
                                      child: Text('View child details'),
                                    ),
                                    const PopupMenuItem(
                                      value: 'delete',
                                      child: Text('Delete child details'),
                                    ),
                                  ],
                                  child: const Icon(Icons.more_vert),
                                ),
                              ),
                            ],
                          ),
                          hoverColor: colorScheme.surfaceContainerLowest,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Future<void> _showAddRoleDialog(BuildContext context) async {
    final selectedRoleId = await showDialog<int>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Assign Role'),
          content: SizedBox(
            width: 400,
            child: DropdownButtonFormField<int>(
              decoration: const InputDecoration(labelText: 'Select Role'),
              items: roles.map((r) {
                return DropdownMenuItem<int>(
                  value: r.roleId,
                  child: Text(r.name),
                );
              }).toList(),
              onChanged: (value) {
                Navigator.pop(ctx, value);
              },
            ),
          ),
        );
      },
    );

    if (selectedRoleId != null && widget.clientsChild != null) {
      final success = await userProvider.addRole(
        widget.clientsChild!.client.user!.userId,
        selectedRoleId,
      );
      if (success) {
        CustomSnackbar.show(
          context,
          message: 'Role successfully added.',
          type: SnackbarType.success,
        );
        getRoles();
      } else {
        CustomSnackbar.show(
          context,
          message: 'Failed to add role. Please try again.',
          type: SnackbarType.error,
        );
      }
    }
  }

  Widget _saveRow() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
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
              final formState = clientsChildFormProvider.formKey.currentState;

              if (formState == null || !formState.saveAndValidate()) {
                debugPrint('Form is not valid or state is null');
                return;
              }

              final clientId = widget.clientsChild?.client.user?.userId;
              final childId = widget.clientsChild?.child.childId;

              final isInsert = widget.clientsChild == null;

              final shouldProceed = await CustomConfirmDialog.show(
                context,
                icon: Icons.info,
                iconBackgroundColor: AppColors.mauveGray,
                title: isInsert ? 'Add New Client and Child' : 'Save Changes',
                content: isInsert
                    ? 'Are you sure you want to add a new client and child?'
                    : 'Are you sure you want to save the changes?',
                confirmText: 'Continue',
                cancelText: 'Cancel',
              );

              if (shouldProceed != true) return;

              final success = await clientsChildFormProvider.saveOrUpdateCustom(
                clientsChildFormProvider,
                clientsChildProvider,
                clientId,
                childId,
                isAccessAllowed,
              );

              if (!mounted) return;

              CustomSnackbar.show(
                context,
                message: success
                    ? (clientsChildFormProvider.isUpdate
                          ? 'Client and child updated.'
                          : 'Client and child added.')
                    : 'Something went wrong. Please try again.',
                type: success ? SnackbarType.success : SnackbarType.error,
              );

              if (success && !clientsChildFormProvider.isUpdate) {
                setState(() {});
                clientsChildFormProvider.resetForm();
              }

              clientsChildFormProvider.success = success;

              if (success) {
                clientsChildFormProvider.saveInitialValue();
              }
            },
            label: 'Save',
          ),
        ],
      ),
    );
  }

  Widget _buildDeactivateAccount() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Delete Client Account',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Deleting this client’s account will permanently remove all their personal information, '
            'appointments, and related data from the system. '
            'This action cannot be undone.',
            style: TextStyle(fontSize: 14, color: colorScheme.onSurface),
          ),
          const SizedBox(height: 16),

          PrimaryButton(
            label: 'Delete Account',
            icon: Icons.delete_forever,
            backgroundColor: Colors.red[600],
            onPressed: confirmDeactivation,
          ),
        ],
      ),
    );
  }

  void confirmDeactivation() async {
    if (widget.clientsChild == null || widget.clientsChild?.client.user == null)
      return;

    final confirm = await CustomConfirmDialog.show(
      context,
      icon: Icons.warning,
      iconBackgroundColor: Colors.red,
      title: 'Permanently Delete Account',
      content:
          'Are you sure you want to permanently delete this client’s account?\n\n'
          'All personal data, history, and related records will be permanently erased. '
          'This action cannot be reverted.',
      confirmText: 'Deactivate',
      cancelText: 'Cancel',
    );

    if (confirm) {
      final success = await clientProvider.delete(
        widget.clientsChild!.client.user!.userId,
      );

      if (!mounted) return;

      CustomSnackbar.show(
        context,
        message: success
            ? 'Your account has been deactivated.'
            : 'Failed to deactivate account. Please try again later.',
        type: success ? SnackbarType.success : SnackbarType.error,
      );

      Navigator.pop(context, true);
    }
  }
}
