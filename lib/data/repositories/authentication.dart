import 'dart:async';

import 'package:rt_mobile/core/constants/others.dart';
import 'package:rt_mobile/data/models/api_response.dart';
import 'package:rt_mobile/data/services/authentication/login.dart';
import 'package:rt_mobile/data/services/authentication/register.dart';

class AuthenticationRepository {
  final RegisterService registerService;
  final LoginService loginService;

  AuthenticationRepository({
    required this.registerService,
    required this.loginService,
  });

  Future<APIReponse> sendRegistrationOtp({required String email}) {
    return registerService.sendRegistrationOtp(email: email);
  }

  Future<APIReponse> verifyRegistrationOtp({
    required String email,
    required String otp,
  }) {
    return registerService.verifyRegistrationOtp(email: email, otp: otp);
  }

  Future<APIReponse> completeRegistration({
    required Map<String, dynamic> request,
  }) {
    return registerService.completeRegistration(resquest: request);
  }

  Future<APIReponse> logIn({
    required String email,
    required String password,
  }) async {
    final response = await loginService.logIn(email: email, password: password);

    if (response.statusCode == 200) {
      await storage.write(ACCESS_TOKEN, response.data[ACCESS_TOKEN]);
      await storage.write(REFRESH_TOKEN, response.data[REFRESH_TOKEN]);
      await storage.write(EMAIL, response.data['access_payload'][EMAIL]);
    }

    return APIReponse(statusCode: response.statusCode);
  }
}
