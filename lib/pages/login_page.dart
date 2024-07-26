import 'package:flutter/material.dart';

import 'main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isSignIn = true;

  get primarySwatch => null; 

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
            stops: const [0.7, 1.0], 
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
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
                      width: 280,
                      height: 280,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Title
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 40,
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
                  const SizedBox(height: 20),

                  // Login Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const MainPage()),
                      );
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
                  const SizedBox(height: 16),
                  
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
    );
  }
}
