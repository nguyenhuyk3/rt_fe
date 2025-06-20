// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rt_mobile/core/constants/errors.dart';
import 'package:rt_mobile/presentation/authentication/password/bloc/bloc.dart';
import 'package:rt_mobile/presentation/authentication/register/bloc/bloc.dart';
import 'package:rt_mobile/presentation/widgets/layouts/authentication/authen_form.dart';

import 'step_4.dart';

class StepThreeRegistrationPage extends StatelessWidget {
  const StepThreeRegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthenForm(
      title: 'Đăng kí',
      child: Column(
        children: [
          const SizedBox(height: 20),
          _PasswordInput(),

          _ConfirmedPasswordInput(),

          const Spacer(),

          _NextStepButton(),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final error = context.select<RegisterBloc, String>((bloc) {
      final state = bloc.state;

      return state is RegisterStepThree ? state.error : '';
    });

    return BlocProvider(
      create: (context) => PasswordBloc(),
      child: BlocBuilder<PasswordBloc, PasswordState>(
        builder: (context, state) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.height * 0.1,
            child: TextField(
              key: const Key('register_passwordInput_stepThree_textField'),
              onChanged: (password) {
                final currentState = context.read<RegisterBloc>().state;
                final confirmedPassword =
                    (currentState as RegisterStepThree?)?.confirmedPassword ??
                    '';

                context.read<RegisterBloc>().add(
                  RegisterPasswordChanged(
                    password: password,
                    confirmedPassword: confirmedPassword,
                  ),
                );
              },
              obscureText: state.obscureText,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock_rounded),
                suffixIcon: IconButton(
                  icon: Icon(
                    state.obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    context.read<PasswordBloc>().add(
                      PasswordToggleVisibility(),
                    );
                  },
                ),
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
                  borderSide: const BorderSide(
                    color: Colors.redAccent,
                    width: 1,
                  ),
                ),
                labelText: 'Mật khẩu',
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
                    (error.isEmpty ||
                            error == CONFIRMATION_PASSWORD_MISMATCH_ERROR ||
                            error == EMPTY_CONFIRMED_PASSWORD_ERROR)
                        ? null
                        : error,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ConfirmedPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final error = context.select<RegisterBloc, String>((bloc) {
      final currentState = bloc.state;

      return currentState is RegisterStepThree ? currentState.error : '';
    });

    return BlocProvider(
      create: (context) => PasswordBloc(),
      child: BlocBuilder<PasswordBloc, PasswordState>(
        builder: (context, state) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.height * 0.1,
            child: TextField(
              key: const Key(
                'register_confirmedPasswordInput_stepThree_textField',
              ),
              onChanged: (confirmedPassword) {
                final currentState = context.read<RegisterBloc>().state;
                final password =
                    (currentState as RegisterStepThree?)?.password.value ?? '';

                context.read<RegisterBloc>().add(
                  RegisterPasswordChanged(
                    password: password,
                    confirmedPassword: confirmedPassword,
                  ),
                );
              },
              obscureText: state.obscureText,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.check_circle_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    state.obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    context.read<PasswordBloc>().add(
                      PasswordToggleVisibility(),
                    );
                  },
                ),
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
                  borderSide: const BorderSide(
                    color: Colors.redAccent,
                    width: 1,
                  ),
                ),
                labelText: 'Xác nhận mật khẩu',
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
                    (error.isEmpty || error == PASSWORD_CAN_NOT_BE_BLANK)
                        ? null
                        : error,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NextStepButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterStepFour) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (_) => BlocProvider.value(
                    value: context.read<RegisterBloc>(),
                    child: StepFourRegistrationPage(),
                  ),
            ),
          );
        }
      },
      child: ElevatedButton(
        key: const Key('register_nextStepThree_stepThree_raisedButton'),
        onPressed:
            () => context.read<RegisterBloc>().add(RegisterPasswordSubmitted()),
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
            'Xác nhận mật khẩu',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
