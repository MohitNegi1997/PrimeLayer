import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/core/constants/app_constants.dart';

class SplashCubit extends Cubit<bool> {
  SplashCubit() : super(false) {
    _timer = Timer(AppConstants.splashDuration, () {
      if (!isClosed) emit(true);
    });
  }

  late final Timer _timer;

  @override
  Future<void> close() {
    _timer.cancel();
    return super.close();
  }
}
