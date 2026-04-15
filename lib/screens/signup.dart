import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:smart_rental_app/theme/theme.dart';
import 'package:smart_rental_app/widgets/custom_scaffold.dart';
import 'package:smart_rental_app/screens/signin.dart';
import 'package:smart_rental_app/screens/tenant/tenant_home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formSignupKey = GlobalKey<FormState>();

  bool agreePersonalData = true;
  String selectedRole = 'Tenant';

  final TextEditingController nameController = TextEditingController();
  final TextEditingController icController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          const Expanded(flex: 1, child: SizedBox(height: 10)),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formSignupKey,
                  child: Column(
                    children: [
                      Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: lightColorScheme.primary,
                        ),
                      ),

                      const SizedBox(height: 30),

                      // 🔥 ROLE SELECTION
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedRole = 'Tenant';
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                decoration: BoxDecoration(
                                  color: selectedRole == 'Tenant'
                                      ? lightColorScheme.primary
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      color: selectedRole == 'Tenant'
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'Tenant',
                                      style: TextStyle(
                                        color: selectedRole == 'Tenant'
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedRole = 'Landlord';
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                decoration: BoxDecoration(
                                  color: selectedRole == 'Landlord'
                                      ? lightColorScheme.primary
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.home,
                                      color: selectedRole == 'Landlord'
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'Landlord',
                                      style: TextStyle(
                                        color: selectedRole == 'Landlord'
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      // FULL NAME
                      TextFormField(
                        controller: nameController,
                        validator: (value) =>
                            value!.isEmpty ? 'Enter full name' : null,
                        decoration: inputDecoration('Full Name'),
                      ),

                      const SizedBox(height: 20),

                      // 🔥 ONLY LANDLORD SHOW IC
                      if (selectedRole == 'Landlord')
                        Column(
                          children: [
                            TextFormField(
                              controller: icController,
                              validator: (value) =>
                                  value!.isEmpty ? 'Enter NRIC' : null,
                              decoration: inputDecoration('NRIC'),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),

                      // EMAIL
                      TextFormField(
                        controller: emailController,
                        validator: (value) =>
                            value!.isEmpty ? 'Enter email' : null,
                        decoration: inputDecoration('Email'),
                      ),

                      const SizedBox(height: 20),

                      // PASSWORD
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        validator: (value) =>
                            value!.isEmpty ? 'Enter password' : null,
                        decoration: inputDecoration('Password'),
                      ),

                      const SizedBox(height: 20),

                      // CONFIRM PASSWORD
                      TextFormField(
                        controller: confirmPasswordController,
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) return 'Confirm password';
                          if (value != passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        decoration: inputDecoration('Confirm Password'),
                      ),

                      const SizedBox(height: 20),

                      // CHECKBOX
                      Row(
                        children: [
                          Checkbox(
                            value: agreePersonalData,
                            onChanged: (value) {
                              setState(() {
                                agreePersonalData = value!;
                              });
                            },
                          ),
                          const Text('Agree to terms'),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // SIGN UP BUTTON
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formSignupKey.currentState!.validate() &&
                                agreePersonalData) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      HomeScreen(userName: nameController.text),
                                ),
                              );
                            }
                          },
                          child: Text('Sign up as $selectedRole'),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // GOOGLE
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Logo(Logos.google)],
                      ),

                      const SizedBox(height: 20),

                      // SIGN IN
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Already have account? '),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (e) => const SignInScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Sign in',
                              style: TextStyle(
                                color: lightColorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔥 REUSABLE INPUT DESIGN
  InputDecoration inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
