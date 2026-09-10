import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_chip_tone.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_list_scaffold.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_row_menu.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_search_field.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_stat_metric.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_table_column.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_text_cell.dart';
import 'package:primelayer_admin_panel/core/widgets/confirm_delete_dialog.dart';
import 'package:primelayer_admin_panel/core/widgets/status_chip.dart';
import 'package:primelayer_admin_panel/features/users/domain/staff_role.dart';
import 'package:primelayer_admin_panel/features/users/domain/staff_user.dart';
import 'package:primelayer_admin_panel/features/users/presentation/cubit/users_cubit.dart';
import 'package:primelayer_admin_panel/features/users/presentation/cubit/users_state.dart';
import 'package:primelayer_admin_panel/features/users/presentation/widgets/staff_editor_dialog.dart';

class UsersView extends StatelessWidget {
  const UsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<UsersCubit, UsersState>(
      listenWhen: (previous, current) => current.notice != null,
      listener: (context, state) {
        final notice = state.notice;
        if (notice == null) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(notice)));
        context.read<UsersCubit>().clearNotice();
      },
      child: BlocBuilder<UsersCubit, UsersState>(
        builder: (context, state) {
          final items = state.filteredUsers;
          var active = 0;
          var admins = 0;
          for (final user in state.users) {
            if (user.isActive) active += 1;
            if (user.role == StaffRole.admin) admins += 1;
          }
          return AdminListScaffold(
            title: 'User management',
            subtitle: 'Staff accounts that can sign in to this admin panel.',
            actions: [
              ElevatedButton.icon(
                onPressed: () => StaffEditorDialog.open(context),
                icon: const Icon(Icons.add),
                label: const Text('Add user'),
              ),
            ],
            stats: [
              AdminStatMetric(
                label: 'Total users',
                value: '${state.users.length}',
                caption: 'Staff',
                icon: Icons.group_outlined,
              ),
              AdminStatMetric(
                label: 'Admins',
                value: '$admins',
                caption: 'Full access',
                icon: Icons.verified_user_outlined,
                tone: AdminChipTone.info,
              ),
              AdminStatMetric(
                label: 'Active',
                value: '$active',
                caption: 'Can sign in',
                icon: Icons.check_circle_outline,
                tone: AdminChipTone.success,
              ),
              AdminStatMetric(
                label: 'Inactive',
                value: '${state.users.length - active}',
                caption: 'Paused',
                icon: Icons.pause_circle_outline,
                tone: AdminChipTone.muted,
              ),
            ],
            filters: [
              AdminSearchField(
                hint: 'Search by name or email',
                onChanged: context.read<UsersCubit>().searchChanged,
              ),
            ],
            columns: const [
              AdminTableColumn(label: 'Name', flex: 2),
              AdminTableColumn(label: 'Email', flex: 3),
              AdminTableColumn(label: 'Role'),
              AdminTableColumn(label: 'Status'),
              AdminTableColumn(label: 'Actions', flex: 1),
            ],
            rowCount: items.length,
            cells: (index) => _cells(context, items[index]),
            onRowTap: (index) =>
                StaffEditorDialog.open(context, user: items[index]),
            emptyLabel: 'No matching users',
            page: 0,
            total: items.length,
            onPageChanged: (_) {},
          );
        },
      ),
    );
  }

  List<Widget> _cells(BuildContext context, StaffUser user) {
    return [
      AdminTextCell(user.name, emphasis: true),
      AdminTextCell(user.email),
      AdminTextCell(user.role.label),
      StatusChip(
        label: user.isActive ? 'Active' : 'Inactive',
        tone: user.isActive ? AdminChipTone.success : AdminChipTone.muted,
      ),
      AdminRowMenu(
        onSelected: (value) {
          switch (value) {
            case 'edit':
              StaffEditorDialog.open(context, user: user);
            case 'delete':
              ConfirmDeleteDialog.open(
                context,
                title: 'Delete ${user.name}?',
                message: 'This cannot be undone.',
                onConfirm: () => context.read<UsersCubit>().delete(user.id),
              );
          }
        },
        items: const [
          PopupMenuItem(value: 'edit', child: Text('Edit')),
          PopupMenuItem(value: 'delete', child: Text('Delete')),
        ],
      ),
    ];
  }
}
