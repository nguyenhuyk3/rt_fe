import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:formz/formz.dart';
import 'package:rt_mobile/app/app.main.dart';

import 'package:rt_mobile/core/utils/validator/validation_error_message.dart';
import 'package:rt_mobile/presentation/authentication/forgot_password/view/step_1.dart';
import 'package:rt_mobile/presentation/authentication/login/bloc/bloc.dart';
import 'package:rt_mobile/presentation/authentication/password/bloc/bloc.dart';
import 'package:rt_mobile/presentation/authentication/register/view/step_1.dart';
import 'package:rt_mobile/presentation/widgets/snack_bar.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) async {
        if (state.status.isFailure) {
          showCustomSnackBar(
            context: context,
            isSuccess: false,
            message: 'Đăng nhập thất bại!!',
          );
        } else if (state.status.isSuccess) {
          showCustomSnackBar(
            context: context,
            isSuccess: true,
            message: 'Đăng nhập thành công!!',
          );

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => AppView()),
            (Route<dynamic> route) => false,
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Information fields
          const SizedBox(height: 20),

          _EmailInput(),

          const SizedBox(height: 20),

          _PasswordInput(),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [_ForgotPasswordButton()],
          ),

          const Divider(thickness: 0.5, color: Colors.grey),

          const SizedBox(height: 20),

          // Other login methods
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_FacebookLoginButton(), _GoogleLoginButton()],
          ),

          const SizedBox(height: 20),

          _RegistrationButton(),

          Spacer(),

          _LoginButton(),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final email = context.select((LoginBloc bloc) => bloc.state.email);
    final error = context.select((LoginBloc bloc) => bloc.state.error);

    return TextField(
      key: const Key('loginForm_accountInput_textField'),
      onChanged: (email) {
        context.read<LoginBloc>().add(LoginEmailChanged(email: email));
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.email_outlined),
        // Border when not focused
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        // Border when focused
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        // Border when error
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        labelText: 'Email',
        labelStyle: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        // When label is focused (floating)
        floatingLabelStyle: TextStyle(
          color: error.isEmpty ? Colors.yellowAccent : Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        errorText:
            error.isEmpty
                ? null
                : ValidationErrorMessage.getEmailErrorMessage(
                  error: email.error,
                ),
      ),
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final password = context.select((LoginBloc bloc) => bloc.state.password);
    final error = context.select((LoginBloc bloc) => bloc.state.error);

    return BlocProvider(
      create: (context) => PasswordBloc(),
      child: BlocBuilder<PasswordBloc, PasswordState>(
        builder: (context, state) {
          return TextField(
            key: const Key('loginForm_passwordInput_textField'),
            onChanged: (password) {
              context.read<LoginBloc>().add(
                LoginPasswordChanged(password: password),
              );
            },
            obscureText: state.obscureText,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.lock_rounded,
                color: Colors.white, // Tùy chỉnh màu icon
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  state.obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white, // Màu icon toggle
                ),
                onPressed: () {
                  context.read<PasswordBloc>().add(PasswordToggleVisibility());
                },
              ),
              labelText: 'Mật khẩu',
              labelStyle: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              floatingLabelStyle: TextStyle(
                color: error.isEmpty ? Colors.yellowAccent : Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.red, width: 1),
              ),
              errorText:
                  error.isEmpty
                      ? null
                      : ValidationErrorMessage.getPasswordErrorMessage(
                        error: password.error,
                      ),
            ),
          );
        },
      ),
    );
  }
}

class _ForgotPasswordButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StepOneForgotPasswordPage()),
        );
      },
      child: const Text(
        'Quên mật khẩu?',
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _RegistrationButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Bạn chưa là thành viên?',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const StepOneRegistratonScreen(),
              ),
            );
          },
          child: const Text(
            'Hãy đăng ký',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final isInProgressOrSuccess = context.select(
    //   (LoginBloc bloc) => bloc.state.status.isInProgressOrSuccess,
    // );

    // if (isInProgressOrSuccess) return const CircularProgressIndicator();

    final error = context.select((LoginBloc bloc) => bloc.state.error);

    return ElevatedButton(
      key: const Key('loginForm_continue_raisedButton'),
      onPressed:
          error.isEmpty
              ? () => context.read<LoginBloc>().add(const LoginSubmitted())
              : null,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(Colors.yellowAccent),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: const BorderSide(color: Colors.transparent, width: 1),
          ),
        ),
        minimumSize: WidgetStateProperty.all(
          Size(double.infinity, MediaQuery.of(context).size.height * 0.06),
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.all(4),
        child: Text(
          'Đăng nhập',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _FacebookLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      key: const Key('loginForm_facebook_login'),
      onPressed: () => {},
      style: ButtonStyle(
        shadowColor: WidgetStateProperty.all(Colors.transparent),
        elevation: WidgetStateProperty.all(0),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: const BorderSide(color: Color(0xFFBCCCDC), width: 1),
          ),
        ),
        minimumSize: WidgetStateProperty.all(
          Size(
            MediaQuery.of(context).size.width * 0.455,
            MediaQuery.of(context).size.height * 0.05,
          ),
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.all(3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.facebook, color: Colors.blueAccent, size: 25),
            SizedBox(width: 12.0),
            Text(
              'Facebook',
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      key: const Key('loginForm_google_login'),
      onPressed: () => {},
      style: ButtonStyle(
        shadowColor: WidgetStateProperty.all(Colors.transparent),
        elevation: WidgetStateProperty.all(0),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: const BorderSide(color: Color(0xFFBCCCDC), width: 1),
          ),
        ),
        minimumSize: WidgetStateProperty.all(
          Size(
            MediaQuery.of(context).size.width * 0.45,
            MediaQuery.of(context).size.height * 0.05,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset('assets/icons/google_logo.svg', height: 24.0),
            SizedBox(width: 12.0),
            Text(
              'Google',
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
