import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/features/payments/data/payments_seed.dart';
import 'package:primelayer_admin_panel/features/payments/domain/payment_status.dart';
import 'package:primelayer_admin_panel/features/payments/presentation/cubit/payments_state.dart';

class PaymentsCubit extends Cubit<PaymentsState> {
  PaymentsCubit() : super(PaymentsState(payments: PaymentsSeed.payments));

  void searchChanged(String query) {
    emit(state.copyWith(query: query, page: 0, clearNotice: true));
  }

  void statusChanged(PaymentStatus? status) {
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

  void updateStatus(String id, PaymentStatus status) {
    emit(
      state.copyWith(
        payments: [
          for (final payment in state.payments)
            if (payment.id == id) payment.copyWith(status: status) else payment,
        ],
        notice: 'Payment updated',
      ),
    );
  }
}
