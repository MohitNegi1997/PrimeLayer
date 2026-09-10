enum StaffRole {
  admin,
  manager,
  support;

  String get label => switch (this) {
    StaffRole.admin => 'Admin',
    StaffRole.manager => 'Manager',
    StaffRole.support => 'Support',
  };
}
