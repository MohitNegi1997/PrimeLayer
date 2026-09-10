import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/features/print_queue/data/print_queue_seed.dart';
import 'package:primelayer_admin_panel/features/print_queue/domain/print_job.dart';
import 'package:primelayer_admin_panel/features/print_queue/domain/print_job_status.dart';
import 'package:primelayer_admin_panel/features/print_queue/presentation/cubit/print_queue_state.dart';

class PrintQueueCubit extends Cubit<PrintQueueState> {
  PrintQueueCubit() : super(PrintQueueState(jobs: PrintQueueSeed.jobs));

  void searchChanged(String query) {
    emit(state.copyWith(query: query, page: 0, clearNotice: true));
  }

  void statusChanged(PrintJobStatus? status) {
    emit(
      state.copyWith(
        status: status,
        clearStatus: status == null,
        page: 0,
        clearNotice: true,
      ),
    );
  }

  void pageChanged(int page) {
    emit(state.copyWith(page: page, clearNotice: true));
  }

  void clearNotice() {
    emit(state.copyWith(clearNotice: true));
  }

  void updateStatus(String id, PrintJobStatus status) {
    emit(
      state.copyWith(
        jobs: [
          for (final job in state.jobs)
            if (job.id == id) job.copyWith(status: status) else job,
        ],
        notice: 'Print job updated',
      ),
    );
  }

  void save(PrintJob job) {
    final items = [...state.jobs];
    final index = items.indexWhere((item) => item.id == job.id);
    if (index == -1) {
      items.insert(0, job);
    } else {
      items[index] = job;
    }
    emit(state.copyWith(jobs: items, notice: '${job.orderNumber} queued'));
  }
}
