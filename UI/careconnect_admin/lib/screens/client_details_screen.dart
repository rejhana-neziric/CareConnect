import 'package:careconnect_admin/layouts/master_screen.dart';
import 'package:careconnect_admin/models/responses/clients_child.dart';
import 'package:careconnect_admin/models/responses/search_result.dart';
import 'package:careconnect_admin/models/search_objects/child_search_object.dart';
import 'package:careconnect_admin/models/search_objects/client_additional_data.dart';
import 'package:careconnect_admin/models/search_objects/client_search_object.dart';
import 'package:careconnect_admin/models/search_objects/clients_child_additional_data.dart';
import 'package:careconnect_admin/models/search_objects/clients_child_search_object.dart';
import 'package:careconnect_admin/providers/clients_child_form_provider.dart';
import 'package:careconnect_admin/providers/clients_child_provider.dart';
import 'package:careconnect_admin/utils.dart';
import 'package:careconnect_admin/widgets/custom_date_field.dart';
import 'package:careconnect_admin/widgets/custom_dropdown_field.dart';
import 'package:careconnect_admin/widgets/custom_text_field.dart';
import 'package:careconnect_admin/widgets/primary_button.dart';
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
  late ClientsChildProvider clientsChildProvider;
  late ClientsChildFormProvider clientsChildFormProvider;
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initForm();
    });
  }

  // optimize
  Future<SearchResult<ClientsChild>?> loadData({int page = 0}) async {
    SearchResult<ClientsChild>? result;

    final clientFilterObject = ClientSearchObject(
      additionalData: ClientAdditionalData(isUserIncluded: true),
      includeTotalCount: true,
    );

    final childFilterObject = ChildSearchObject(includeTotalCount: true);

    final filterObject = ClientsChildSearchObject(
      clientSearchObject: clientFilterObject,
      childSearchObject: childFilterObject,
      includeTotalCount: true,
      page: page,
      additionalData: ClientsChildAdditionalData(
        isChildIncluded: true,
        isClientIncluded: true,
      ),
    );

    final filter = filterObject.toJson();

    final newResult = await clientsChildProvider.get(filter: filter);

    result = newResult;

    if (mounted) {
      setState(() {});
    }

    return result;
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
        "childFirstName": widget.clientsChild?.child.firstName,
        "childLastName": widget.clientsChild?.child.lastName,
        "childBirthDate": widget.clientsChild?.child.birthDate,
        "childGender": widget.clientsChild?.child.gender,
      });
    }

    setState(() {
      _initialValue = Map<String, dynamic>.from(
        clientsChildFormProvider.initialData,
      );
      isLoading = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (clientsChildFormProvider.formKey.currentState != null) {
        clientsChildFormProvider.formKey.currentState!.patchValue(
          _initialValue,
        );
      }
    });

    setState(() {});
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
                if (!isLoading) _buildForm(),
                const SizedBox(height: 20),
                _saveRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    final clientsChildFormProvider = Provider.of<ClientsChildFormProvider>(
      context,
    );

    return FormBuilder(
      key: clientsChildFormProvider.formKey,
      autovalidateMode: AutovalidateMode.disabled,
      initialValue: _initialValue,
      onChanged: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExpansionTile(
            title: const Text("Client/Parent Information"),
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
                            validator: clientsChildFormProvider.validateName,
                            enabled: !clientsChildFormProvider.isUpdate,
                          ),
                          CustomDropdownField<String>(
                            width: 400,
                            name: 'gender',
                            label: 'Gender',
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
                            validator: (value) => clientsChildFormProvider
                                .validatePassword(value),
                          ),
                          CustomTextField(
                            width: 400,
                            name: 'confirmationPassword',
                            label: 'Confirmation Password',
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
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Sekcija: Dijete
          ExpansionTile(
            title: const Text("Child Information"),
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
                            validator: clientsChildFormProvider.validateName,
                            enabled: !clientsChildFormProvider.isUpdate,
                          ),
                          CustomDateField(
                            width: 400,
                            name: 'childBirthDate',
                            label: 'Birth Date',
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
                            validator: clientsChildFormProvider.validateName,
                            enabled: !clientsChildFormProvider.isUpdate,
                          ),
                          CustomDropdownField<String>(
                            width: 400,
                            name: 'childGender',
                            label: 'Gender',
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

              if (formState.saveAndValidate()) {
                final clientId = widget.clientsChild?.client.user?.userId;
                final childId = widget.clientsChild?.child.childId;

                final isInsert = widget.clientsChild == null;

                final shouldProceed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                      isInsert ? 'Add New Client and Child' : 'Save Changes',
                    ),
                    content: Text(
                      isInsert
                          ? 'Are you sure you want to add a new client and child?'
                          : 'Are you sure you want to save the changes?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text('Confirm'),
                      ),
                    ],
                  ),
                );

                if (shouldProceed != true) return;

                final success = await clientsChildFormProvider.saveOrUpdate(
                  clientsChildFormProvider,
                  clientsChildProvider,
                  clientId,
                  childId,
                  onSaved: () {
                    loadData();
                  },
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? (clientsChildFormProvider.isUpdate
                                ? 'Client and child updated.'
                                : 'Client and child added.')
                          : 'Error.',
                    ),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );

                if (success && !clientsChildFormProvider.isUpdate) {
                  setState(() {});

                  clientsChildFormProvider.resetForm();
                }

                Provider.of<ClientsChildProvider>(
                  context,
                  listen: false,
                ).markShouldRefresh();
              }
            },
            label: 'Save',
          ),
        ],
      ),
    );
  }
}
