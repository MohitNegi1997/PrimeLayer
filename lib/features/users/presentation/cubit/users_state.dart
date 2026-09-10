import 'package:equatable/equatable.dart';
import 'package:primelayer_admin_panel/features/users/domain/staff_role.dart';
import 'package:primelayer_admin_panel/features/users/domain/staff_user.dart';

class UsersState extends Equatable {
  const UsersState({required this.users, this.query = '', this.notice});

  final List<StaffUser> users;
  final String query;
  final String? notice;

  List<StaffUser> get filteredUsers {
    final needle = query.trim().toLowerCase();
    if (needle.isEmpty) return users;
    return [
      for (final user in users)
        if (user.name.toLowerCase().contains(needle) ||
            user.email.toLowerCase().contains(needle))
          user,
    ];
  }

  int get adminCount {
    var count = 0;
    for (final user in users) {
      if (user.role == StaffRole.admin) count += 1;
    }
    return count;
  }

  UsersState copyWith({
    List<StaffUser>? users,
    String? query,
    String? notice,
    bool clearNotice = false,
  }) {
    return UsersState(
      users: users ?? this.users,
      query: query ?? this.query,
      notice: clearNotice ? null : notice ?? this.notice,
    );
  }

  @override
  List<Object?> get props => [users, query, notice];
}
