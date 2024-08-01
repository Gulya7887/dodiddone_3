import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dodiddone_3/screens/profile.dart';
// ignore: unused_import
import 'package:dodiddone_3/screens/all_tasks.dart';

import '../screens/completed.dart';
import '../screens/for_today.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

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
        return Dialog( // Use Dialog instead of AlertDialog
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Rounded corners
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            width: 400, // Set width to 400 pixels
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                const Text(
                  'Добавить задачу',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                // Title Field
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Название задачи',
                  ),
                  controller: _titleController,
                ),
                const SizedBox(height: 12),
                // Description Field
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Описание',
                  ),
                  controller: _descriptionController,
                ),
                const SizedBox(height: 12),
                // Deadline Picker
                ElevatedButton(
                  onPressed: () {
                    // Show a date picker
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    ).then((pickedDate) {
                      if (pickedDate != null) {
                        // Show a time picker after the date is selected
                        showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        ).then((pickedTime) {
                          if (pickedTime != null) {
                            setState(() {
                              _deadline = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                pickedTime.hour,
                                pickedTime.minute,
                              );
                            });
                          }
                        });
                      }
                    });
                  },
                  child: const Text('Выбрать дедлайн'),
                ),
                const SizedBox(height: 16),
                // Add Task Button
                ElevatedButton(
                  onPressed: () {
                    // Add the task to the list
                    setState(() {
                      // Add the task to the list
                      _addTask();
                      // Clear the controllers
                      _titleController.clear();
                      _descriptionController.clear();
                    });
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('Добавить'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Controllers for the text fields
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Variable to store the deadline
  DateTime _deadline = DateTime.now();

  // Function to add a new task
  void _addTask() async {
    // Get the values from the controllers
    String title = _titleController.text;
    String description = _descriptionController.text;

    // Add the task to Firestore
    try {
      await FirebaseFirestore.instance.collection('tasks').add({
        'title': title,
        'description': description,
        'deadline': _deadline,
        'priority': 'Normal', // You can add priority later
        'completed': false,
        'forToday': false,
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error adding task: $e');
      // Handle the error appropriately (e.g., show an error message)
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
