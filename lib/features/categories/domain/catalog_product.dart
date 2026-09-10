import 'package:equatable/equatable.dart';

class CatalogProduct extends Equatable {
  const CatalogProduct({required this.id, required this.name});

  final String id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}
