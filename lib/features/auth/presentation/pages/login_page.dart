import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/routes/app_routes.dart';
import '../../cubit/auth_cubit.dart';
import '../../cubit/auth_state.dart';
import '../cubit/login_view_cubit.dart';
import '../widgets/login_form.dart';
import '../widgets/signup_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Form Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // Extra for Sign Up
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context, bool isLogin) {
    if (!_formKey.currentState!.validate()) return;

    if (isLogin) {
      context.read<AuthCubit>().login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    } else {
      if (_passwordController.text != _confirmPasswordController.text) {
        _showError('Passwords do not match');
        return;
      }
      final userType = context.read<AuthCubit>().pendingUserType ?? 'tourist';
      context.read<AuthCubit>().signup(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
        userType,
      );
    }
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
    // Primary Color from design: #ee8c2b
    const primaryColor = Color(0xFFEE8C2B);

    return BlocProvider(
      create: (context) => LoginViewCubit(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.home,
              (route) => false,
            );
          } else if (state is AuthError) {
            _showError(state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return Scaffold(
            // Design specifies min-height, but standard Scaffold is fine.
            // Background is handled in Stack.
            body: Stack(
              fit: StackFit.expand,
              children: [
                // 1. Static Background
                const _LoginBackground(),

                // 2. Main Content
                SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 24,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // App Logo/Header
                          const _LoginHeader(primaryColor: Color(0xFFEE8C2B)),

                          const SizedBox(height: 40),

                          // Glassmorphism Card
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                              20,
                            ), // rounded-xl
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                              child: Container(
                                padding: const EdgeInsets.all(32),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF221910,
                                  ).withOpacity(0.4), // rgba(34, 25, 16, 0.4)
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.1),
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Form(
                                  key: _formKey,
                                  child: BlocBuilder<LoginViewCubit, bool>(
                                    builder: (context, isLogin) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          // Tabs
                                          _buildTabs(
                                            context,
                                            isLogin,
                                            primaryColor,
                                          ),

                                          const SizedBox(height: 32),

                                          // Form Fields
                                          if (isLogin)
                                            LoginForm(
                                              emailController: _emailController,
                                              passwordController:
                                                  _passwordController,
                                              formKey: _formKey,
                                              primaryColor: primaryColor,
                                            )
                                          else
                                            SignupForm(
                                              nameController: _nameController,
                                              emailController: _emailController,
                                              passwordController:
                                                  _passwordController,
                                              confirmPasswordController:
                                                  _confirmPasswordController,
                                              formKey: _formKey,
                                              primaryColor: primaryColor,
                                            ),

                                          const SizedBox(height: 32),

                                          // Submit Button
                                          _buildSubmitButton(
                                            context,
                                            isLoading,
                                            isLogin,
                                            primaryColor,
                                          ),

                                          const SizedBox(height: 32),

                                          // Social Login Divider
                                          _buildSocialDivider(),

                                          const SizedBox(height: 24),

                                          // Social Buttons
                                          _buildSocialButtons(),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 48),

                          // Footer Links
                          _buildFooter(),

                          const SizedBox(height: 24),
                          // Decorative Bottom Indicator (iOS Style)
                          Container(
                            width: 120,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // 3. Switch User Type Button (Moved to top layer)
                Positioned(
                  top: 0,
                  left: 0,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: IconButton(
                        icon: const Icon(
                          Icons.people_outline,
                          color: Colors.white,
                          size: 32,
                        ),
                        tooltip: 'Change User Type',
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoutes.Typeuser,
                            (route) => false,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabs(BuildContext context, bool isLogin, Color primaryColor) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => context.read<LoginViewCubit>().setLogin(),
            child: Container(
              padding: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isLogin ? primaryColor : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                'Login',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isLogin ? Colors.white : Colors.white.withOpacity(0.5),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => context.read<LoginViewCubit>().setSignup(),
            child: Container(
              padding: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: !isLogin ? primaryColor : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                'Sign Up',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: !isLogin
                      ? Colors.white
                      : Colors.white.withOpacity(0.5),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(
    BuildContext context,
    bool isLoading,
    bool isLogin,
    Color primaryColor,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : () => _submit(context, isLogin),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shadowColor: primaryColor.withOpacity(0.3),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                isLogin ? 'Sign In' : 'Sign Up',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildSocialDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.white.withOpacity(0.1))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR CONTINUE WITH',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.white.withOpacity(0.4),
              letterSpacing: 1.0,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.white.withOpacity(0.1))),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialButton(
          icon: Icons.g_mobiledata, // Google Icon placeholder
          onTap: () => context.read<AuthCubit>().signInWithGoogle(),
        ),
        const SizedBox(width: 24),
        _buildSocialButton(icon: Icons.apple, onTap: () {}),
      ],
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.05),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Text.rich(
      TextSpan(
        text: 'By signing in, you agree to our\n',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          color: Colors.white.withOpacity(0.6),
          height: 1.5,
        ),
        children: [
          TextSpan(
            text: 'Terms',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
          const TextSpan(text: ' and '),
          TextSpan(
            text: 'Privacy Policy',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _LoginBackground extends StatelessWidget {
  const _LoginBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
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
      ],
    );
  }
}

class _LoginHeader extends StatelessWidget {
  final Color primaryColor;

  const _LoginHeader({required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
            Icons.travel_explore,
            color: Colors.white,
            size: 32,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'TASHA',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Explore the Spirit of Jordan',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}
