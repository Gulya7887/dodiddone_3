import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dodiddone_3/services/firebase_auth.dart'; // Import AuthService

class DialogWidget extends StatefulWidget {
  final String? documentId; // Добавьте documentId
  final String? title;
  final String? description;
  final DateTime? deadline;

  const DialogWidget({
    super.key,
    this.documentId,
    this.title,
    this.description,
    this.deadline,
  });

  @override
  State<DialogWidget> createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _deadline = DateTime.now();
  final AuthService _authService = AuthService(); // Create an instance of AuthService
  String? _userId;

  @override
  void initState() {
    super.initState();
    if (widget.title != null) {
      _titleController.text = widget.title!;
    }
    if (widget.description != null) {
      _descriptionController.text = widget.description!;
    }
    if (widget.deadline != null) {
      _deadline = widget.deadline!;
    }
    _getUserId();
  }

  Future<void> _getUserId() async {
    final user = _authService.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Function to add or update a task
  void _saveTask() async {
    String title = _titleController.text;
    String description = _descriptionController.text;

    if (widget.documentId != null) {
      // Update existing task
      try {
        await FirebaseFirestore.instance
            .collection('tasks')
            .doc(widget.documentId)
            .update({
          'title': title,
          'description': description,
          'deadline': _deadline,
          'priority': 'Normal', // You can add priority later
          'completed': false,
          'forToday': false,
          'createdBy': _userId, // Add createdBy field
        });
      } catch (e) {
        // ignore: avoid_print
        print('Error updating task: $e');
        // Handle the error appropriately (e.g., show an error message)
      }
    } else {
      // Add new task
      try {
        await FirebaseFirestore.instance.collection('tasks').add({
          'title': title,
          'description': description,
          'deadline': _deadline,
          'priority': 'Normal', // You can add priority later
          'completed': false,
          'forToday': false,
          'createdBy': _userId, // Add createdBy field
        });
      } catch (e) {
        // ignore: avoid_print
        print('Error adding task: $e');
        // Handle the error appropriately (e.g., show an error message)
      }
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
            Text(
              widget.documentId != null ? 'Редактировать задачу' : 'Добавить задачу',
              style: const TextStyle(
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
            Row(
              children: [
                Text(
                  'Дедлайн: ${DateFormat('dd.MM.yy HH:mm').format(_deadline)}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: () {
                    // Show a date picker
                    showDatePicker(
                      context: context,
                      initialDate: _deadline,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    ).then((pickedDate) {
                      if (pickedDate != null) {
                        // Show a time picker after the date is selected
                        showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(_deadline),
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
                  icon: const Icon(Icons.calendar_today),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Add Task Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Отмена
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.blue, // Set border color to blue
                        width: 2, // Set border width to 2 pixels
                      ),
                    ),
                    child: const Text(
                      'Отмена',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                // Добавить
                GestureDetector(
                  onTap: _saveTask,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.blue,
                    ),
                    child: const Text(
                      'Сохранить',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}




