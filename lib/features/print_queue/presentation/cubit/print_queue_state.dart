import 'package:equatable/equatable.dart';
import 'package:primelayer_admin_panel/core/pagination/page_slice.dart';
import 'package:primelayer_admin_panel/features/print_queue/domain/print_job.dart';
import 'package:primelayer_admin_panel/features/print_queue/domain/print_job_status.dart';

class PrintQueueState extends Equatable {
  const PrintQueueState({
    required this.jobs,
    this.query = '',
    this.status,
    this.page = 0,
    this.notice,
  });

  final List<PrintJob> jobs;
  final String query;
  final PrintJobStatus? status;
  final int page;
  final String? notice;

  List<PrintJob> get filteredJobs {
    final needle = query.trim().toLowerCase();
    return [
      for (final job in jobs)
        if (_matches(job, needle)) job,
    ];
  }

  int get safePage => PageSlice.clampPage(page, filteredJobs.length);

  List<PrintJob> get pagedJobs => PageSlice.of(filteredJobs, safePage);

  bool _matches(PrintJob job, String needle) {
    if (status != null && job.status != status) return false;
    if (needle.isEmpty) return true;
    return job.orderNumber.toLowerCase().contains(needle) ||
        job.productName.toLowerCase().contains(needle) ||
        job.printer.toLowerCase().contains(needle);
  }

  PrintQueueState copyWith({
    List<PrintJob>? jobs,
    String? query,
    PrintJobStatus? status,
    int? page,
    String? notice,
    bool clearStatus = false,
    bool clearNotice = false,
  }) {
    return PrintQueueState(
      jobs: jobs ?? this.jobs,
      query: query ?? this.query,
      status: clearStatus ? null : status ?? this.status,
      page: page ?? this.page,
      notice: clearNotice ? null : notice ?? this.notice,
    );
  }

  @override
  List<Object?> get props => [jobs, query, status, page, notice];
}
