// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rt_mobile/presentation/authentication/register/bloc/bloc.dart';
import 'package:rt_mobile/presentation/widgets/layouts/authentication/authen_form.dart';

import 'step_2.dart';

class StepOneRegistratonScreen extends StatelessWidget {
  const StepOneRegistratonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RegisterBloc>().add(RegisterReset());
    });

    return AuthenForm(
      title: 'Đăng kí',
      allowBack: true,
      child: Column(
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
    final error = context.select<RegisterBloc, String>((bloc) {
      final state = bloc.state;

      return state is RegisterError ? state.error : '';
    });

    return TextField(
      key: const Key('register_emailInput_stepOne_textField'),
      onChanged:
          (email) => context.read<RegisterBloc>().add(
            RegisterEmailChanged(email: email),
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
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterStepTwo) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (_) => BlocProvider.value(
                    value: context.read<RegisterBloc>(),
                    child: StepTwoRegistrationPage(),
                  ),
            ),
          );
        }
      },
      child: ElevatedButton(
        key: const Key('register_nextStepTwo_raisedButton'),
        onPressed:
            () => {context.read<RegisterBloc>().add(RegisterEmailSubmitted())},
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
