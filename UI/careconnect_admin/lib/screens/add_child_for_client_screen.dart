import 'package:careconnect_admin/layouts/master_screen.dart';
import 'package:careconnect_admin/models/responses/client.dart';
import 'package:careconnect_admin/models/responses/clients_child.dart';
import 'package:careconnect_admin/models/responses/search_result.dart';
import 'package:careconnect_admin/providers/clients_child_form_provider.dart';
import 'package:careconnect_admin/providers/clients_child_provider.dart';
import 'package:careconnect_admin/theme/app_colors.dart';
import 'package:careconnect_admin/utils.dart';
import 'package:careconnect_admin/widgets/custom_date_field.dart';
import 'package:careconnect_admin/widgets/custom_dropdown_field.dart';
import 'package:careconnect_admin/widgets/custom_text_field.dart';
import 'package:careconnect_admin/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class AddChildForClientScreen extends StatefulWidget {
  final Client client;

  const AddChildForClientScreen({super.key, required this.client});

  @override
  State<AddChildForClientScreen> createState() =>
      _AddChildForClientScreenState();
}

class _AddChildForClientScreenState extends State<AddChildForClientScreen> {
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

  void initForm() {
    setState(() {
      // _initialValue = Map<String, dynamic>.from(
      //   clientsChildFormProvider.initialData,
      // );
      isLoading = false;
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
            title: Container(
              color: AppColors.mauveGray,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Add Child to ${widget.client.user?.firstName} ${widget.client.user?.lastName}",
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
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            width: 400,
                            name: 'childFirstName',
                            label: 'First Name',
                            validator: clientsChildFormProvider.validateName,
                          ),
                          CustomDateField(
                            width: 400,
                            name: 'childBirthDate',
                            label: 'Birth Date',
                            validator: clientsChildFormProvider.validateDate,
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
                final clientId = widget.client.user?.userId;

                final shouldProceed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Add New Child to Client'),
                    content: Text(
                      'Are you sure you want to add a new child for client?',
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

                final success = await clientsChildFormProvider.addChild(
                  clientsChildFormProvider,
                  clientsChildProvider,
                  clientId,
                  onSaved: () {
                    //loadData();

                    clientsChildFormProvider.resetForm();
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
