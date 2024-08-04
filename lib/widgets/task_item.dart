// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:dodiddone_3/thems/theme.dart';

import 'dialog_widget.dart'; // Import your theme file


class TaskItem extends StatelessWidget {
  final String title;
  final String description;
  final DateTime deadline;
  final Function? onDelete; // Add onDelete callback
  final Function? onEdit; // Add onEdit callback
  final Function? toLeft; // Вызываем функцию, если элемент был сдвинут влево
  final Function? toRight; // Вызываем функцию, если элемент был сдвинут вправо
  final String documentId; // Добавьте documentId


  const TaskItem({
    super.key,
    required this.title,
    required this.description,
    required this.deadline,
    this.onEdit,
    this.onDelete,
    this.toLeft,
    this.toRight,
    required this.documentId, required priority, // Добавьте documentId
  });


  @override
  Widget build(BuildContext context) {
    // Format the deadline using intl
    String formattedDeadline = DateFormat('dd.MM.yy HH:mm').format(deadline);


    // Calculate the difference between the deadline and now
    Duration difference = deadline.difference(DateTime.now());


    // Determine the gradient based on the difference
    LinearGradient gradient = getGradientForDeadline(difference);


    return Container(
      margin: const EdgeInsets.all(16.0), // Add margin for spacing
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFB8B8B8), // Shadow color
            blurRadius: 4, // Shadow blur radius
            offset: Offset(0, 4), // Shadow offset
            spreadRadius: 2, // Add spread radius for outer shadow
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row for title and icons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Title
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              // Icons
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // Show the edit dialog
                      _showEditDialog(context);
                    },
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () {
                      // Show the delete confirmation dialog
                      _showDeleteConfirmationDialog(context);
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Description
          Text(
            description,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 8),
          // Deadline
          Text(
            'Дедлайн: $formattedDeadline', // Use the formatted deadline
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }


  // Function to get gradient based on deadline
  LinearGradient getGradientForDeadline(Duration difference) {
    if (difference.inDays < 1) {
      return const LinearGradient(
        colors: [const Color(0xFFFF20A6), Colors.white],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if (difference.inDays < 3) {
      return LinearGradient(
        colors: [DoDidDoneTheme.lightTheme.hintColor, Colors.white],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else {
      return const LinearGradient(
        colors: [Color(0xFF33A0FB), Colors.white],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
  }


  // Function to show the edit dialog
  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogWidget(
          documentId: documentId, // Передайте documentId
          title: title, // Передайте title
          description: description, // Передайте description
          deadline: deadline, // Передайте deadline
        );
      },
    );
  }


  // Function to show the delete confirmation dialog
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Удалить задачу?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [              
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2276FD),
                ),
              ), // Display the task title
            ],
          ),
          actions: [
            // Cancel Button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Отмена'),
            ),
            // Delete Button
            TextButton(
              onPressed: () {
                // Delete the task from Firestore
                FirebaseFirestore.instance
                    .collection('tasks')
                    .doc(documentId)
                    .delete()
                    .then((value) {
                  // Close the dialog
                  Navigator.of(context).pop();
                });
              },
              child: const Text('Удалить'),
            ),
          ],
        );
      },
    );
  }


  // Function to mark a task as completed


  // Function to mark a task for today
}

