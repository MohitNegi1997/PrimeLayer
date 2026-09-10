import 'package:equatable/equatable.dart';
import 'package:primelayer_admin_panel/features/print_queue/domain/print_job_status.dart';

class PrintJob extends Equatable {
  const PrintJob({
    required this.id,
    required this.orderId,
    required this.orderNumber,
    required this.productName,
    required this.printer,
    required this.status,
    required this.queuedAt,
  });

  final String id;
  final String orderId;
  final String orderNumber;
  final String productName;
  final String printer;
  final PrintJobStatus status;
  final DateTime queuedAt;

  PrintJob copyWith({
    String? id,
    String? orderId,
    String? orderNumber,
    String? productName,
    String? printer,
    PrintJobStatus? status,
    DateTime? queuedAt,
  }) {
    return PrintJob(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      orderNumber: orderNumber ?? this.orderNumber,
      productName: productName ?? this.productName,
      printer: printer ?? this.printer,
      status: status ?? this.status,
      queuedAt: queuedAt ?? this.queuedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    orderId,
    orderNumber,
    productName,
    printer,
    status,
    queuedAt,
  ];
}
