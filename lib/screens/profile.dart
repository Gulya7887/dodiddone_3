// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Профиль'),
        centerTitle: true,
      ),
      body: Container(
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Avatar (You can replace this with a placeholder or actual image)
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/placeholder_avatar.png'), // Replace with your avatar image
              ),
              const SizedBox(height: 20),

              // Email
              Text(
                user?.email ?? 'Неизвестно',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),

              // Email Verification Button (Only show if email is not verified)
              if (!user!.emailVerified)
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await user!.sendEmailVerification();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Письмо с подтверждением отправлено!')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Ошибка: $e')),
                      );
                    }
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

              // Logout Button
              ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  // Navigate back to login page or home page
                  Navigator.pushReplacementNamed(context, '/login'); // Replace with your login route
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
      ),
    );
  }
}
