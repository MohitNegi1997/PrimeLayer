import 'package:primelayer_admin_panel/features/auth/data/admin_credentials.dart';
import 'package:primelayer_admin_panel/features/users/domain/staff_role.dart';
import 'package:primelayer_admin_panel/features/users/domain/staff_user.dart';

abstract final class UsersSeed {
  static const List<StaffUser> users = [
    StaffUser(
      id: 'u-admin',
      name: AdminCredentials.displayName,
      email: AdminCredentials.email,
      role: StaffRole.admin,
      isActive: true,
    ),
    StaffUser(
      id: 'u-manager',
      name: 'Riya Kapoor',
      email: 'riya.kapoor@primelayer.studio',
      role: StaffRole.manager,
      isActive: true,
    ),
    StaffUser(
      id: 'u-support',
      name: 'Amit Rao',
      email: 'amit.rao@primelayer.studio',
      role: StaffRole.support,
      isActive: true,
    ),
    StaffUser(
      id: 'u-print',
      name: 'Leela Das',
      email: 'leela.das@primelayer.studio',
      role: StaffRole.support,
      isActive: false,
    ),
  ];
}
