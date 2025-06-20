// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rt_mobile/app/app.main.dart';
import 'package:rt_mobile/presentation/authentication/register/bloc/bloc.dart';
import 'package:rt_mobile/presentation/widgets/layouts/authentication/authen_form.dart';

class StepFourRegistrationPage extends StatelessWidget {
  const StepFourRegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthenForm(
      title: 'Đăng kí',
      child: Column(
        children: [
          const SizedBox(height: 20),
          _FullNameInput(),

          _BirthDatePicker(),

          const SizedBox(height: 10),
          _SexSelection(),

          const Spacer(),

          _NextStepButton(),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _FullNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final error = context.select<RegisterBloc, String>((bloc) {
      final state = bloc.state;

      return state is RegisterStepFour ? state.error : '';
    });

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.95,
      height: MediaQuery.of(context).size.height * 0.1,
      child: TextField(
        key: const Key('register_fullNameInput_stepFour_textField'),
        onChanged: (fullName) {
          final currentState = context.read<RegisterBloc>().state;
          final stepFourState =
              currentState is RegisterStepFour ? currentState : null;
          final birthDate = stepFourState?.birthDate ?? '';
          final sex = stepFourState?.sex ?? '';

          context.read<RegisterBloc>().add(
            RegisterInformationChanged(
              fullName: fullName,
              birthDate: birthDate,
              sex: sex,
            ),
          );
        },

        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock_rounded),
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
          labelText: 'Họ và tên',
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
      ),
    );
  }
}

class _BirthDatePicker extends StatelessWidget {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      final currentState = context.read<RegisterBloc>().state;
      final stepFourState =
          currentState is RegisterStepFour ? currentState : null;
      final fullName = stepFourState?.fullName ?? '';
      final sex = stepFourState?.sex ?? '';

      context.read<RegisterBloc>().add(
        RegisterInformationChanged(
          fullName: fullName,
          birthDate: picked.toIso8601String(),
          sex: sex,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final birthDate = context.select<RegisterBloc, String>((bloc) {
      final state = bloc.state;
      final defaultBirthDate = DateTime(2000, 1, 1).toIso8601String();

      return state is RegisterStepFour ? state.birthDate : defaultBirthDate;
    });
    final parsedDate = DateTime.tryParse(birthDate) ?? DateTime(2000, 1, 1);
    final formattedDate =
        '${parsedDate.day}-${parsedDate.month}-${parsedDate.year}';

    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today),

            const SizedBox(width: 16),

            Text(formattedDate, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

class _SexSelection extends StatelessWidget {
  void _updateSex(BuildContext context, String sex) {
    final currentState = context.read<RegisterBloc>().state;

    if (currentState is RegisterStepFour) {
      context.read<RegisterBloc>().add(
        RegisterInformationChanged(
          fullName: currentState.fullName,
          birthDate: currentState.birthDate,
          sex: sex,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final sex = context.select<RegisterBloc, String>((bloc) {
      final currentState = bloc.state;

      return currentState is RegisterStepFour ? currentState.sex : '';
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Radio(
              value: 'female',
              groupValue: sex,
              onChanged: (value) => _updateSex(context, value!),
            ),
            const Text('Nam'),
          ],
        ),
        Row(
          children: [
            Radio(
              value: 'male',
              groupValue: sex,
              onChanged: (value) => _updateSex(context, value!),
            ),
            const Text('Nữ'),
          ],
        ),
      ],
    );
  }
}

class _NextStepButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const MainApp()),
            (route) => false,
          );
        }
      },
      child: ElevatedButton(
        key: const Key('register_nextStepThree_stepFour_raisedButton'),
        onPressed: () => context.read<RegisterBloc>().add(RegisterSubmitted()),
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
            'Hoàn thành',
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
