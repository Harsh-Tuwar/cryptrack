import 'package:crypto_tracker/controllers/auth_controller.dart';
import 'package:flutter/material.dart';

class SignupView extends StatelessWidget {
  SignupView({Key? key}) : super(key: key);
  final AuthController authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: authController.emailController,
              decoration: const InputDecoration(hintText: "Email"),
            ),
            TextField(
              controller: authController.passwordController,
              obscureText: true,
              decoration: const InputDecoration(hintText: "Password"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      authController.handleSignUp();
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
