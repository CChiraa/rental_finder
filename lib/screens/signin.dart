import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_rental_app/screens/signup.dart';
import 'package:smart_rental_app/screens/forget_password.dart';
import 'package:smart_rental_app/screens/tenant/tenant_home_screen.dart';
import 'package:smart_rental_app/screens/landlord/landlord_home_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();

  bool rememberPassword = true;
  bool obscurePassword = true;
  String selectedRole = 'Tenant';

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF8F1E7),
              Color(0xFFF2E6D5),
              Color(0xFFEAD8BE),
              Color(0xFFF7EFE5),
            ],
          ),
        ),
        child: Stack(
          children: [
            _buildBackgroundGlowTopRight(),
            _buildBackgroundGlowBottomLeft(),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    _buildTopBar(context),
                    const SizedBox(height: 10),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            const SizedBox(height: 8),
                            _buildHeader(),
                            const SizedBox(height: 22),
                            _buildFormCard(),
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

  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.55),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFFD6B36A).withOpacity(0.45),
            ),
          ),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: Color(0xFF7A5B33),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF2B2118), Color(0xFF8E6A39), Color(0xFFD8AF5B)],
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
            color: const Color(0xFF8B7355),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildFormCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.55),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.7), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB88C45).withOpacity(0.12),
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
            Text(
              'Select Role',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF6C5338),
              ),
            ),
            const SizedBox(height: 12),
            _buildRoleSelector(),
            const SizedBox(height: 20),
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
                  color: const Color(0xFF9C7A4B),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Transform.translate(
                      offset: const Offset(-6, 0),
                      child: Checkbox(
                        value: rememberPassword,
                        activeColor: const Color(0xFFC69545),
                        checkColor: Colors.white,
                        side: BorderSide(
                          color: const Color(0xFFD6B36A).withOpacity(0.8),
                        ),
                        onChanged: (value) {
                          setState(() {
                            rememberPassword = value ?? false;
                          });
                        },
                      ),
                    ),
                    Text(
                      'Remember me',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: const Color(0xFF6A543B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
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
            _primaryButton(),
            const SizedBox(height: 22),
            _dividerText(),
            const SizedBox(height: 18),
            _googleButton(),
            const SizedBox(height: 20),
            _signupRedirect(),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleSelector() {
    return Row(
      children: [
        Expanded(
          child: _roleCard(role: 'Tenant', icon: Icons.person_outline_rounded),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _roleCard(role: 'Landlord', icon: Icons.home_work_outlined),
        ),
      ],
    );
  }

  Widget _roleCard({required String role, required IconData icon}) {
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
          color: isSelected ? null : Colors.white.withOpacity(0.7),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
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
              color: isSelected ? Colors.white : const Color(0xFF8D6A3B),
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              role,
              style: GoogleFonts.inter(
                color: isSelected ? Colors.white : const Color(0xFF6B5338),
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
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: GoogleFonts.inter(
        color: const Color(0xFF4A3B2B),
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.inter(
          color: const Color(0xFF8B7355),
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(icon, color: const Color(0xFFC28F41)),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white.withOpacity(0.82),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: const Color(0xFFD9BC8A).withOpacity(0.55),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFC69545), width: 1.4),
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

  Widget _primaryButton() {
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
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              String name = emailController.text.split('@')[0];

              if (selectedRole == 'Tenant') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => HomeScreen(userName: name)),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LandlordHomeScreen(userName: name),
                  ),
                );
              }
            }
          },
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

  Widget _dividerText() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: const Color(0xFFD7B98A).withOpacity(0.7),
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'or continue with',
            style: GoogleFonts.inter(
              fontSize: 12.5,
              color: const Color(0xFF8B7355),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: const Color(0xFFD7B98A).withOpacity(0.7),
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _googleButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: const Icon(
          Icons.g_mobiledata_rounded,
          size: 30,
          color: Color(0xFFC28F41),
        ),
        label: Text(
          'Continue with Google',
          style: GoogleFonts.inter(
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF7B5E35),
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.45),
          side: BorderSide(
            color: const Color(0xFFD6B36A).withOpacity(0.75),
            width: 1.2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }

  Widget _signupRedirect() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: GoogleFonts.inter(
            color: const Color(0xFF6F5A40),
            fontSize: 13.5,
          ),
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

  Widget _buildBackgroundGlowTopRight() {
    return Positioned(
      top: -90,
      right: -60,
      child: Container(
        width: 260,
        height: 260,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFFFE9BF).withOpacity(0.55),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFE9BF).withOpacity(0.45),
              blurRadius: 100,
              spreadRadius: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundGlowBottomLeft() {
    return Positioned(
      bottom: -120,
      left: -100,
      child: Container(
        width: 250,
        height: 210,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(140),
          color: const Color(0xFFFFE7BA).withOpacity(0.28),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFE7BA).withOpacity(0.24),
              blurRadius: 100,
              spreadRadius: 10,
            ),
          ],
        ),
      ),
    );
  }
}
