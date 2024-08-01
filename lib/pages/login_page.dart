import 'package:flutter/material.dart';
import 'package:dodiddone_3/services/firebase_auth.dart'; // Import AuthService
// Import TaskPage
import 'package:dodiddone_3/screens/profile.dart'; // Import ProfilePage

// ignore: unused_import
import 'main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isSignIn = true;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final AuthService _authService = AuthService(); // Create an instance of AuthService

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).primaryColor, // Always use primaryColor
                Theme.of(context).hintColor, // Always use hintColor
              ],
              stops: const [0.7, 1.0], // Primary color takes 70% of space
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.asset(
                          'assets/LOGO.png',
                          width: 220,
                          height: 220,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Title
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 36,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Do',
                              style: TextStyle(
                                color: Color(0xFF2276FD),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: 'Did',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: 'Done',
                              style: TextStyle(
                                color: Color(0xFF2276FD),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Email Field
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          hintText: 'Почта',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Пожалуйста, введите email';
                          }
                          if (!value.contains('@')) {
                            return 'Неверный формат email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Password Field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'Пароль',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Пожалуйста, введите пароль';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Confirm Password Field (Only shown for signup)
                      if (!_isSignIn)
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: 'Повторить пароль',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Пожалуйста, подтвердите пароль';
                            }
                            if (value != _passwordController.text) {
                              return 'Пароли не совпадают';
                            }
                            return null;
                          },
                        ),
                      const SizedBox(height: 16),

                      // Login Button
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (_isSignIn) {
                              // Login
                              try {
                                await _authService.signInWithEmailAndPassword(
                                    _emailController.text.trim(),
                                    _passwordController.text.trim());
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const MainPage()),
                                );
                              } catch (e) {
                                // Handle login error
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Ошибка входа: ${e.toString()}'),
                                  ),
                                );
                              }
                            } else {
                              // Signup
                              try {
                                await _authService.registerWithEmailAndPassword(
                                    _emailController.text.trim(),
                                    _passwordController.text.trim());
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const ProfilePage()),
                                );
                              } catch (e) {
                                // Handle signup error
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Ошибка регистрации: ${e.toString()}'),
                                  ),
                                );
                              }
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF33A0FB),
                          padding:
                              const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(_isSignIn ? 'Войти' : 'Зарегистрироваться'),
                      ),
                      const SizedBox(height: 12),

                      // Switch to Signup/Login
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isSignIn = !_isSignIn;
                          });
                        },
                        child: Text(
                          _isSignIn
                              ? 'У меня еще нет аккаунта...'
                              : 'Уже есть аккаунт',
                          style: const TextStyle(
                            color: Color(0xFF2276FD),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
