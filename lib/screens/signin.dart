import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_rental_app/screens/signup.dart';
import 'package:smart_rental_app/screens/forget_password.dart';
import 'package:smart_rental_app/screens/tenant/tenant_home_screen.dart';
import 'package:smart_rental_app/screens/landlord/landlord_home_screen.dart';
import 'package:smart_rental_app/services/auth_service.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();

  bool rememberPassword = true;
  bool obscurePassword = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showRoleChoiceDialog(String name, String email) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: const Text('Continue as'),
          content: const Text('Choose which mode you want to use.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => HomeScreen(userName: name)),
                );
              },
              child: const Text('Tenant'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        LandlordHomeScreen(userName: name, userEmail: email),
                  ),
                );
              },
              child: const Text('Landlord'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _signInUser() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      final userData = await AuthService().signIn(
        email: email,
        password: password,
      );

      if (!mounted) return;

      final List roles = userData['roles'] ?? [];
      final name = userData['name'] ?? 'User';
      final userEmail = userData['email'] ?? email;

      if (roles.length == 1 && roles.contains('Tenant')) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen(userName: name)),
        );
      } else if (roles.length == 1 && roles.contains('Landlord')) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                LandlordHomeScreen(userName: name, userEmail: userEmail),
          ),
        );
      } else if (roles.contains('Tenant') && roles.contains('Landlord')) {
        _showRoleChoiceDialog(name, userEmail);
      } else {
        _showError('No role found for this account.');
      }
    } catch (e) {
      String errorMessage = "Login failed. Please try again.";

      if (e.toString().contains("invalid-credential")) {
        errorMessage = "Invalid email or password.";
      } else if (e.toString().contains("user-not-found")) {
        errorMessage = "Account not found.";
      } else if (e.toString().contains("wrong-password")) {
        errorMessage = "Incorrect password.";
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
            'Welcome Back',
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
          'Login to continue your journey',
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
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _luxuryField(
              label: 'Email',
              icon: Icons.email_outlined,
              controller: emailController,
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
              label: 'Password',
              icon: Icons.lock_outline_rounded,
              controller: passwordController,
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
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      Transform.translate(
                        offset: const Offset(-6, 0),
                        child: Checkbox(
                          value: rememberPassword,
                          activeColor: const Color(0xFFC69545),
                          checkColor: Colors.white,
                          side: BorderSide(
                            color: dark
                                ? Colors.white54
                                : const Color(0xFFD6B36A).withOpacity(0.8),
                          ),
                          onChanged: (value) {
                            setState(() {
                              rememberPassword = value ?? false;
                            });
                          },
                        ),
                      ),
                      Flexible(
                        child: Text(
                          'Remember me',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: secondaryText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ForgetPasswordScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Forgot?',
                    style: GoogleFonts.inter(
                      color: const Color(0xFFB17B30),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
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
            _signupRedirect(subtleText),
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
          onPressed: _signInUser,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            'Sign In',
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
        onPressed: () {},
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

  Widget _signupRedirect(Color subtleText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: GoogleFonts.inter(color: subtleText, fontSize: 13.5),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SignUpScreen()),
            );
          },
          child: Text(
            'Sign Up',
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
