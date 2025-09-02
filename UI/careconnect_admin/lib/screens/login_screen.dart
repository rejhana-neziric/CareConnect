import 'package:careconnect_admin/models/auth_user.dart';
import 'package:careconnect_admin/providers/auth_provider.dart';
import 'package:careconnect_admin/providers/user_provider.dart';
import 'package:careconnect_admin/screens/employee_list_screen.dart';
import 'package:careconnect_admin/widgets/primary_button.dart';
import 'package:careconnect_admin/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late UserProvider userProvider;

  String? username;
  String? password;

  List<String>? permissions;

  @override
  void initState() {
    super.initState();

    userProvider = context.read<UserProvider>();
  }

  Future<void> getPermissions(String username) async {
    final response = await userProvider.getPermission(username);

    setState(() {
      permissions = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // userProvider = context.read<UserProvider>();

    final formKey = GlobalKey<FormBuilderState>();

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Card(
                      elevation: 8,
                      color: colorScheme.surfaceContainerLow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(50.0),

                        child: FormBuilder(
                          key: formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'CareConnect',
                                style: TextStyle(
                                  color: colorScheme.primary,
                                  fontSize: 70,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              const SizedBox(height: 32),

                              const Text(
                                'Welcome Back',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 32),

                              // Username
                              Container(
                                constraints: const BoxConstraints(
                                  minWidth: 200,
                                  maxWidth: 450,
                                ),
                                child: FormBuilderTextField(
                                  name: 'username',
                                  decoration: InputDecoration(
                                    labelText: 'Username',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(
                                      errorText: "Username is required.",
                                    ),
                                    FormBuilderValidators.maxLength(
                                      20,
                                      errorText:
                                          "Username must not exceed 20 characters.",
                                    ),
                                    FormBuilderValidators.minLength(
                                      4,
                                      errorText:
                                          "Username must be at least 4 characters.",
                                    ),
                                  ]),
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Password
                              Container(
                                constraints: const BoxConstraints(
                                  minWidth: 200,
                                  maxWidth: 450,
                                ),
                                child: FormBuilderTextField(
                                  name: 'password',
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(
                                      errorText: "Password is required.",
                                    ),
                                    FormBuilderValidators.maxLength(
                                      32,
                                      errorText:
                                          "Password must not exceed 32 characters.",
                                    ),
                                    // FormBuilderValidators.minLength(
                                    //   8,
                                    //   errorText:
                                    //       "Password must be at least 8 characters.",
                                    // ),
                                  ]),
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Login button
                              PrimaryButton(
                                onPressed: () async {
                                  if (formKey.currentState?.saveAndValidate() ??
                                      false) {
                                    final values = formKey.currentState!.value;
                                    final username =
                                        values['username'] as String;
                                    final password =
                                        values['password'] as String;

                                    try {
                                      final response = await userProvider.login(
                                        username,
                                        password,
                                      );

                                      if (response != null) {
                                        getPermissions(response.username);

                                        final authUser = AuthUser(
                                          username: response.username,
                                          roles: response.roles,
                                          permissions: permissions ?? [],
                                        );

                                        Provider.of<AuthProvider>(
                                          context,
                                          listen: false,
                                        ).setUser(authUser);

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const EmployeeListScreen(),
                                          ),
                                        );
                                      } else {
                                        CustomSnackbar.show(
                                          context,
                                          message:
                                              'Invalid credentials. Please try again.',
                                          type: SnackbarType.error,
                                        );
                                      }
                                    } on Exception catch (_) {
                                      CustomSnackbar.show(
                                        context,
                                        message:
                                            'Something bad happened. Please try again.',
                                        type: SnackbarType.error,
                                      );
                                    }
                                  }
                                },

                                label: "Login",
                              ),

                              const SizedBox(height: 45),

                              // Bottom image
                              Container(
                                width: 280,
                                height: 150,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      'assets/images/children.png',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
