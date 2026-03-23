import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tashaapp/core/presentation/widgets/custom_text_field.dart';
import '../../cubit/auth_cubit.dart';
import '../../cubit/auth_state.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().resetPassword(_emailController.text.trim());
  }

  void _showSuccess(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Email Sent", style: TextStyle(color: Colors.green)),
        content: const Text(
          "We have sent a password reset link to your email. Please check your inbox.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close Dialog
              Navigator.pop(context); // Go back to Login
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Error", style: TextStyle(color: Colors.red)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFEE8C2B);

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthPasswordResetSent) {
          _showSuccess(context);
        } else if (state is AuthError) {
          _showError(state.message);
        }
      },
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Background (Same as Login)
            Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuBP3QpIAYkXNti4J8kfrSXoX4wSdaWtwlFZ-Ju--A4v-kHwYgCYpQgibJqea7zTBy61Zq1_dZc1Qz3nES8yFGjeO_Oc5OHgsBs97oP7GJXwF57VMFU_Q_ivpLEFILfV5vumbaproEDApt82Tq8jBRXx2fgIMgQzUpzlOh7ZPGVwhoYdI7S4LZRQ2uZ3VhrhG6bCRdS22GiqjKRNXGCSJekdPnPhHZL566euwk75hPHDYTuJCraE8JjbU8ezH-5hzTFLXpuSSQ6lXJx8',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(color: const Color(0xFF221910));
              },
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    const Color(0xFF221910).withOpacity(0.9),
                  ],
                ),
              ),
            ),

            // 2. Content
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Back Button
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Header
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.lock_reset,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Forgot Password',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Enter your email to receive a reset link',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),

                      const SizedBox(height: 48),

                      // Form Card
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: const Color(0xFF221910).withOpacity(0.4),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.1),
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 8,
                                      left: 4,
                                    ),
                                    child: Text(
                                      'EMAIL ADDRESS',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white.withOpacity(0.7),
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ),
                                  CustomTextField(
                                    controller: _emailController,
                                    label: 'hello@example.com',
                                    prefixIcon: Icons.email_outlined,
                                    keyboardType: TextInputType.emailAddress,
                                    fillColor: Colors.white.withOpacity(0.05),
                                    filled: true,
                                    borderRadius: 30,
                                    borderColor: Colors.white.withOpacity(0.1),
                                    textColor: Colors.white,
                                    hintColor: Colors.white.withOpacity(0.3),
                                    prefixIconColor: Colors.white.withOpacity(
                                      0.5,
                                    ),
                                    validator: (val) {
                                      if (val == null || val.isEmpty)
                                        return 'Required';
                                      if (!val.contains('@'))
                                        return 'Invalid email';
                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: 32),

                                  // Submit Button
                                  BlocBuilder<AuthCubit, AuthState>(
                                    builder: (context, state) {
                                      final isLoading = state is AuthLoading;
                                      return SizedBox(
                                        width: double.infinity,
                                        height: 56,
                                        child: ElevatedButton(
                                          onPressed: isLoading
                                              ? null
                                              : () => _submit(context),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: primaryColor,
                                            foregroundColor: Colors.white,
                                            shadowColor: primaryColor
                                                .withOpacity(0.3),
                                            elevation: 8,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                          ),
                                          child: isLoading
                                              ? const SizedBox(
                                                  height: 24,
                                                  width: 24,
                                                  child:
                                                      CircularProgressIndicator(
                                                        color: Colors.white,
                                                        strokeWidth: 2,
                                                      ),
                                                )
                                              : Text(
                                                  'Send Reset Link',
                                                  style:
                                                      GoogleFonts.plusJakartaSans(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
