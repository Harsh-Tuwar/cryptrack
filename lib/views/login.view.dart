import 'package:crypto_tracker/app_route.dart';
import 'package:crypto_tracker/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final AuthController authController = AuthController();

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 40),
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey, //key for form
          child: Column(
            children: [
              TextFormField(
                controller: authController.emailController,
                decoration: const InputDecoration(labelText: 'Enter Email'),
                validator: (value) {
                  if (value!.isEmpty ||
                      !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                    return "Enter Correct Email Address";
                  } else {
                    return null;
                  }
                },
              ),
              TextFormField(
                controller: authController.passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Enter Password'),
                validator: (value) {
                  if (value!.isEmpty) {
                    //allow upper and lower case alphabets and space
                    return "Enter Correct password";
                  } else {
                    return null;
                  }
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    await authController
                        .handleSignIn(SignInType.EMAIL_PASSWORD);
                  }
                },
                child: const Text("Login"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  authController.emailController.clear();
                  authController.passwordController.clear();
                  Get.offAllNamed(AppRoutes.signup);
                },
                child: const Text("Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
