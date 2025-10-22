import 'package:careconnect_admin/core/layouts/master_screen.dart';
import 'package:careconnect_admin/core/theme/app_colors.dart';
import 'package:careconnect_admin/models/requests/role_insert_request.dart';
import 'package:careconnect_admin/models/responses/permission_group.dart';
import 'package:careconnect_admin/models/responses/role.dart';
import 'package:careconnect_admin/providers/role_permissions_provider.dart';
import 'package:careconnect_admin/providers/role_provider.dart';
import 'package:careconnect_admin/widgets/confirm_dialog.dart';
import 'package:careconnect_admin/widgets/no_results.dart';
import 'package:careconnect_admin/widgets/primary_button.dart';
import 'package:careconnect_admin/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RolePermissionsScreen extends StatefulWidget {
  const RolePermissionsScreen({super.key});

  @override
  State<RolePermissionsScreen> createState() => _RolePermissionsScreenState();
}

class _RolePermissionsScreenState extends State<RolePermissionsScreen> {
  List<Role> roles = [];
  Role? selectedRole;
  List<PermissionGroup> permissionGroups = [];
  Set<int> selectedPermissions = {};
  bool isLoading = true;
  bool isSaving = false;
  String searchQuery = '';
  Map<String, bool> expandedCategories = {};

  late RolePermissionsProvider rolePermissionsProvider;
  late RoleProvider roleProvider;

