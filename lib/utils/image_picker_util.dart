import 'dart:io';

// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerUtil {
  static final ImagePicker _picker = ImagePicker();

  // Метод для выбора изображения из галереи
  static Future<File?> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50, // Качество изображения (0-100)
      );
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
    } catch (e) {
      // ignore: avoid_print
      print('Ошибка при выборе изображения из галереи: $e');
    }
    return null;
  }

  // Метод для выбора изображения с камеры
  static Future<File?> pickImageFromCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50, // Качество изображения (0-100)
      );
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
    } catch (e) {
      // ignore: avoid_print
      print('Ошибка при выборе изображения с камеры: $e');
    }
    return null;
  }
}
