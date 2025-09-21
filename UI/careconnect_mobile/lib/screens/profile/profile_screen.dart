import 'package:careconnect_mobile/models/auth_user.dart';
import 'package:careconnect_mobile/models/requests/client_update_request.dart';
import 'package:careconnect_mobile/models/requests/user_update_request.dart';
import 'package:careconnect_mobile/models/responses/child.dart';
import 'package:careconnect_mobile/models/responses/client.dart';
import 'package:careconnect_mobile/models/responses/user.dart';
import 'package:careconnect_mobile/providers/auth_provider.dart';
import 'package:careconnect_mobile/providers/client_provider.dart';
import 'package:careconnect_mobile/providers/clients_child_provider.dart';
import 'package:careconnect_mobile/screens/profile/child_details_screen.dart';
import 'package:careconnect_mobile/screens/profile/edit_child_screen.dart';
import 'package:careconnect_mobile/screens/profile/edit_profile_screen.dart';
import 'package:careconnect_mobile/screens/login_screen.dart';
import 'package:careconnect_mobile/screens/profile/widgets/profile_header.dart';
import 'package:careconnect_mobile/widgets/confim_dialog.dart';
import 'package:careconnect_mobile/widgets/primary_button.dart';
import 'package:careconnect_mobile/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  late ClientsChildProvider clientsChildProvider;
  late ClientProvider clientProvider;

  bool isLoading = false;

  List<Child> children = [];

  AuthUser? currentUser;

  Client? currenClient;

  @override
  void initState() {
    super.initState();

    final auth = Provider.of<AuthProvider>(context, listen: false);

    currentUser = auth.user;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    clientsChildProvider = context.read<ClientsChildProvider>();
    clientProvider = context.read<ClientProvider>();

    if (currentUser != null) {
      _loadClientAndChildren();
    }

    loadChildren();
  }

  Future<void> _loadClientAndChildren() async {
    setState(() {
      isLoading = true;
    });

    currenClient = await clientProvider.getById(currentUser!.id);
    children = await clientsChildProvider.getChildren(currentUser!.id);

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> loadChildren() async {
    setState(() {
      isLoading = true;
    });

    final result = await clientsChildProvider.getChildren(currentUser!.id);

    setState(() {
      children = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (isLoading || currenClient == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final user = currenClient?.user;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLow,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildProfileHeader(context, user, colorScheme, backArrow: false),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    _buildStatusCards(user, colorScheme),
                    const SizedBox(height: 24),
                    _buildPersonalInfoCard(user, colorScheme),
                    const SizedBox(height: 24),
                    _buildContactInfoCard(user, colorScheme),
                    const SizedBox(height: 24),
                    _buildChildrenInfo(colorScheme),
                    const SizedBox(height: 24),
                    _buildDeactivateAccount(colorScheme),
                    const SizedBox(height: 34),
                    _buildActionButtons(colorScheme),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCards(User? user, ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          child: _buildStatusCard(
            'Account Status',
            user?.status == true ? 'Active' : 'Inactive',
            user?.status == true ? Colors.green : Colors.red,
            user?.status == true ? Icons.check_circle : Icons.cancel,
            colorScheme,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatusCard(
            'Employment',
            currenClient!.employmentStatus ? 'Employed' : 'Unemployed',
            currenClient!.employmentStatus ? Colors.green : Colors.red,
            currenClient!.employmentStatus ? Icons.work : Icons.work_off,
            colorScheme,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard(
    String title,
    String value,
    Color color,
    IconData icon,
    ColorScheme colorScheme,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoCard(User? user, ColorScheme colorScheme) {
    return _buildInfoCard('Personal Information', icon: Icons.person, [
      _buildInfoRow('Gender', user?.gender ?? 'Not specified', colorScheme),
      if (user?.birthDate != null)
        _buildInfoRow(
          'Birth Date',
          DateFormat('d. MM. yyyy.').format(user!.birthDate!),
          colorScheme,
        ),
      _buildInfoRow('Address', user?.address ?? 'Not provided', colorScheme),
    ], colorScheme);
  }

  Widget _buildContactInfoCard(User? user, ColorScheme colorScheme) {
    return _buildInfoCard('Contact Information', icon: Icons.contact_phone, [
      if (user != null && user.phoneNumber != null)
        _buildInfoRow2(
          Icons.phone_outlined,
          'Phone number',
          user.phoneNumber != null
              ? '+387 ${user.phoneNumber}'
              : 'Not specified',
          null,
          colorScheme,
        ),
      if (user != null && user.email != null) ...[
        const Divider(height: 24),
        _buildInfoRow2(
          Icons.email_outlined,
          'Email',
          user.email ?? 'Not specified',
          null,
          colorScheme,
        ),
      ],
    ], colorScheme);
  }

  Widget _buildInfoRow2(
    IconData? icon,
    String title,
    String value,
    String? subtitle,
    ColorScheme colorScheme,
  ) {
    return Row(
      children: [
        if (icon != null)
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: colorScheme.primary, size: 20),
          ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    String title,
    List<Widget> children,
    ColorScheme colorScheme, {
    IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: colorScheme.primary, size: 20),
                ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChildrenInfo(ColorScheme colorScheme) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (children.isEmpty) {
      return const Center(
        child: Text(
          "No services found.",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return _buildInfoCard('Child Information', [
      ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: children.length,
        itemBuilder: (context, index) {
          final child = children[index];
          return _buildChildInfo(child, colorScheme);
        },
        separatorBuilder: (context, index) => const Divider(),
      ),

      Center(
        child: TextButton.icon(
          onPressed: _addChild,
          icon: Icon(Icons.add, color: colorScheme.primary),
          label: Text(
            "Add Child",
            style: TextStyle(color: colorScheme.primary),
          ),
        ),
      ),
    ], colorScheme);
  }

  Widget _buildChildInfo(Child child, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 5),
      //padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar / Initials
          CircleAvatar(
            radius: 28,
            backgroundColor: colorScheme.primary.withOpacity(0.15),
            child: Text(
              '${child.firstName[0]}${child.lastName[0]}',
              style: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + Gender
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${child.firstName} ${child.lastName}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      child.gender,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // Age
                Text(
                  "Age: ${child.age}",
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),

                const SizedBox(height: 8),

                // Diagnoses
                // if (child.diagnoses.isNotEmpty)
                //   Wrap(
                //     spacing: 6,
                //     runSpacing: -6,
                //     children: child.diagnoses
                //         .map(
                //           (d) => Chip(
                //             label: Text(d.name),
                //             backgroundColor: colorScheme.primary.withOpacity(
                //               0.1,
                //             ),
                //             labelStyle: TextStyle(
                //               color: colorScheme.primary,
                //               fontSize: 12,
                //             ),
                //             materialTapTargetSize:
                //                 MaterialTapTargetSize.shrinkWrap,
                //           ),
                //         )
                //         .toList(),
                //   )
                // else
                //   Text(
                //     "No diagnoses",
                //     style: TextStyle(
                //       fontSize: 12,
                //       color: Colors.grey[500],
                //       fontStyle: FontStyle.italic,
                //     ),
                //   ),
                OutlinedButton.icon(
                  onPressed: () => _viewChildInfo(child),
                  icon: const Icon(Icons.person, size: 18),
                  label: const Text('View details'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colorScheme.primary,
                    side: BorderSide(color: colorScheme.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _viewChildInfo(Child child) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChildDetailsScreen(child: child)),
    );

    await loadChildren();
    setState(() {});
  }

  void _addChild() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditChildScreen(
          onChildInserted: (insertedChild) async {
            await clientsChildProvider.addChildToClient(
              currenClient!.user!.userId,
              insertedChild,
            );

            await _loadClientAndChildren();

            if (mounted) {
              setState(() {});
            }
          },
        ),
      ),
    );

    loadChildren();

    setState(() {});
  }

  Future<bool> _deactivateAccount() async {
    try {
      final updatedClientRequest = ClientUpdateRequest(
        employmentStatus: null,
        user: UserUpdateRequest(status: false),
      );

      final updatedClient = await clientProvider.update(
        currenClient!.user!.userId,
        updatedClientRequest,
      );

      if (updatedClient != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Widget _buildDeactivateAccount(colorScheme) {
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
            'Deactivate Account',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Deactivating your account will make it inactive. '
            'You will no longer be able to log in, and your data will remain stored. '
            'Only an administrator can reactivate your account or permanently delete your data.',
            style: TextStyle(fontSize: 14, color: colorScheme.onSurface),
          ),
          const SizedBox(height: 16),

          PrimaryButton(
            label: 'Deactivate Account',
            icon: Icons.delete_forever,
            backgroundColor: Colors.red[600],
            onPressed: confirmDeactivation,
          ),
        ],
      ),
    );
  }

  void confirmDeactivation() async {
    final confirm = await CustomConfirmDialog.show(
      context,
      icon: Icons.warning,
      iconBackgroundColor: Colors.red,
      title: 'Deactivate Account',
      content:
          'Are you sure you want to deactivate your account?\n\n'
          'You will not be able to log in again unless an administrator reactivates your account. '
          'Permanent deletion can only be performed by an administrator.',
      confirmText: 'Deactivate',
      cancelText: 'Cancel',
    );

    if (confirm) {
      final success = await _deactivateAccount();

      if (!mounted) return;

      CustomSnackbar.show(
        context,
        message: success
            ? 'Your account has been deactivated.'
            : 'Failed to deactivate account. Please try again later.',
        type: success ? SnackbarType.success : SnackbarType.error,
      );

      final auth = Provider.of<AuthProvider>(context, listen: false);
      auth.logout();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  Widget _buildActionButtons(ColorScheme colorScheme) {
    return Column(
      children: [
        PrimaryButton(
          label: 'Edit Profile',
          isLoading: false,
          type: ButtonType.filled,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditProfileScreen(
                  client: currenClient!,
                  onUserUpdated: (updatedClient) async {
                    await clientProvider.update(
                      currenClient!.user!.userId,
                      updatedClient,
                    );

                    await _loadClientAndChildren();

                    if (mounted) {
                      setState(() {});
                    }
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

extension ProfileScreenIntegration on _ProfileScreenState {
  void navigateToEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          client: currenClient!,
          onUserUpdated: (updatedClient) async {
            await clientProvider.update(
              currenClient!.user!.userId,
              updatedClient,
            );

            if (mounted) {
              setState(() {});
            }
          },
        ),
      ),
    );
  }
}
