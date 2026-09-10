import 'package:equatable/equatable.dart';

class Customer extends Equatable {
  const Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.city,
    required this.joinedAt,
  });

  final String id;
  final String name;
  final String email;
  final String phone;
  final String city;
  final DateTime joinedAt;

  Customer copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? city,
    DateTime? joinedAt,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }

  @override
  List<Object?> get props => [id, name, email, phone, city, joinedAt];
}
