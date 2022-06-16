import 'package:crypto_tracker/views/home.view.dart';
import 'package:crypto_tracker/views/login.view.dart';
import 'package:crypto_tracker/views/signup.view.dart';
import 'package:get/route_manager.dart';

class AppRoutes {
  static const home = "/home";
  static const login = "/login";
  static const signup = "/signup";

  static final routes = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(title: 'CrypTrack'),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => SignupView(),
    ),
  ];
}
