import 'package:flutter/material.dart';
import 'package:dodiddone_3/services/firebase_auth.dart'; // Import AuthService
// ignore: unused_import
import 'package:dodiddone_3/pages/login_page.dart'; // Import LoginPage

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService(); // Create an instance of AuthService
  String? _userEmail;
  String? _userAvatarUrl;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    final user = _authService.currentUser;
    if (user != null) {
      setState(() {
        _userEmail = user.email;
        _userAvatarUrl = user.photoURL;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEmailVerified = _authService.currentUser?.emailVerified ?? false;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).hintColor,
            ],
            stops: const [0.3, 1.0],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Avatar
            CircleAvatar(
              radius: 70,
              backgroundImage: _userAvatarUrl != null
                  ? NetworkImage(_userAvatarUrl!)
                  : const AssetImage('assets/AVATAR.png'),
            ),
            const SizedBox(height: 20),

            // Email
            Text(
              _userEmail ?? 'example@email.com',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),

            // Кнопка подтверждения почты (отображается, если почта не подтверждена)
            if (!isEmailVerified)
              ElevatedButton(
                onPressed: () async {
                  await _authService.sendEmailVerification();
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Подтверждение почты'),
                      content: const Text(
                          'Письмо с подтверждением отправлено на ваш адрес.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pushReplacement(context , 
                          MaterialPageRoute (builder: (context) => const LoginPage() )),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
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
                child: const Text('Подтвердить почту'),
              ),
            const SizedBox(height: 20),

            // Кнопка выхода
            ElevatedButton(
              onPressed: () async {
                await _authService.signOut();
                Navigator.pushReplacementNamed(context, '/login');
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
              child: const Text('Выйти'),
            ),
          ],
        ),
      ),
    );
  }
}









