import 'package:careconnect_mobile/core/theme/app_colors.dart';
import 'package:careconnect_mobile/models/requests/child_insert_request.dart';
import 'package:careconnect_mobile/models/requests/client_insert_request.dart';
import 'package:careconnect_mobile/models/requests/clients_child_insert_request.dart';
import 'package:careconnect_mobile/models/requests/user_insert_request.dart';
import 'package:careconnect_mobile/providers/clients_child_provider.dart';
import 'package:careconnect_mobile/screens/login_screen.dart';
import 'package:careconnect_mobile/screens/signup/child_info_step.dart';
import 'package:careconnect_mobile/screens/signup/client_info_step.dart';
import 'package:careconnect_mobile/screens/signup/user_info_step.dart';
import 'package:careconnect_mobile/widgets/confim_dialog.dart';
import 'package:careconnect_mobile/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class SignUpFlow extends StatefulWidget {
  const SignUpFlow({super.key});

  @override
  State<SignUpFlow> createState() => _SignUpFlowState();
}

class _SignUpFlowState extends State<SignUpFlow> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  final _userFormKey = GlobalKey<FormBuilderState>();
  final _clientFormKey = GlobalKey<FormBuilderState>();
  final _childFormKey = GlobalKey<FormBuilderState>();

  Map<String, dynamic> _userData = {};
  Map<String, dynamic> _clientData = {};
  Map<String, dynamic> _childData = {};

  late AnimationController _progressAnimationController;

  late ClientsChildProvider clientsChildProvider;

  @override
  void initState() {
    super.initState();
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    clientsChildProvider = context.read<ClientsChildProvider>();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _progressAnimationController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _progressAnimationController.forward();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _progressAnimationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.mauveGray, AppColors.softLavender],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with progress
              _buildHeader(colorScheme),

              // Page content
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    UserInfoStep(
                      formKey: _userFormKey,
                      onDataChanged: (data) => setState(() => _userData = data),
                      onNext: _nextStep,
                      initialData: _userData,
                    ),
                    ClientInfoStep(
                      formKey: _clientFormKey,
                      onDataChanged: (data) =>
                          setState(() => _clientData = data),
                      onNext: _nextStep,
                      onBack: _previousStep,
                      initialData: _clientData,
                    ),
                    ChildInfoStep(
                      formKey: _childFormKey,
                      onDataChanged: (data) =>
                          setState(() => _childData = data),
                      onBack: _previousStep,
                      onComplete: _completeSignUp,
                      initialData: _childData,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  _clearSignUpData();
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  }
                },
                icon: const Icon(Icons.arrow_back),
              ),
              const Spacer(),
              Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const Spacer(),
              const SizedBox(width: 48),
            ],
          ),

          const SizedBox(height: 24),

          // Progress indicator
          Row(
            children: List.generate(3, (index) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: index <= _currentStep
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey[300],
                    ),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 16),

          Text(
            'Step ${_currentStep + 1} of 3',
            style: TextStyle(color: colorScheme.onSurface, fontSize: 14),
          ),
        ],
      ),
    );
  }

  void _clearSignUpData() {
    _userFormKey.currentState?.reset();
    _clientFormKey.currentState?.reset();
    _childFormKey.currentState?.reset();

    _userData.clear();
    _clientData.clear();
    _childData.clear();
  }

  Future<void> _completeSignUp() async {
    final shouldProceed = await CustomConfirmDialog.show(
      context,
      iconBackgroundColor: AppColors.accentDeepMauve,
      icon: Icons.info,
      title: 'Create Account',
      content: 'Are you sure you want to create account?',
      confirmText: 'Create',
      cancelText: 'Cancel',
    );

    if (shouldProceed != true) return;

    // Create the request objects
    final userRequest = UserInsertRequest(
      firstName: _userData['firstName'],
      lastName: _userData['lastName'],
      email: _userData['email'],
      phoneNumber: _userData['phoneNumber'],
      username: _userData['username'],
      password: _userData['password'],
      confirmationPassword: _userData['confirmPassword'],
      birthDate: _userData['birthDate'],
      gender: _userData['gender'],
      address: _userData['address'],
    );

    final clientRequest = ClientInsertRequest(
      employmentStatus: _clientData['employmentStatus'] ?? false,
      user: userRequest,
    );

    final childRequest = ChildInsertRequest(
      firstName: _childData['childfirstName'],
      lastName: _childData['childlastName'],
      birthDate: _childData['childbirthDate'],
      gender: _childData['childgender'],
    );

    final insertRequest = ClientsChildInsertRequest(
      clientInsertRequest: clientRequest,
      childInsertRequest: childRequest,
    );

    final response = await clientsChildProvider.insert(insertRequest);

    if (response != null) {
      CustomSnackbar.show(
        context,
        message: 'You have successfully created new account! Please login.',
        type: SnackbarType.success,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      CustomSnackbar.show(
        context,
        message: 'Something went wrong. Please try againg.',
        type: SnackbarType.error,
      );
    }
  }
}
