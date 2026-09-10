import 'package:equatable/equatable.dart';
import 'package:primelayer_admin_panel/features/customers/domain/customer.dart';

enum CustomerFormStatus { initial, success }

class CustomerFormState extends Equatable {
  const CustomerFormState({
    this.id,
    this.name = '',
    this.email = '',
    this.phone = '',
    this.city = '',
    this.joinedAt,
    this.status = CustomerFormStatus.initial,
    this.errorMessage,
  });

  final String? id;
  final String name;
  final String email;
  final String phone;
  final String city;
  final DateTime? joinedAt;
  final CustomerFormStatus status;
  final String? errorMessage;

  bool get isEditing => id != null;

  Customer toCustomer() {
    return Customer(
      id: id ?? 'c-${DateTime.now().microsecondsSinceEpoch}',
      name: name.trim(),
      email: email.trim(),
      phone: phone.trim(),
      city: city.trim(),
      joinedAt: joinedAt ?? DateTime.now(),
    );
  }

  CustomerFormState copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? city,
    DateTime? joinedAt,
    CustomerFormStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CustomerFormState(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      joinedAt: joinedAt ?? this.joinedAt,
      status: status ?? this.status,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    city,
    joinedAt,
    status,
    errorMessage,
  ];
}
