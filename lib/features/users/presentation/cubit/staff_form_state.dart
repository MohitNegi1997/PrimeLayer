import 'package:equatable/equatable.dart';
import 'package:primelayer_admin_panel/features/users/domain/staff_role.dart';
import 'package:primelayer_admin_panel/features/users/domain/staff_user.dart';

enum StaffFormStatus { initial, success }

class StaffFormState extends Equatable {
  const StaffFormState({
    this.id,
    this.name = '',
    this.email = '',
    this.role = StaffRole.support,
    this.isActive = true,
    this.status = StaffFormStatus.initial,
    this.errorMessage,
  });

  final String? id;
  final String name;
  final String email;
  final StaffRole role;
  final bool isActive;
  final StaffFormStatus status;
  final String? errorMessage;

  StaffUser toUser() {
    return StaffUser(
      id: id ?? 'u-${DateTime.now().microsecondsSinceEpoch}',
      name: name.trim(),
      email: email.trim(),
      role: role,
      isActive: isActive,
    );
  }

  StaffFormState copyWith({
    String? id,
    String? name,
    String? email,
    StaffRole? role,
    bool? isActive,
    StaffFormStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return StaffFormState(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      status: status ?? this.status,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [id, name, email, role, isActive, status, errorMessage];
}
