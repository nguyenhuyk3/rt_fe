import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rt_mobile/core/constants/others.dart';
import 'package:rt_mobile/data/repositories/authentication.dart';
import 'package:rt_mobile/presentation/authentication/login/bloc/bloc.dart';
import 'package:rt_mobile/presentation/authentication/login/view/form.dart';

class LoginScreen extends StatelessWidget {
  final bool loginRequired;

  const LoginScreen({super.key, this.loginRequired = false});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => LoginBloc(
            authenticationRepository: context.read<AuthenticationRepository>(),
          ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _AppBar(),
        body: Padding(padding: EdgeInsets.all(12), child: LoginForm()),
      ),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Đăng nhập',
        style: TextStyle(
          color: Colors.white,
          fontSize: HEADER_SIZE,
          fontWeight: FontWeight.w400,
        ),
      ),
      automaticallyImplyLeading: false,
      centerTitle: true,
      elevation: 0.7,
      shadowColor: Color(0xFFEFF3EA),
      backgroundColor: Colors.black,
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(0.1),
        child: Divider(height: 0.1, thickness: 0.1, color: Colors.grey),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
