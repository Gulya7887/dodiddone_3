// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dodiddone_3/screens/profile.dart';
// ignore: unused_import
import 'package:dodiddone_3/screens/all_tasks.dart';
// ignore: unused_import
import 'package:intl/intl.dart'; // Import intl package for date formatting


import '../screens/completed.dart';
import '../screens/for_today.dart';
import '../widgets/dialog_widget.dart';
import 'package:dodiddone_3/services/firebase_auth.dart'; // Import AuthService

class MainPage extends StatefulWidget {
  const MainPage({super.key});


  @override
  State<MainPage> createState() => _MainPageState();
}


class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final AuthService _authService = AuthService(); // Create an instance of AuthService
  // ignore: unused_field
  String? _userAvatarUrl;

  static const List<Widget> _widgetOptions = <Widget>[
    TaskPage(), // Use TaskPage directly
    ForTodayPage(), // Use ForTodayPage directly
    CompletedPage(), // Use CompletedPage directly
    ProfilePage(), // Use ProfilePage directly
  ];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  // Function to show the dialog for adding a new task
  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const DialogWidget();
      },
    );
  }


  // Controllers for the text fields
  // ignore: unused_field
  final _titleController = TextEditingController();
  // ignore: unused_field
  final _descriptionController = TextEditingController();


  // Variable to store the deadline
  // ignore: unused_field
  final DateTime _deadline = DateTime.now();

  @override
  void initState() {
    super.initState();
    _getUserAvatar();
  }

  Future<void> _getUserAvatar() async {
    final user = _authService.currentUser;
    if (user != null) {
      setState(() {
        _userAvatarUrl = user.photoURL;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Make body behind AppBar
      body: Container( // Wrap the body with a Container
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor, // Use primary color
              Theme.of(context).hintColor, // Use hint color
            ],
            stops: const [0.3, 1.0], // Primary color takes 70% of space
          ),
        ),
        child: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Задачи',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Сегодня',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Выполнено',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white, // Set background color
        selectedItemColor: const Color(0xFF33A0FB), // Set selected item color
        unselectedItemColor: Colors.grey, // Set unselected item color
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog, // Call the dialog function
        child: const Icon(Icons.add),
      ),
    );
  }
}
