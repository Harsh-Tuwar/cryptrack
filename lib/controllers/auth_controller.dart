import 'package:crypto_tracker/app_route.dart';
import 'package:crypto_tracker/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: constant_identifier_names
enum SignInType { EMAIL_PASSWORD, GOOGLE }

class AuthController extends GetxController {
  static AuthController authInstance = Get.find();

  final Rx<User?> firebaseUser = Rx<User?>(null);
  RxBool isLogged = false.obs;
  late TextEditingController emailController = TextEditingController(text: '');
  late TextEditingController passwordController =
      TextEditingController(text: '');
  late TextEditingController usernameController =
      TextEditingController(text: '');
  late AuthService _authService;

  AuthController() {
    _authService = AuthService();
  }

  @override
  void onReady() {
    ever(firebaseUser, handleAuthChanged);
    firebaseUser.value = _authService.getCurrentUser();
    firebaseUser.bindStream(_authService.getAuthInstace().userChanges());
    super.onReady();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  handleAuthChanged(User? user) {
    if (user == null) {
      Get.offAllNamed(AppRoutes.login);
    } else {
      Get.offAllNamed(AppRoutes.home);
    }
  }

  handleSignIn(SignInType type) async {
    if (type == SignInType.EMAIL_PASSWORD) {
      if (emailController.text == "" || passwordController.text == "") {
        Get.snackbar("error", "Empty email or password");
        return;
      }
    }

    SnackbarController _snack = Get.snackbar(
      "Signing In",
      "Loading...",
      showProgressIndicator: true,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(minutes: 2),
    );

    try {
      if (type == SignInType.EMAIL_PASSWORD) {
        await _authService.signInWithEmailPassword(
            emailController.text.trim(), passwordController.text.trim());
        emailController.clear();
        passwordController.clear();
      } else if (type == SignInType.GOOGLE) {
        await _authService.signInWithGoogle();
      }
    } catch (e) {
      Get.back();
      Get.defaultDialog(title: 'Error', middleText: e.toString(), actions: [
        ElevatedButton(
          onPressed: () => Get.back(),
          child: const Text('Close'),
        )
      ]);
      print(e);
    }

    _snack.close();
  }

  handleSignUp() async {
    if (emailController.text == "" || passwordController.text == "") {
      Get.snackbar("Error", "Empty email or password");
      return;
    }

    SnackbarController _snack = Get.snackbar(
      "Signing Up",
      "Loading",
      showProgressIndicator: true,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(minutes: 2),
    );

    try {
      firebaseUser.value = await _authService.signUp(
        emailController.text.trim(),
        passwordController.text.trim(),
        usernameController.text.trim(),
      );
      emailController.clear();
      passwordController.clear();
    } catch (e) {
      Get.back();
      Get.defaultDialog(title: "Error", middleText: e.toString(), actions: [
        ElevatedButton(
          onPressed: () {
            Get.back();
          },
          child: const Text("Close"),
        ),
      ]);
      print(e);
    }

    _snack.close();
  }

  handleSignOut() async {
    SnackbarController _snack = Get.snackbar(
      "Signing out",
      "Loading",
      showProgressIndicator: true,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(minutes: 2),
    );
    _authService.signOut();
    _snack.close();
  }
}
