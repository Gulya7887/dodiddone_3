import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isSignIn = true;

  get primarySwatch => null; // Track if user is on login or signup page

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _isSignIn
                ? [
                    Theme.of(context).primaryColor,
                    Theme.of(context).hintColor,
                  ]
                : [
                    Theme.of(context).hintColor,
                    Theme.of(context).primaryColor,
                  ],
            stops: const [0.3, 1.0], // Primary color takes 70% of space
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: StatefulBuilder(
            builder: (context, setState) { // Use StatefulBuilder
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title
                  Text(
                    _isSignIn ? 'Вход' : 'Регистрация',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2276FD),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Email Field
                  SizedBox(
                    height: 48, // Set height to 48 pixels
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Почта',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14), // Add horizontal padding
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  SizedBox(
                    height: 48, // Set height to 48 pixels
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Пароль',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14), // Add horizontal padding
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Repeat Password Field (Only shown for signup)
                  if (!_isSignIn)
                    SizedBox(
                      height: 48, // Set height to 48 pixels
                      child: TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Повторить пароль',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14), // Add horizontal padding
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),

                  // Login Button
                  ElevatedButton(
                    onPressed: () {
                      // Handle login/signup logic here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF33A0FB),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
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
                  const SizedBox(height: 14),

                  // Switch to Signup/Login
                  TextButton(
                    onPressed: () {
                      setState(() { // Use setState from StatefulBuilder
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
    );
  }
}
