import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rt_mobile/core/constants/others.dart';
import 'package:rt_mobile/data/repositories/authentication.dart';
import 'package:rt_mobile/data/repositories/cinema.dart';
import 'package:rt_mobile/data/repositories/fab_repository.dart';
import 'package:rt_mobile/data/repositories/film.dart';
import 'package:rt_mobile/data/repositories/order.dart';
import 'package:rt_mobile/data/repositories/payment.dart';
import 'package:rt_mobile/data/repositories/showtime.dart';
import 'package:rt_mobile/data/services/authentication/login.dart';
import 'package:rt_mobile/data/services/authentication/register.dart';
import 'package:rt_mobile/data/services/cinema.dart';
import 'package:rt_mobile/data/services/fab.dart';
import 'package:rt_mobile/data/services/film.dart';
import 'package:rt_mobile/data/services/app_navigator.dart';
import 'package:rt_mobile/data/services/order.dart';
import 'package:rt_mobile/data/services/payment.dart';
import 'package:rt_mobile/data/services/showtime.dart';
import 'package:rt_mobile/presentation/authentication/forgot_password/bloc/bloc.dart';
import 'package:rt_mobile/presentation/authentication/login/view/login_screen.dart';
import 'package:rt_mobile/presentation/authentication/register/bloc/bloc.dart';
import 'package:rt_mobile/presentation/cubit/auth/auth.dart';
import 'package:rt_mobile/presentation/cubit/change_tab/change_tab.dart';

part 'app.view.dart';
part 'app.router.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  // Authentication
  late final AuthenticationRepository _authenticationRepository;
  late final FilmRepository _filmRepository;
  late final CinemaRepository _cinemaRepository;
  late final ShowtimeRepository _showtimeRepository;
  late final PaymentRepository _paymentRepository;
  late final FABRepository _fABRepository;
  late final OrderRepository _orderRepository;
  // Authorization
  // late final AuthorizationRepository _authorizationRepository;

  @override
  void initState() {
    super.initState();

    final dioClient = Dio(BaseOptions(baseUrl: BASE_URL));

    _authenticationRepository = AuthenticationRepository(
      registerService: RegisterService(dio: dioClient),
      loginService: LoginService(dio: dioClient),
    );
    _filmRepository = FilmRepository(filmService: FilmService(dio: dioClient));
    _cinemaRepository = CinemaRepository(
      cinemaService: CinemaService(dio: dioClient),
    );
    _showtimeRepository = ShowtimeRepository(
      showtimeService: ShowtimeService(dio: dioClient),
    );
    _paymentRepository = PaymentRepository(
      paymentService: PaymentService(dio: dioClient),
    );
    _fABRepository = FABRepository(fABService: FABService(dio: dioClient));
    _orderRepository = OrderRepository(
      orderService: OrderService(dio: dioClient),
    );
    // _authorizationRepository = AuthorizationRepository();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _authenticationRepository),
        RepositoryProvider.value(value: _filmRepository),
        RepositoryProvider.value(value: _cinemaRepository),
        RepositoryProvider.value(value: _showtimeRepository),
        RepositoryProvider.value(value: _paymentRepository),
        RepositoryProvider.value(value: _fABRepository),
        RepositoryProvider.value(value: _orderRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create:
                (_) => RegisterBloc(
                  authenticationRepository: _authenticationRepository,
                ),
          ),
          BlocProvider(create: (_) => ForgotPasswordBloc()),
          BlocProvider(create: (_) => AuthCubit()..checkAuthStatus()),
        ],
        child: AppRouter(),
      ),
    );
  }
}
