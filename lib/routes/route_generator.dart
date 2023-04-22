import 'package:flutter/material.dart';
import 'package:frontend_events/models/user.dart';
import 'package:frontend_events/views/cadastro.dart';
import 'package:frontend_events/views/certificados.dart';
import 'package:frontend_events/views/checkin.dart';
import 'package:frontend_events/views/event.dart';
import 'package:frontend_events/views/home_page.dart';
import 'package:frontend_events/views/login.dart';

class RouteGenerator {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final Map<String, Widget Function(BuildContext)> routes = {
      '/': (context) => const LoginView(),
      '/cadastrar': (context) => const CadastroView(),
      '/home': (context) {
        final usuario = settings.arguments as User?;
        if (usuario != null) {
          return HomePageView(user: usuario);
        } else {
          return const LoginView();
        }
      },
      '/eventos': (context) {
        final usuario = settings.arguments as User?;
        if (usuario != null) {
          return EventView(user: usuario);
        } else {
          return const LoginView();
        }
      },
      '/checkIn': (context) {
        final usuario = settings.arguments as User?;
        if (usuario != null) {
          return CheckInView(user: usuario);
        } else {
          return const LoginView();
        }
      },
      '/certificado': (context) {
        final usuario = settings.arguments as User?;
        if (usuario != null) {
          return CertificadoView(user: usuario);
        } else {
          return const LoginView();
        }
      },
    };

    final builder = routes[settings.name];

    if (builder != null) {
      return MaterialPageRoute(builder: builder, settings: settings);
    } else {
      return MaterialPageRoute(builder: (context) => const LoginView());
    }
  }
}
