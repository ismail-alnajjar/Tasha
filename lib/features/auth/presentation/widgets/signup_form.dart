import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/presentation/widgets/custom_text_field.dart';

class SignupForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final GlobalKey<FormState> formKey;
  final Color primaryColor;

  const SignupForm({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.formKey,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildLabel('Full Name'),
        CustomTextField(
          controller: nameController,
          label: 'Your Name',
          prefixIcon: Icons.person_outline,
          fillColor: Colors.white.withOpacity(0.05),
          filled: true,
          borderRadius: 30,
          borderColor: Colors.white.withOpacity(0.1),
          textColor: Colors.white,
          hintColor: Colors.white.withOpacity(0.3),
          prefixIconColor: Colors.white.withOpacity(0.5),
          validator: (val) => val == null || val.isEmpty ? 'Required' : null,
        ),
        const SizedBox(height: 20),

        _buildLabel('Email Address'),
        CustomTextField(
          controller: emailController,
          label: 'hello@adventure.com',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          fillColor: Colors.white.withOpacity(0.05),
          filled: true,
          borderRadius: 30,
          borderColor: Colors.white.withOpacity(0.1),
          textColor: Colors.white,
          hintColor: Colors.white.withOpacity(0.3),
          prefixIconColor: Colors.white.withOpacity(0.5),
          validator: (val) {
            if (val == null || val.isEmpty) return 'Required';
            if (!val.contains('@')) return 'Invalid email';
            return null;
          },
        ),

        const SizedBox(height: 20),

        _buildLabel('Password'),
        CustomTextField(
          controller: passwordController,
          label: '••••••••',
          prefixIcon: Icons.lock_outline,
          obscureText: true,
          fillColor: Colors.white.withOpacity(0.05),
          filled: true,
          borderRadius: 30,
          borderColor: Colors.white.withOpacity(0.1),
          textColor: Colors.white,
          hintColor: Colors.white.withOpacity(0.3),
          prefixIconColor: Colors.white.withOpacity(0.5),
          validator: (val) =>
              val != null && val.length < 6 ? 'Min 6 chars' : null,
        ),

        const SizedBox(height: 20),

        _buildLabel('Confirm Password'),
        CustomTextField(
          controller: confirmPasswordController,
          label: '••••••••',
          prefixIcon: Icons.lock_outline,
          obscureText: true,
          fillColor: Colors.white.withOpacity(0.05),
          filled: true,
          borderRadius: 30,
          borderColor: Colors.white.withOpacity(0.1),
          textColor: Colors.white,
          hintColor: Colors.white.withOpacity(0.3),
          prefixIconColor: Colors.white.withOpacity(0.5),
          validator: (val) =>
              val != passwordController.text ? 'Mismatch' : null,
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        text.toUpperCase(),
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.white.withOpacity(0.7),
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
