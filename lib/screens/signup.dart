import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_rental_app/screens/signin.dart';
import 'package:smart_rental_app/screens/tenant/tenant_home_screen.dart';
import 'package:smart_rental_app/screens/landlord/landlord_home_screen.dart';
import 'package:smart_rental_app/services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formSignupKey = GlobalKey<FormState>();

  bool agreePersonalData = true;
  String selectedRole = 'Tenant';
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController icController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    icController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> _signUpWithGoogle() async {
    try {
      final userData = await AuthService().signInWithGoogle();

      if (!mounted) return;

      final String name = userData['name'] ?? 'User';
      final String userEmail = userData['email'] ?? '';
      final String activeRole = userData['activeRole'] ?? 'Tenant';

      if (activeRole == 'Landlord') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                LandlordHomeScreen(userName: name, userEmail: userEmail),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                TenantHomeScreen(userName: name, userEmail: userEmail),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      _showError('Google sign up failed: $e');
    }
  }

  Future<void> _signUpUser() async {
    if (!_formSignupKey.currentState!.validate()) return;

    if (!agreePersonalData) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to the terms first')),
      );
      return;
    }

    try {
      final String name = nameController.text.trim();
      final String email = emailController.text.trim();
      final String password = passwordController.text.trim();
      final String nric = icController.text.trim();

      await AuthService().signUp(
        name: name,
        email: email,
        password: password,
        role: selectedRole,
        nric: selectedRole == 'Landlord' ? nric : null,
      );

      if (!mounted) return;

      if (selectedRole == 'Tenant') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => TenantHomeScreen(userName: name, userEmail: email),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                LandlordHomeScreen(userName: name, userEmail: email),
          ),
        );
      }
    } catch (e) {
      String errorMessage = "Signup failed. Please try again.";

      if (e.toString().contains("email-already-in-use")) {
        errorMessage = "This email is already registered.";
      } else if (e.toString().contains("weak-password")) {
        errorMessage = "Password must be at least 6 characters.";
      } else if (e.toString().contains("invalid-email")) {
        errorMessage = "Please enter a valid email address.";
      } else if (e.toString().contains("network-request-failed")) {
        errorMessage = "Check your internet connection.";
      }

      if (!mounted) return;
      _showError(errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final Gradient backgroundGradient = dark
        ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0B1220),
              Color(0xFF111827),
              Color(0xFF172554),
              Color(0xFF0F172A),
            ],
          )
        : const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF8F1E7),
              Color(0xFFF2E6D5),
              Color(0xFFEAD8BE),
              Color(0xFFF7EFE5),
            ],
          );

    final Color cardColor = dark
        ? Colors.white.withOpacity(0.08)
        : Colors.white.withOpacity(0.55);

    final Color borderColor = dark
        ? Colors.white.withOpacity(0.12)
        : Colors.white.withOpacity(0.70);

    final Color textPrimary = colorScheme.onSurface;
    final Color textSecondary = dark ? Colors.white70 : const Color(0xFF8B7355);
    final Color subtleText = dark ? Colors.white60 : const Color(0xFF6F5A40);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(gradient: backgroundGradient),
        child: Stack(
          children: [
            _buildBackgroundGlowTopRight(dark),
            _buildBackgroundGlowBottomLeft(dark),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    _buildTopBar(context, dark),
                    const SizedBox(height: 10),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            const SizedBox(height: 8),
                            _buildHeader(
                              dark: dark,
                              primaryText: textPrimary,
                              secondaryText: textSecondary,
                            ),
                            const SizedBox(height: 22),
                            _buildFormCard(
                              context: context,
                              dark: dark,
                              cardColor: cardColor,
                              borderColor: borderColor,
                              primaryText: textPrimary,
                              secondaryText: textSecondary,
                              subtleText: subtleText,
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, bool dark) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: dark
                ? Colors.white.withOpacity(0.08)
                : Colors.white.withOpacity(0.55),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: dark
                  ? Colors.white.withOpacity(0.10)
                  : const Color(0xFFD6B36A).withOpacity(0.45),
            ),
          ),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader({
    required bool dark,
    required Color primaryText,
    required Color secondaryText,
  }) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: dark
                ? const [Colors.white, Color(0xFF9DB7E8), Color(0xFFE6BC6D)]
                : const [
                    Color(0xFF2B2118),
                    Color(0xFF8E6A39),
                    Color(0xFFD8AF5B),
                  ],
          ).createShader(bounds),
          child: Text(
            'Create Account',
            textAlign: TextAlign.center,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 38,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1,
              letterSpacing: 0.6,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Join Yuppies Lah and start your journey',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 13.5,
            color: secondaryText,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildFormCard({
    required BuildContext context,
    required bool dark,
    required Color cardColor,
    required Color borderColor,
    required Color primaryText,
    required Color secondaryText,
    required Color subtleText,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: dark
                ? Colors.black.withOpacity(0.22)
                : const Color(0xFFB88C45).withOpacity(0.12),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Form(
        key: _formSignupKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Role',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: secondaryText,
              ),
            ),
            const SizedBox(height: 12),
            _buildRoleSelector(dark),
            const SizedBox(height: 20),
            _luxuryField(
              controller: nameController,
              label: 'Full Name',
              icon: Icons.person_outline_rounded,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your full name';
                }
                return null;
              },
            ),
            if (selectedRole == 'Landlord') ...[
              const SizedBox(height: 14),
              _luxuryField(
                controller: icController,
                label: 'NRIC',
                icon: Icons.badge_outlined,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your NRIC';
                  }
                  if (!RegExp(r'^\d{12}$').hasMatch(value.trim())) {
                    return 'NRIC must be exactly 12 digits';
                  }
                  return null;
                },
              ),
            ],
            const SizedBox(height: 14),
            _luxuryField(
              controller: emailController,
              label: 'Email',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
            _luxuryField(
              controller: passwordController,
              label: 'Password',
              icon: Icons.lock_outline_rounded,
              obscureText: obscurePassword,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    obscurePassword = !obscurePassword;
                  });
                },
                icon: Icon(
                  obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: dark ? Colors.white70 : const Color(0xFF9C7A4B),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 8) {
                  return 'Password must be at least 8 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
            _luxuryField(
              controller: confirmPasswordController,
              label: 'Confirm Password',
              icon: Icons.lock_person_outlined,
              obscureText: obscureConfirmPassword,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    obscureConfirmPassword = !obscureConfirmPassword;
                  });
                },
                icon: Icon(
                  obscureConfirmPassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: dark ? Colors.white70 : const Color(0xFF9C7A4B),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Transform.translate(
                  offset: const Offset(-6, 0),
                  child: Checkbox(
                    value: agreePersonalData,
                    activeColor: const Color(0xFFC69545),
                    checkColor: Colors.white,
                    side: BorderSide(
                      color: dark
                          ? Colors.white54
                          : const Color(0xFFD6B36A).withOpacity(0.8),
                    ),
                    onChanged: (value) {
                      setState(() {
                        agreePersonalData = value ?? false;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: Text(
                    'I agree to the terms and conditions',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: secondaryText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _primaryButton(context),
            const SizedBox(height: 22),
            _dividerText(secondaryText, dark),
            const SizedBox(height: 18),
            _googleButton(dark),
            const SizedBox(height: 20),
            _loginRedirect(subtleText),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleSelector(bool dark) {
    return Row(
      children: [
        Expanded(
          child: _roleCard(
            role: 'Tenant',
            icon: Icons.person_outline_rounded,
            dark: dark,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _roleCard(
            role: 'Landlord',
            icon: Icons.home_work_outlined,
            dark: dark,
          ),
        ),
      ],
    );
  }

  Widget _roleCard({
    required String role,
    required IconData icon,
    required bool dark,
  }) {
    final bool isSelected = selectedRole == role;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRole = role;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFFE6BC6D), Color(0xFFBE8233)],
                )
              : null,
          color: isSelected
              ? null
              : dark
              ? Colors.white.withOpacity(0.06)
              : Colors.white.withOpacity(0.7),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : dark
                ? Colors.white.withOpacity(0.12)
                : const Color(0xFFD6B36A).withOpacity(0.65),
            width: 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFC89243).withOpacity(0.18),
                    blurRadius: 14,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Colors.white
                  : dark
                  ? Colors.white70
                  : const Color(0xFF8D6A3B),
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              role,
              style: GoogleFonts.inter(
                color: isSelected
                    ? Colors.white
                    : dark
                    ? Colors.white70
                    : const Color(0xFF6B5338),
                fontWeight: FontWeight.w600,
                fontSize: 13.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _luxuryField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: GoogleFonts.inter(
        color: Theme.of(context).colorScheme.onSurface,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.inter(
          color: dark ? Colors.white70 : const Color(0xFF8B7355),
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(
          icon,
          color: dark ? const Color(0xFF9DB7E8) : const Color(0xFFC28F41),
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: dark
            ? Colors.white.withOpacity(0.06)
            : Colors.white.withOpacity(0.82),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: dark
                ? Colors.white.withOpacity(0.10)
                : const Color(0xFFD9BC8A).withOpacity(0.55),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: dark ? const Color(0xFF9DB7E8) : const Color(0xFFC69545),
            width: 1.4,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
        ),
      ),
    );
  }

  Widget _primaryButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFFE6BC6D), Color(0xFFBE8233)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFC89243).withOpacity(0.25),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _signUpUser,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            'Sign up as $selectedRole',
            style: GoogleFonts.inter(
              fontSize: 15.5,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _dividerText(Color secondaryText, bool dark) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: dark
                ? Colors.white.withOpacity(0.14)
                : const Color(0xFFD7B98A).withOpacity(0.7),
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'or continue with',
            style: GoogleFonts.inter(
              fontSize: 12.5,
              color: secondaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: dark
                ? Colors.white.withOpacity(0.14)
                : const Color(0xFFD7B98A).withOpacity(0.7),
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _googleButton(bool dark) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton.icon(
        onPressed: _signUpWithGoogle,
        icon: Icon(
          Icons.g_mobiledata_rounded,
          size: 30,
          color: dark ? const Color(0xFF9DB7E8) : const Color(0xFFC28F41),
        ),
        label: Text(
          'Continue with Google',
          style: GoogleFonts.inter(
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
            color: dark ? Colors.white : const Color(0xFF7B5E35),
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: dark
              ? Colors.white.withOpacity(0.04)
              : Colors.white.withOpacity(0.45),
          side: BorderSide(
            color: dark
                ? Colors.white.withOpacity(0.14)
                : const Color(0xFFD6B36A).withOpacity(0.75),
            width: 1.2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }

  Widget _loginRedirect(Color subtleText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: GoogleFonts.inter(color: subtleText, fontSize: 13.5),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SignInScreen()),
            );
          },
          child: Text(
            'Sign In',
            style: GoogleFonts.inter(
              color: const Color(0xFFB17B30),
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackgroundGlowTopRight(bool dark) {
    return Positioned(
      top: -90,
      right: -60,
      child: Container(
        width: 260,
        height: 260,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: dark
              ? const Color(0xFF1D4ED8).withOpacity(0.18)
              : const Color(0xFFFFE9BF).withOpacity(0.55),
          boxShadow: [
            BoxShadow(
              color: dark
                  ? const Color(0xFF1D4ED8).withOpacity(0.16)
                  : const Color(0xFFFFE9BF).withOpacity(0.45),
              blurRadius: 100,
              spreadRadius: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundGlowBottomLeft(bool dark) {
    return Positioned(
      bottom: -120,
      left: -100,
      child: Container(
        width: 250,
        height: 210,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(140),
          color: dark
              ? const Color(0xFF60A5FA).withOpacity(0.10)
              : const Color(0xFFFFE7BA).withOpacity(0.28),
          boxShadow: [
            BoxShadow(
              color: dark
                  ? const Color(0xFF60A5FA).withOpacity(0.08)
                  : const Color(0xFFFFE7BA).withOpacity(0.24),
              blurRadius: 100,
              spreadRadius: 10,
            ),
          ],
        ),
      ),
    );
  }
}
