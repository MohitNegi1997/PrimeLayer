import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/features/users/data/users_seed.dart';
import 'package:primelayer_admin_panel/features/users/domain/staff_role.dart';
import 'package:primelayer_admin_panel/features/users/domain/staff_user.dart';
import 'package:primelayer_admin_panel/features/users/presentation/cubit/users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  UsersCubit() : super(const UsersState(users: UsersSeed.users));

  void searchChanged(String query) {
    emit(state.copyWith(query: query, clearNotice: true));
  }

  void clearNotice() {
    emit(state.copyWith(clearNotice: true));
  }

  void save(StaffUser user) {
    final items = [...state.users];
    final index = items.indexWhere((item) => item.id == user.id);
    if (index == -1) {
      items.add(user);
    } else {
      items[index] = user;
    }
    emit(state.copyWith(users: items, notice: '${user.name} saved'));
  }

  void delete(String id) {
    final matches = state.users.where((item) => item.id == id);
    if (matches.isEmpty) return;
    final user = matches.first;
    if (user.role == StaffRole.admin && state.adminCount <= 1) {
      emit(state.copyWith(notice: 'Keep at least one admin'));
      return;
    }
    emit(
      state.copyWith(
        users: [
          for (final item in state.users)
            if (item.id != id) item,
        ],
        notice: '${user.name} deleted',
      ),
    );
  }
}
