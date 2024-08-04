import 'package:flutter/material.dart';
import 'package:dodiddone_3/services/firebase_auth.dart'; // Импорт AuthService
// ignore: unused_import
import 'package:dodiddone_3/pages/login_page.dart'; // Импорт LoginPage
import 'package:cloud_firestore/cloud_firestore.dart'; // Импорт Firestore
import 'package:dodiddone_3/utils/image_picker_util.dart'; // Импорт ImagePickerUtil
import 'package:firebase_storage/firebase_storage.dart'; // Импорт Firebase Storage
import 'dart:io'; // Импорт File

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService(); // Создание экземпляра AuthService
  String? _userEmail;
  String? _userAvatarUrl;
  String? _userId; // Добавление переменной для хранения ID пользователя

  // Переменные для подсчета задач
  // ignore: unused_field
  int _allTasksCount = 0;
  int _forTodayTasksCount = 0;
  int _completedTasksCount = 0;
  int _newTasksCount = 0; // Переменная для подсчета новых задач

  // Переменная для хранения выбранного изображения
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _getUserData();
    _countTasks(); // Вызов функции для подсчета задач при инициализации
  }

  Future<void> _getUserData() async {
    final user = _authService.currentUser;
    if (user != null) {
      setState(() {
        _userEmail = user.email;
        _userAvatarUrl = user.photoURL;
        _userId = user.uid; // Получение ID пользователя
      });
    }
  }

  // Функция для подсчета задач
  Future<void> _countTasks() async {
    final tasksCollection = FirebaseFirestore.instance.collection('tasks');

    // Подсчет всех задач
    QuerySnapshot allTasksSnapshot = await tasksCollection
        .where('createdBy', isEqualTo: _userId) // Фильтрация по ID пользователя
        .get();
    _allTasksCount = allTasksSnapshot.docs.length;

    // Подсчет задач на сегодня
    QuerySnapshot forTodayTasksSnapshot = await tasksCollection
        .where('createdBy', isEqualTo: _userId) // Фильтрация по ID пользователя
        .where('forToday', isEqualTo: true)
        .get();
    _forTodayTasksCount = forTodayTasksSnapshot.docs.length;

    // Подсчет выполненных задач
    QuerySnapshot completedTasksSnapshot = await tasksCollection
        .where('createdBy', isEqualTo: _userId) // Фильтрация по ID пользователя
        .where('completed', isEqualTo: true)
        .get();
    _completedTasksCount = completedTasksSnapshot.docs.length;

    // Подсчет новых задач
    QuerySnapshot newTasksSnapshot = await tasksCollection
        .where('createdBy', isEqualTo: _userId) // Фильтрация по ID пользователя
        .where('forToday', isEqualTo: false)
        .where('completed', isEqualTo: false)
        .get();
    _newTasksCount = newTasksSnapshot.docs.length;

    setState(() {}); // Обновление состояния для перерисовки UI
  }

  // Функция для показа диалогового окна подтверждения выхода
  Future<void> _showExitConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Пользователь должен нажать кнопку!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Выход'),
          content: const Text('Вы действительно хотите выйти?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Закрытие диалогового окна
              },
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () async {
                await _authService.signOut();
                setState(() {
                  _userEmail = null; // Обновление _userEmail
                  _userAvatarUrl = null; // Обновление _userAvatarUrl
                });
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                  return const LoginPage();
                })); // Переход на LoginPage
              },
              child: const Text('Выйти'),
            ),
          ],
        );
      },
    );
  }

  // Функция для выбора изображения из галереи или с камеры
  Future<void> _selectImage() async {
    final pickedImage = await showModalBottomSheet<File?>(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Из галереи'),
              onTap: () async {
                Navigator.pop(context, await ImagePickerUtil.pickImageFromGallery());
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('С камеры'),
              onTap: () async {
                Navigator.pop(context, await ImagePickerUtil.pickImageFromCamera());
              },
            ),
          ],
        );
      },
    );

    setState(() {
      _selectedImage = pickedImage;
    });
  }

  // Функция для загрузки изображения в Firebase Storage
  Future<void> _uploadImageToFirebase() async {
    if (_selectedImage != null) {
      // Получение ID пользователя
      String userId = _userId!; // Использование _userId

      // Создание уникального имени файла
      String fileName = '$userId-${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Загрузка файла в Firebase Storage
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('users/$userId/images/$fileName');
      UploadTask uploadTask = ref.putFile(_selectedImage!);
      await uploadTask.whenComplete(() async {
        final downloadUrl = await ref.getDownloadURL();
        // Проверяем, существует ли документ пользователя
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(_userId)
            .get();
        if (userDoc.exists) {
          // Обновляем аватар пользователя в Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(_userId)
              .update({'avatarUrl': downloadUrl});
          // Обновляем аватар пользователя в _userAvatarUrl
          setState(() {
            _userAvatarUrl = downloadUrl; // Добавляем эту строку
            _selectedImage = null; // Скрываем кнопку после загрузки
          });
        } else {
          // Если документ не существует, создаем его
          await FirebaseFirestore.instance
              .collection('users')
              .doc(_userId)
              .set({'avatarUrl': downloadUrl});
          // Обновляем аватар пользователя в _userAvatarUrl
          setState(() {
            _userAvatarUrl = downloadUrl; // Добавляем эту строку
            _selectedImage = null; // Скрываем кнопку после загрузки
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEmailVerified = _authService.currentUser?.emailVerified ?? false;

    // ignore: prefer_typing_uninitialized_variables
    
    return Scaffold( // Обертка контента в Scaffold
      // Удаление AppBar
      body: Padding(
        padding: const EdgeInsets.all(0.0),
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
              // Аватар
              Stack(
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!) // Использование выбранного изображения, если оно есть
                        : _userAvatarUrl != null
                            ? NetworkImage(_userAvatarUrl!) // Использование аватарки пользователя, если она есть // NetworkImage
                            : const AssetImage('assets/AVATAR.png'), // Иначе использование стандартной аватарки // AssetImage
                  ),
                  Positioned(
                    bottom: -14,
                    right: -12,
                    child: IconButton(
                      onPressed: _selectImage,
                      icon: const Icon(Icons.photo_camera),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Email
              Text(
                _userEmail ?? 'example@email.com', // Отображение "example@email.com", если _userEmail == null
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2276FD),
                ),
              ),
              const SizedBox(height: 12),

              // Кнопка подтверждения почты (отображается, если почта не подтверждена)
              if (!isEmailVerified && _userEmail != null) // Проверка, что _userEmail не null
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
                            onPressed: () => Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) => const LoginPage())),
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
              const SizedBox(height: 24),

              // Кнопка загрузки изображения в Firebase Storage
              if (_selectedImage != null)
                ElevatedButton(
                  onPressed: _uploadImageToFirebase,
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
                  child: const Text('Сохранить аватар'),
                ),
              const SizedBox(height: 24),

              // Количество новых задач
              Text(
                'Новые задачи: $_newTasksCount', // Изменили название
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),

              // Количество задач на сегодня
              Text(
                'Задачи на сегодня: $_forTodayTasksCount',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),

              // Количество выполненных задач
              Text(
                'Выполненные: $_completedTasksCount',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),

              // Кнопка выхода
              ElevatedButton(
                onPressed: _showExitConfirmationDialog, // Вызов диалогового окна
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
