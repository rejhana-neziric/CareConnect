import 'package:careconnect_admin/layouts/master_screen.dart';
import 'package:careconnect_admin/models/responses/child.dart';
import 'package:careconnect_admin/models/responses/clients_child.dart';
import 'package:careconnect_admin/models/responses/search_result.dart';
import 'package:careconnect_admin/providers/client_provider.dart';
import 'package:careconnect_admin/providers/clients_child_form_provider.dart';
import 'package:careconnect_admin/providers/clients_child_provider.dart';
import 'package:careconnect_admin/screens/add_child_for_client_screen.dart';
import 'package:careconnect_admin/screens/child_details_screen.dart';
import 'package:careconnect_admin/theme/app_colors.dart';
import 'package:careconnect_admin/utils.dart';
import 'package:careconnect_admin/widgets/confirm_dialog.dart';
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
  late ClientsChildProvider clientsChildProvider;
  late ClientsChildFormProvider clientsChildFormProvider;
  late ClientProvider clientProvider;
  bool isLoading = true;

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
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
        // "childFirstName": widget.clientsChild?.child.firstName,
        // "childLastName": widget.clientsChild?.child.lastName,
        // "childBirthDate": widget.clientsChild?.child.birthDate,
        // "childGender": widget.clientsChild?.child.gender,
        "childFirstName": null,
        "childLastName": null,
        "childBirthDate": null,
        "childGender": null,
      });
    }

    // dynamic children;

    // if (widget.clientsChild?.client.user != null) {
    //   children = await clientsChildProvider.getChildren(
    //     widget.clientsChild!.client.user!.userId,
    //   );
    // }

    setState(() {
      _initialValue = Map<String, dynamic>.from(
        clientsChildFormProvider.initialData,
      );
      isLoading = false;

      getChildren();
      // otherChildren = children;
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

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      "Clients Details",
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
                _saveRow(),
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
                  "Client/Parent Information",
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
                    children: [buildSectionTitle("Personal Information")],
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
                            enabled: !clientsChildFormProvider.isUpdate,
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
                            enabled: !clientsChildFormProvider.isUpdate,
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
                          if (clientsChildFormProvider.isUpdate)
                            CustomDropdownField<bool>(
                              width: 400,
                              name: 'status',
                              label: 'Status',
                              items: [
                                DropdownMenuItem(
                                  value: true,
                                  child: Text('Active'),
                                ),
                                DropdownMenuItem(
                                  value: false,
                                  child: Text('Inactive'),
                                ),
                              ],
                              validator:
                                  clientsChildFormProvider.validateNonEmptyBool,
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
                          buildSectionTitle("Employment"),
                          CustomDropdownField<bool>(
                            width: 400,
                            name: 'employmentStatus',
                            label: 'Employment Status',
                            required: true,
                            items: [
                              DropdownMenuItem(
                                value: true,
                                child: Text('Employed'),
                              ),
                              DropdownMenuItem(
                                value: false,
                                child: Text('Unemployed'),
                              ),
                            ],
                            validator:
                                clientsChildFormProvider.validateNonEmptyBool,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(width: 40, height: 20),
                  if (clientsChildFormProvider.isUpdate)
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
                      children: [buildSectionTitle("Personal Information")],
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
          if (clientsChildFormProvider.isUpdate)
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
                              IconButton(
                                icon: Icon(
                                  Icons.visibility,
                                  color: Colors.blue,
                                ),
                                tooltip: "View details",
                                onPressed: () {
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
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                tooltip: "Delete child",
                                onPressed: () async {
                                  // Confirm delete
                                  final clientId =
                                      widget.clientsChild?.client.user?.userId;
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

                                    final success = await clientsChildProvider
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

                                    final success = await clientProvider.delete(
                                      clientId,
                                    );

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
                                },
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
}
