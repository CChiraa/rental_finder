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

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8F1E7), Color(0xFFF2E6D5), Color(0xFFEAD8BE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // 🔥 TITLE
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [
                      Color(0xFF2B2118),
                      Color(0xFF8E6A39),
                      Color(0xFFD8AF5B),
                    ],
                  ).createShader(bounds),
                  child: Text(
                    "Welcome Back",
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Login to continue your journey",
                  style: TextStyle(color: Color(0xFF8B7355)),
                ),

                const SizedBox(height: 25),

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFD6B36A).withOpacity(0.2),
                          blurRadius: 25,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _roleSelector(),

                            const SizedBox(height: 20),

                            _luxuryField(
                              emailController,
                              "Email",
                              icon: Icons.email_outlined,
                            ),

                            _luxuryField(
                              passwordController,
                              "Password",
                              obscure: obscurePassword,
                              icon: Icons.lock_outline,
                              suffix: IconButton(
                                icon: Icon(
                                  obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: const Color(0xFF9C7A4B),
                                ),
                                onPressed: () {
                                  setState(() {
                                    obscurePassword = !obscurePassword;
                                  });
                                },
                              ),
                            ),

                            const SizedBox(height: 10),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: rememberPassword,
                                      activeColor: const Color(0xFFD6B36A),
                                      onChanged: (value) {
                                        setState(() {
                                          rememberPassword = value!;
                                        });
                                      },
                                    ),
                                    const Text("Remember me"),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const ForgetPasswordScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Forgot?",
                                    style: TextStyle(
                                      color: Color(0xFFB8964F),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 15),

                            _primaryButton(),

                            const SizedBox(height: 20),

                            const Text("or continue with"),

                            const SizedBox(height: 15),

                            Icon(
                              Icons.g_mobiledata,
                              size: 40,
                              color: Color(0xFFD6B36A),
                            ),

                            const SizedBox(height: 20),

                            _signupRedirect(),
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
    );
  }

  // 🔥 FIELD
  Widget _luxuryField(
    TextEditingController controller,
    String label, {
    bool obscure = false,
    IconData? icon,
    Widget? suffix,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        validator: (value) => value!.isEmpty ? "Enter $label" : null,
        decoration: InputDecoration(
          prefixIcon: icon != null
              ? Icon(icon, color: Color(0xFFC28F41))
              : null,
          suffixIcon: suffix,
          labelText: label,
          filled: true,
          fillColor: Colors.white.withOpacity(0.8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // 🔥 ROLE
  Widget _roleSelector() {
    return Row(
      children: [
        Expanded(child: _roleCard("Tenant", Icons.person)),
        const SizedBox(width: 10),
        Expanded(child: _roleCard("Landlord", Icons.home)),
      ],
    );
  }

  Widget _roleCard(String role, IconData icon) {
    bool isSelected = selectedRole == role;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRole = role;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFFE1C27A), Color(0xFFB8964F)],
                )
              : null,
          color: isSelected ? null : Colors.white,
          border: Border.all(color: const Color(0xFFD6B36A)),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? Colors.white : Colors.black),
            const SizedBox(height: 5),
            Text(
              role,
              style: TextStyle(color: isSelected ? Colors.white : Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 BUTTON
  Widget _primaryButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFFE1C27A), Color(0xFFB8964F)],
          ),
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
          ),
          child: const Text(
            "Sign In",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  // 🔥 SIGN UP LINK
  Widget _signupRedirect() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account? "),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SignUpScreen()),
            );
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(
              color: Color(0xFFB8964F),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
