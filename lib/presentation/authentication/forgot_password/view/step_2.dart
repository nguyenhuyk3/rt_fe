// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rt_mobile/core/constants/others.dart';
import 'package:rt_mobile/core/utils/ticker/ticker.dart';
import 'package:rt_mobile/presentation/authentication/forgot_password/bloc/bloc.dart';
import 'package:rt_mobile/presentation/authentication/timer/bloc/bloc.dart';
import 'package:rt_mobile/presentation/widgets/layouts/authentication/authen_form.dart';

import 'step_3.dart';

class StepTwoForgotPasswordPage extends StatelessWidget {
  const StepTwoForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthenForm(
      title: 'Quên mật khẩu',
      allowBack: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                flex: 3, // 60%
                child: _OtpInput(),
              ),

              const SizedBox(width: 10),

              Expanded(
                flex: 2, // 40%
                child: _ResendOtpButton(),
              ),
            ],
          ),

          const Spacer(),

          _NextStepButton(),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _OtpInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final error = context.select<ForgotPasswordBloc, String>((bloc) {
      final state = bloc.state;

      return state is ForgotPasswordError ? state.error : '';
    });

    return TextField(
      key: const Key('forgotPassword_otpInput_stepTwo_textField'),
      onChanged:
          (otp) => context.read<ForgotPasswordBloc>().add(
            ForgotPasswordOtpChanged(otp: otp),
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
        labelText: 'OTP',
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

class _ResendOtpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              TimerBloc(ticker: Ticker())
                ..add(TimerStarted(duration: TIME_FOR_RESENDING_MAIL)),
      child: BlocBuilder<TimerBloc, TimerState>(
        builder: (context, state) {
          final isDisabled = state is TimerRunInProgress;
          final timeLeft = state.duration;

          return ElevatedButton(
            key: const Key('forgotPassword_resendOtp_stepTwo_raisedButton'),
            onPressed:
                isDisabled
                    ? null
                    : () {
                      context.read<TimerBloc>().add(
                        TimerStarted(duration: TIME_FOR_RESENDING_MAIL),
                      );
                    },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                isDisabled
                    ? Colors.yellowAccent.withOpacity(0.5)
                    : Colors.yellowAccent,
              ),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Colors.transparent, width: 1),
                ),
              ),
              minimumSize: WidgetStateProperty.all(
                Size(
                  double.infinity,
                  MediaQuery.of(context).size.height * 0.068,
                ),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(4),
              child: Text(
                isDisabled ? '${timeLeft}s' : 'Gửi lại',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
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
    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordStepThree) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (_) => BlocProvider.value(
                    value: context.read<ForgotPasswordBloc>(),
                    child: StepThreeForgotPasswordPage(),
                  ),
            ),
          );
        }
      },
      child: ElevatedButton(
        key: const Key('forgotPassword_nextStepThree_stepTwo_raisedButton'),
        onPressed:
            () => context.read<ForgotPasswordBloc>().add(
              ForgotPasswordOtpSubmitted(),
            ),
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
            'Xác thực mã OTP',
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
