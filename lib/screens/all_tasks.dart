import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: unused_import
import 'package:dodiddone_3/screens/completed.dart';
// ignore: unused_import
import 'package:dodiddone_3/screens/for_today.dart';
import 'package:flutter/material.dart';
import '../widgets/task_item.dart';
// ignore: unused_import
import '../pages/main_page.dart'; // Import MainPage
import 'package:dodiddone_3/services/firebase_auth.dart'; // Import AuthService

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final CollectionReference _tasksCollection =
      FirebaseFirestore.instance.collection('tasks'); // Используй правильное имя коллекции
  final AuthService _authService = AuthService(); // Create an instance of AuthService
  String? _userAvatarUrl;
  String? _userId;

  // Функция для обновления UI после завершения задачи
  void _toRight(String documentId) async {
    try {
      // Обновляем статус задачи в Firestore
      await _tasksCollection.doc(documentId).update({'completed': true, 'forToday': false});
    } catch (e) {
      // Обработка ошибок
      // ignore: avoid_print
      print('Ошибка обновления задачи: $e');
    }
  }

  // Функция для обновления UI после переноса задачи на сегодня
  void _toLeft(String documentId) async {
    try {
      // Обновляем статус задачи в Firestore
      await _tasksCollection.doc(documentId).update({'forToday': true, 'completed': false});
    } catch (e) {
      // Обработка ошибок
      // ignore: avoid_print
      print('Ошибка обновления задачи: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    final user = _authService.currentUser;
    if (user != null) {
      setState(() {
        _userAvatarUrl = user.photoURL;
        _userId = user.uid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor, // Set background color to primaryColor
        title: Row(
          children: [
            const Text(
              'DoDidDone - порядок во всем',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 24),
            CircleAvatar(
              radius: 26,
              backgroundImage: _userAvatarUrl != null
                  ? NetworkImage(_userAvatarUrl!)
                  : const AssetImage('assets/AVATAR.png'),
            ),
          ],
        ),
      ),
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
        child: StreamBuilder<QuerySnapshot>(
          stream: _tasksCollection
              .where('createdBy', isEqualTo: _userId) // Фильтруем по ID пользователя
              .where('completed', isEqualTo: false)
              .where('forToday', isEqualTo: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Ошибка загрузки задач'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // Проверяем, не null ли snapshot.data
            if (snapshot.data == null) {
              return const Center(child: Text('Нет данных'));
            }

            final tasks = snapshot.data!.docs.toList();
            if (tasks.isEmpty) {
              return const Center(child: Text('Нет задач? Не может быть!\n Добавим новую задачу'));
            }

            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final taskData = tasks[index].data() as Map<String, dynamic>;
                final title = taskData['title'];
                final description = taskData['description'];
                final deadline = (taskData['deadline'] as Timestamp).toDate(); // Преобразуйте Timestamp в DateTime
                final priority = taskData['priority'];
                final documentId = tasks[index].id; // Получите documentId

                return Dismissible(
                  key: Key(documentId), // Уникальный ключ для каждого элемента
                  background: Container(
                    color: Colors.blue, // Цвет фона для свайпа вправо
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Icon(Icons.check_circle, color: Colors.white), // Иконка для свайпа вправо
                    ),
                  ),
                  secondaryBackground: Container(
                    color: Colors.white, // Цвет фона для свайпа влево
                    child: const Align(
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.calendar_today, color: Colors.blue), // Иконка для свайпа влево
                    ),
                  ),
                  onDismissed: (direction) {
                    if (direction == DismissDirection.startToEnd) { // Свайп вправо
                      _toRight(documentId);
                    } else if (direction == DismissDirection.endToStart) { // Свайп влево
                      _toLeft(documentId);
                    }
                    setState(() {}); // Обновляем состояние, чтобы UI перестроился
                  },
                  // Вот здесь мы возвращаем TaskItem
                  child: TaskItem(
                    title: title,
                    description: description,
                    deadline: deadline, // Передайте преобразованное значение deadline
                    priority: priority,
                    documentId: documentId, // Передайте documentId
                    toRight: () {
                      _tasksCollection
                          .doc(documentId)
                          .update({'completed': true, 'forToday': false});
                    },
                    toLeft: () {
                      _tasksCollection
                          .doc(documentId)
                          .update({'forToday': true, 'completed': false});
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}






 







 