import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_transport_fe/bloc/bloc.export.dart';
import 'package:authentication_repository/authentication_repository.export.dart';
import 'package:rent_transport_fe/cubit/app/bottom_nav.cubit.dart';
import 'package:rent_transport_fe/global/other.dart';
import 'package:rent_transport_fe/views/authentication/login/login.export.dart';
import 'package:user_repository/user_repository.export.dart';

import '../views/home/page.dart';

part 'app.view.dart';
part 'app.router.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final AuthenticationRepository _authenticationRepository;
  late final UserRepository _userRepository;

  @override
  void initState() {
    super.initState();

    _authenticationRepository = AuthenticationRepository();
    _userRepository = UserRepository();
  }

  @override
  void dispose() {
    _authenticationRepository.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /** 
      RepositoryProvider is a Flutter BLoC "InheritableWidget",
      used to provide a repository for the child widget tree.
    */
    return RepositoryProvider.value(
      value: _authenticationRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            lazy: false,
            create:
                (_) => AuthenticationBloc(
                  authenticationRepository: _authenticationRepository,
                  userRepository: _userRepository,
                )..add(AuthenticationSubscriptionRequested()),
          ),
          BlocProvider(
            create:
                (_) => LoginBloc(
                  authenticationRepository: _authenticationRepository,
                ),
          ),
          BlocProvider(create: (_) => RegisterBloc()),
        ],
        child: AppRouter(),
      ),
    );
  }
}
