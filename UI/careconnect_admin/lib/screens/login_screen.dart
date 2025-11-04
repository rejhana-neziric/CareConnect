import 'package:careconnect_admin/core/config.dart';
import 'package:careconnect_admin/core/theme/app_colors.dart';
import 'package:careconnect_admin/models/auth_user.dart';
import 'package:careconnect_admin/providers/auth_provider.dart';
import 'package:careconnect_admin/providers/notification_provider.dart';
import 'package:careconnect_admin/providers/user_provider.dart';
import 'package:careconnect_admin/screens/employees/employee_list_screen.dart';
import 'package:careconnect_admin/services/singalr_service.dart';
import 'package:careconnect_admin/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isLoading = false;
  bool _obscurePassword = true;

  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideAnimation;

  late UserProvider userProvider;

  String? username;
  String? password;

  List<String>? permissions;

  final String _hubUrl =
      AppConfig.signalHubUrl; //dotenv.env['SIGNALR_HUB_URL'] ?? '';

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutBack,
          ),
        );

    _animationController.forward();

    userProvider = context.read<UserProvider>();
  }

  Future<void> getPermissions(String username) async {
    final response = await userProvider.getPermission(username);

    if (!mounted) return;

    setState(() {
      permissions = response;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.mauveGray,
              AppColors.softLavender,
              // Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: size.height - MediaQuery.of(context).padding.top,
              padding: const EdgeInsets.symmetric(horizontal: 26.0),
              child: Column(
                children: [
                  const Spacer(flex: 1),

                  // Logo and Title Section
                  FadeTransition(
                    opacity: _fadeInAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        children: [
                          const SizedBox(height: 24),

                          Text(
                            'CareConnect',
                            style: TextStyle(
                              fontSize: 55,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            'Welcome Back',
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(flex: 1),

                  // Form Section
                  FadeTransition(
                    opacity: _fadeInAnimation,
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: Container(
                          padding: const EdgeInsets.all(35),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: FormBuilder(
                            key: _formKey,
                            child: Column(
                              children: [
                                // Username
                                _buildAnimatedTextField(
                                  name: 'username',
                                  label: 'Username',
                                  icon: Icons.alternate_email,
                                  validators: [
                                    FormBuilderValidators.required(
                                      errorText: "Username is required",
                                    ),
                                    FormBuilderValidators.minLength(4),
                                    FormBuilderValidators.maxLength(20),
                                  ],
                                  delay: 200,
                                  colorScheme: colorScheme,
                                ),
                                const SizedBox(height: 20),
                                // Password
                                _buildAnimatedTextField(
                                  name: 'password',
                                  label: 'Password',
                                  icon: Icons.lock_outline,
                                  obscureText: _obscurePassword,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                  validators: [
                                    FormBuilderValidators.required(
                                      errorText: "Password is required",
                                    ),
                                    FormBuilderValidators.maxLength(32),
                                  ],
                                  delay: 400,
                                  colorScheme: colorScheme,
                                ),
                                const SizedBox(height: 32),
                                AnimatedBuilder(
                                  animation: _animationController,
                                  builder: (context, child) {
                                    return Transform.scale(
                                      scale: _fadeInAnimation.value,
                                      child: SizedBox(
                                        width: double.infinity,
                                        height: 56,
                                        child: ElevatedButton(
                                          onPressed: _isLoading
                                              ? null
                                              : _handleLogin,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                theme.colorScheme.primary,
                                            foregroundColor: Colors.white,
                                            elevation: 8,
                                            shadowColor: theme
                                                .colorScheme
                                                .primary
                                                .withOpacity(0.3),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                          ),
                                          child: _isLoading
                                              ? const SizedBox(
                                                  width: 24,
                                                  height: 24,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                          Color
                                                        >(Colors.white),
                                                  ),
                                                )
                                              : const Text(
                                                  'Login',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const Spacer(flex: 1),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedTextField({
    required String name,
    required String label,
    required IconData icon,
    required List<FormFieldValidator<String>> validators,
    required int delay,
    bool obscureText = false,
    Widget? suffixIcon,
    required ColorScheme colorScheme,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),

          child: FormBuilderTextField(
            name: name,
            obscureText: obscureText,
            validator: FormBuilderValidators.compose(validators),
            decoration: InputDecoration(
              labelText: label,
              prefixIcon: Icon(icon),
              prefixIconColor: colorScheme.primary,
              labelStyle: TextStyle(color: colorScheme.onSurface),
              suffixIcon: suffixIcon,
              filled: true,
              fillColor: colorScheme.surfaceContainerLow,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: colorScheme.primary),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final values = _formKey.currentState!.value;
      final username = values['username'] as String;
      final password = values['password'] as String;

      try {
        final notificationProvider = Provider.of<NotificationProvider>(
          context,
          listen: false,
        );

        notificationProvider.clearNotifications();

        await SignalRService().disconnect();
        await Future.delayed(const Duration(milliseconds: 500));
        final response = await userProvider.login(username, password);

        if (response != null) {
          if (response.status == false) {
            CustomSnackbar.show(
              context,
              message:
                  'Your account has been deactivated. Contact admin to reactivate it.',
              type: SnackbarType.error,
            );
            return;
          }

          await getPermissions(response.username);

          final authUser = AuthUser(
            id: response.userId,
            username: response.username,
            roles: response.roles,
            permissions: permissions ?? [],
          );

          Provider.of<AuthProvider>(context, listen: false).setUser(authUser);

          await notificationProvider.initialize(_hubUrl, authUser.id);

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EmployeeListScreen()),
          );
        } else {
          CustomSnackbar.show(
            context,
            message: 'Invalid credentials. Please try again.',
            type: SnackbarType.error,
          );
        }
      } on Exception catch (_) {
        CustomSnackbar.show(
          context,
          message: 'Something bad happened. Please try again.',
          type: SnackbarType.error,
        );
      }
    }
  }
}
