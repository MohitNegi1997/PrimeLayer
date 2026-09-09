import 'package:equatable/equatable.dart';

class DashboardChartPoint extends Equatable {
  const DashboardChartPoint({required this.label, required this.value});

  final String label;
  final double value;

  @override
  List<Object?> get props => [label, value];
}
