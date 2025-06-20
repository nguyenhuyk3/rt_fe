// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rt_mobile/presentation/authentication/forgot_password/bloc/bloc.dart';
import 'package:rt_mobile/presentation/authentication/forgot_password/view/step_2.dart';
import 'package:rt_mobile/presentation/widgets/layouts/authentication/authen_form.dart';

class StepOneForgotPasswordPage extends StatelessWidget {
  const StepOneForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthenForm(
      title: 'Quên mật khẩu',
      allowBack: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          
          _EmailInput(),

          const Spacer(),

          _NextStepButton(),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final error = context.select<ForgotPasswordBloc, String>((bloc) {
      final state = bloc.state;

      return state is ForgotPasswordError ? state.error : '';
    });

    return TextField(
      key: const Key('forgotPassword_emailInput_stepOne_textField'),
      onChanged:
          (email) => context.read<ForgotPasswordBloc>().add(
            ForgotPasswordEmailChanged(email: email),
          ),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.email_outlined),
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
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
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
        errorText: error.isEmpty ? null : error,
      ),
    );
  }
}

class _NextStepButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) async {
        if (state is ForgotPasswordStepTwo) {
          await Future.delayed(Duration(milliseconds: 800));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (_) => BlocProvider.value(
                    value: context.read<ForgotPasswordBloc>(),
                    child: StepTwoForgotPasswordPage(),
                  ),
            ),
          );
        }
      },
      child: ElevatedButton(
        key: const Key('forgotPassword_nextStepTwo_stepOne_raisedButton'),
        onPressed:
            () => {
              context.read<ForgotPasswordBloc>().add(
                ForgotPasswordEmailSubmitted(),
              ),
            },
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
            'Gửi mã xác thực OTP',
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
