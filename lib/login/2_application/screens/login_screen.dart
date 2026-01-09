// ignore_for_file: sized_box_for_whitespace

import 'package:bloodconnect/donor_worker_option.dart';
import 'package:bloodconnect/login/0_data/models/auth_model.dart';
import 'package:bloodconnect/login/2_application/screens/bloc/login_screen_bloc.dart';
import 'package:bloodconnect/login/2_application/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginScreenBloc, LoginScreenState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Authentication Successful')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const DonorWorkerOption(),
            ),
          );
        }
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              duration: const Duration(seconds: 5),
            ),
          );
        }
      },
      builder: (context, state) {
        final isLogin = state is ToggleAuthMode ? state.isLogin : true;
        final isLoading = state is AuthLoading;

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),

                    // App Logo and Welcome Text
                    Center(
                      child: Column(
                        children: [
                          Container(
                            height: 90,
                            width: 90,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEE8E8),
                              borderRadius: BorderRadius.circular(45),
                            ),
                            child: Image.asset(
                              'assets/blood_bank.png',
                              height: 70,
                              width: 70,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "BloodConnect",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Connect to save lives",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 50),

                    // Login form card
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Login/Register toggle
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        if (!isLogin) {
                                          context
                                              .read<LoginScreenBloc>()
                                              .add(ToggleAuthModeEvent());
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15),
                                        decoration: BoxDecoration(
                                          color: isLogin
                                              ? const Color(0xFFD32F2F)
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Login",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: isLogin
                                                  ? Colors.white
                                                  : Colors.grey[600],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        if (isLogin) {
                                          context
                                              .read<LoginScreenBloc>()
                                              .add(ToggleAuthModeEvent());
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15),
                                        decoration: BoxDecoration(
                                          color: !isLogin
                                              ? const Color(0xFFD32F2F)
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Register",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: !isLogin
                                                  ? Colors.white
                                                  : Colors.grey[600],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 30),

                            // Form Fields
                            if (!isLogin) ...[
                              Text(
                                "Name",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[800],
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFieldWidget(
                                controller: nameController,
                                hintText: 'Enter your name',
                                obsecureText: false,
                                prefixIcon: Icons.person_outline,
                              ),
                              const SizedBox(height: 20),
                            ],

                            // Email Field
                            Text(
                              "Email Address",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFieldWidget(
                              controller: emailController,
                              hintText: 'Enter your email',
                              obsecureText: false,
                              prefixIcon: Icons.email_outlined,
                            ),
                            const SizedBox(height: 20),

                            // Password Field
                            Text(
                              "Password",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFieldWidget(
                              controller: passwordController,
                              hintText: 'Enter your password',
                              obsecureText: true,
                              prefixIcon: Icons.lock_outline,
                            ),
                            const SizedBox(height: 30),

                            // Sign in button
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        if (isLogin) {
                                          context.read<LoginScreenBloc>().add(
                                                LoginWithEmail(
                                                  userSignInReq: UserSignInReq(
                                                    email: emailController.text
                                                        .trim(),
                                                    password: passwordController
                                                        .text
                                                        .trim(),
                                                  ),
                                                ),
                                              );
                                        } else {
                                          context.read<LoginScreenBloc>().add(
                                                SignUpWithEmailEvent(
                                                  user: UserSignUpReq(
                                                    email: emailController.text
                                                        .trim(),
                                                    password: passwordController
                                                        .text
                                                        .trim(),
                                                    name: nameController.text
                                                        .trim(),
                                                  ),
                                                ),
                                              );
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFD32F2F),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  isLogin ? 'Login' : 'Create Account',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Or login with
                    Center(
                      child: Text(
                        "Or continue with",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Social login buttons
                    Center(
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: IconButton(
                          onPressed: () {
                            context
                                .read<LoginScreenBloc>()
                                .add(GoogleSignInEvent());
                          },
                          icon:
                              Image.asset('assets/google-logo.png', height: 24),
                          iconSize: 24,
                        ),
                      ),
                    ),

                    if (isLoading)
                      const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Center(
                            child: CircularProgressIndicator(
                                color: Color(0xFFD32F2F))),
                      ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
