import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

class LoaderCubit extends Cubit<double> {
  LoaderCubit() : super(0) {
    _timer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      const step = 0.02;
      final next = state + step;
      emit(next >= 1 ? 0.0 : next);
    });
  }

  late final Timer _timer;

  @override
  Future<void> close() {
    _timer.cancel();
    return super.close();
  }
}
