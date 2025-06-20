import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rt_mobile/core/constants/others.dart';

class AuthCubit extends Cubit<bool> {
  AuthCubit() : super(false);

  Future<void> checkAuthStatus() async {
    final accessToken = await storage.read(ACCESS_TOKEN);

    if (accessToken == null || accessToken.isEmpty) {
      emit(false);

      return;
    }

    emit(true);
  }

  void login() {
    emit(true);
  }

  void logout() async {
    await storage.delete(ACCESS_TOKEN);

    emit(false);
  }
}
