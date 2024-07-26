import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}
class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      // Wrap Container with Padding
      padding: const EdgeInsets.all(20.0),
      child: Container(
        height: double.infinity, // Занимает всю высоту экрана
        width: double.infinity, // Занимает всю ширину экрана
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
            // Avatar (You can replace this with a placeholder or actual image)
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                  'assets/AVATAR.png'), // Replace with your avatar image
            ),
            const SizedBox(height: 20),

            // Email
            const Text(
              'example@email.com',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),

            // Email Verification Button (Only show if email is not verified)
ElevatedButton(
              onPressed: () async {},
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
              child: const Text('Подтвердить почту'),
            ),
            const SizedBox(height: 20),

            // Logout Button
            ElevatedButton(
              onPressed: () {
                // Navigate back to login page or home page
                Navigator.pushReplacementNamed(
                    context, '/login'); // Replace with your login route
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
              child: const Text('Выйти'),
            ),
          ],
        ),
      ),
      // ignore: dead_code
    );
  }
}