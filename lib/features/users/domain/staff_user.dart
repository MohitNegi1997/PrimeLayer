import 'package:equatable/equatable.dart';
import 'package:primelayer_admin_panel/features/users/domain/staff_role.dart';

class StaffUser extends Equatable {
  const StaffUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isActive,
  });

  final String id;
  final String name;
  final String email;
  final StaffRole role;
  final bool isActive;

  StaffUser copyWith({
    String? id,
    String? name,
    String? email,
    StaffRole? role,
    bool? isActive,
  }) {
    return StaffUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [id, name, email, role, isActive];
}
