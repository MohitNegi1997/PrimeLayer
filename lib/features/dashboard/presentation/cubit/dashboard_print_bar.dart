import 'package:equatable/equatable.dart';

class DashboardPrintBar extends Equatable {
  const DashboardPrintBar({
    required this.label,
    required this.queued,
    required this.printing,
    required this.failed,
  });

  final String label;
  final double queued;
  final double printing;
  final double failed;

  double get total => queued + printing + failed;

  @override
  List<Object?> get props => [label, queued, printing, failed];
}
