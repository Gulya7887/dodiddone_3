import 'package:flutter/material.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  // Sample task data (replace with your actual data source)
  List<String> tasks = [
    'Купить продукты',
    'Записаться на прием к врачу',
    'Позвонить другу',
    'Сделать домашнее задание',
  ];

  @override
  Widget build(BuildContext context) {
    return 
       ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(tasks[index]),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  tasks.removeAt(index);
                });
              },
            ),
          );
        },
      );
      // ignore: dead_code, unused_label
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add a new task (replace with your actual task creation logic)
          setState(() {
            tasks.add('Новая задача');
          });
        },
        child: const Icon(Icons.add),
      );
    ;
  }
}