  @override
  void initState() {
    super.initState();

    rolePermissionsProvider = context.read<RolePermissionsProvider>();
    roleProvider = context.read<RoleProvider>();

    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    try {
      final rolesData = await rolePermissionsProvider.getRoles();
      final permissionsData = await rolePermissionsProvider
          .getGroupedPermissions();

      setState(() {
        roles = rolesData;

        permissionGroups = permissionsData;

        if (roles.isNotEmpty && selectedRole == null) {
          selectedRole = roles.first;
          selectedPermissions = Set.from(roles.first.permissionIds);
        }
        for (var group in permissionGroups) {
          expandedCategories[group.category] = true;
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      _showError('Failed to load data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return MasterScreen(
      "Role Permissions Management",
      Scaffold(
        backgroundColor: colorScheme.surfaceContainerLowest,
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Row(
                children: [
                  // Left Sidebar - Roles List
                  Container(
                    width: 350,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLowest,
                      border: Border(
                        right: BorderSide(color: Colors.grey[400]!),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Roles',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '${roles.length} total roles',
                                style: TextStyle(
                                  color: colorScheme.onSurface,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(child: _buildRoles()),
                        Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Center(
                            child: PrimaryButton(
                              onPressed: () => showRoleDialog(context),
                              label: 'Add Role',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Right Side - Permissions Panel
                  Expanded(
                    child: Column(
                      children: [
                        // Header with search and actions
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerLowest,
                            border: Border(
                              bottom: BorderSide(color: Colors.grey[200]!),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          selectedRole?.name ?? 'Select a role',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: colorScheme.primary,
                                          ),
                                        ),
                                        if (selectedRole != null) ...[
                                          SizedBox(height: 4),
                                          Text(
                                            '${selectedPermissions.length} of ${permissionGroups.fold<int>(0, (sum, group) => sum + group.permissions.length)} permissions selected',
                                            style: TextStyle(
                                              color: colorScheme.onSurface,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  TextButton(
                                    onPressed: _loadData,
                                    child: const Text('Refresh'),
                                  ),
                                  SizedBox(width: 12),
                                  PrimaryButton(
                                    onPressed: _savePermissions,
                                    label: 'Save Changes',
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              _buildSearch(),
                            ],
                          ),
                        ),

                        // Permissions List
                        Expanded(
                          child: selectedRole == null
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.shield_outlined,
                                        size: 80,
                                        color: Colors.grey[300],
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'Select a role to manage permissions',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : _buildPermissions(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildRoles() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListView.builder(
      itemCount: roles.length,
      padding: EdgeInsets.symmetric(horizontal: 12),
      itemBuilder: (context, index) {
        final role = roles[index];
        final isSelected = selectedRole?.roleId == role.roleId;
        return Container(
          margin: EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? colorScheme.secondary
                  : colorScheme.surfaceContainerLowest,
              width: 1.5,
            ),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.shield_outlined,
                color: isSelected ? Colors.white : Colors.grey[600],
              ),
            ),
            title: Text(
              role.name,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isSelected ? colorScheme.primary : colorScheme.onSurface,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (role.description != null) ...[
                  SizedBox(height: 4),
                  Text(
                    role.description!,
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: 4),
                    Text(
                      '${role.userCount} users',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.key_outlined, size: 14, color: Colors.grey[600]),
                    SizedBox(width: 4),

                    Flexible(
                      child: Text(
                        '${role.permissionIds.length} permissions',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  showRoleDialog(context, role: role);
                } else if (value == 'delete') {
                  _deleteRole(role);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                const PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
            onTap: () {
              setState(() {
                selectedRole = role;
                selectedPermissions = Set.from(role.permissionIds);
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildSearch() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: double.infinity,
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search permissions...',
          border: OutlineInputBorder(),
          labelStyle: TextStyle(color: colorScheme.onPrimaryContainer),
          prefixIcon: Icon(Icons.search),
          fillColor: colorScheme.surfaceContainerLowest,
          filled: true,
        ),
        onChanged: (value) {
          setState(() => searchQuery = value);
        },
      ),
    );
  }

  Widget _buildPermissions() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (filteredPermissionGroups.isEmpty) {
      return NoResultsWidget(message: 'No results found. Please try again.');
    }

    return ListView.builder(
      padding: EdgeInsets.all(20),
      itemCount: filteredPermissionGroups.length,
      itemBuilder: (context, index) {
        final group = filteredPermissionGroups[index];
        final isExpanded = expandedCategories[group.category] ?? true;
        final groupPermissions = group.permissions;
        final selectedCount = groupPermissions
            .where((p) => selectedPermissions.contains(p.permissionId))
            .length;
        final allSelected = selectedCount == groupPermissions.length;
        // final someSelected = selectedCount > 0 && !allSelected;

        return Container(
          margin: EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey[400]!, //change
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    expandedCategories[group.category] = !isExpanded;
                  });
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Checkbox(
                        value: allSelected,
                        tristate: true,
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              selectedPermissions.addAll(
                                groupPermissions.map((p) => p.permissionId),
                              );
                            } else {
                              selectedPermissions.removeAll(
                                groupPermissions.map((p) => p.permissionId),
                              );
                            }
                          });
                        },
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              group.category,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              '$selectedCount of ${groupPermissions.length} selected',
                              style: TextStyle(
                                fontSize: 13,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                ),
              ),
              if (isExpanded)
                Container(
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.grey[200]!)),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: groupPermissions.length,
                    itemBuilder: (context, permIndex) {
                      final permission = groupPermissions[permIndex];
                      final isSelected = selectedPermissions.contains(
                        permission.permissionId,
                      );

                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: permIndex < groupPermissions.length - 1
                                ? BorderSide(color: Colors.grey[100]!)
                                : BorderSide.none,
                          ),
                        ),
                        child: CheckboxListTile(
                          value: isSelected,
                          onChanged: (value) {
                            setState(() {
                              if (value == true) {
                                selectedPermissions.add(
                                  permission.permissionId,
                                );
                              } else {
                                selectedPermissions.remove(
                                  permission.permissionId,
                                );
                              }
                            });
                          },
                          title: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.dustyRose,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  permission.resource,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.black,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  permission.action,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Text(
                              permission.name,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                          controlAffinity: ListTileControlAffinity.trailing,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _savePermissions() async {
    if (selectedRole == null) return;

    final shouldProceed = await CustomConfirmDialog.show(
      context,
      iconBackgroundColor: AppColors.accentDeepMauve,
      icon: Icons.info,
      title: 'Edit',
      content: 'Are you sure you want to save changes?',
      confirmText: 'Save',
      cancelText: 'Cancel',
    );

    if (shouldProceed != true) return;

    setState(() => isSaving = true);
    try {
      await rolePermissionsProvider.updateRolePermissions(
        selectedRole!.roleId,
        selectedPermissions.toList(),
      );

      await _loadData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text('Permissions updated successfully'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      _showError('Failed to save permissions: $e');
    } finally {
      setState(() => isSaving = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  List<PermissionGroup> get filteredPermissionGroups {
    if (searchQuery.isEmpty) return permissionGroups;

    return permissionGroups
        .map(
          (group) => PermissionGroup(
            category: group.category,
            permissions: group.permissions
                .where(
                  (p) =>
                      p.name.toLowerCase().contains(
                        searchQuery.toLowerCase(),
                      ) ||
                      p.action.toLowerCase().contains(
                        searchQuery.toLowerCase(),
                      ) ||
                      p.resource.toLowerCase().contains(
                        searchQuery.toLowerCase(),
                      ),
                )
                .toList(),
          ),
        )
        .where((group) => group.permissions.isNotEmpty)
        .toList();
  }

  Future<void> showRoleDialog(BuildContext context, {Role? role}) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final TextEditingController nameController = TextEditingController(
      text: role?.name ?? '',
    );
    final TextEditingController descriptionController = TextEditingController(
      text: role?.description ?? '',
    );

    final formKey = GlobalKey<FormState>();

    final isEditing = role != null;

    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Role' : 'Add New Role'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 400,
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      label: RichText(
                        text: TextSpan(
                          text: 'Role Name',
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 16,
                          ),
                          children: const [
                            TextSpan(
                              text: ' *',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter role name.';
                      } else if (value.length > 20) {
                        return 'Role name must not exceed 20 characters.';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 400,
                  child: TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 16,
                      ),
                    ),
                    maxLines: 2,
                    validator: (value) {
                      if (value != null &&
                          value.isNotEmpty &&
                          value.length > 50) {
                        return 'Description must not exceed 50 characters.';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            PrimaryButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;

                Navigator.of(ctx).pop();

                final request = RoleInsertRequest(
                  name: nameController.text,
                  description: descriptionController.text.isEmpty
                      ? null
                      : descriptionController.text,
                );

                if (isEditing) {
                  // Call update API

                  try {
                    await roleProvider.update(role.roleId, request);

                    CustomSnackbar.show(
                      context,
                      message: 'Role updated successfully.',
                      type: SnackbarType.success,
                    );

                    _loadData();
                  } catch (e) {
                    if (mounted) {
                      CustomSnackbar.show(
                        context,
                        message: 'Something went wrong. Please try again.',
                        type: SnackbarType.success,
                      );
                    }
                  }
                } else {
                  try {
                    await roleProvider.insert(request);

                    CustomSnackbar.show(
                      context,
                      message: 'Successfully added new role.',
                      type: SnackbarType.success,
                    );
                    _loadData();
                  } catch (e) {
                    if (mounted) {
                      CustomSnackbar.show(
                        context,
                        message: 'Something went wrong. Please try again.',
                        type: SnackbarType.success,
                      );
                    }
                  }
                }
              },
              label: 'Save',
            ),
          ],
        );
      },
    );
  }

  void _deleteRole(Role role) async {
    final shouldProceed = await CustomConfirmDialog.show(
      context,
      icon: Icons.error,
      title: 'Delete',
      content: 'Are you sure you want to delete role?',
      confirmText: 'Delete',
      cancelText: 'Cancel',
    );

    if (shouldProceed != true) return;

    final success = await roleProvider.delete(role.roleId);

    if (success) {
      CustomSnackbar.show(
        context,
        message: 'Role deleted successfully.',
        type: SnackbarType.success,
      );
      _loadData();
    } else {
      CustomSnackbar.show(
        context,
        message: 'Something went wrong. Please try again.',
        type: SnackbarType.error,
      );
    }
  }
}
