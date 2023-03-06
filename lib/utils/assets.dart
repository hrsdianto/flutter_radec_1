import 'package:flutter/material.dart';
import 'package:flutter_radec_1/models/course_model.dart';

class Assets {
  static const imageAvatar = 'assets/avatar.png';

  static final menuCourse = [
    {
      'title': 'Read',
      'image': 'assets/backend.jpg',
      'modul': 1,
    },
    {
      'title': 'Answer',
      'image': 'assets/frontend.jpg',
      'modul': 1,
    },
    {
      'title': 'Discuss',
      'image': 'assets/backend.jpg',
      'modul': 1,
    },
    {
      'title': 'Explain ',
      'image': 'assets/frontend.jpg',
      'modul': 1,
    },
    {
      'title': 'Create',
      'image': 'assets/backend.jpg',
      'modul': 1,
    }
  ];

  static final profesors = [
    'assets/prof1.png',
    'assets/prof2.png',
    'assets/prof3.png',
    'assets/prof4.png',
  ];

  static final List<Course> courses = [
    Course(
      color: Colors.cyan,
      duration: '8 Hour 2 Min',
      image: 'assets/logo_flutter.png',
      modul: 17,
      name: 'Flutter',
      type: ['Frontend'],
    ),
    Course(
      color: Colors.green,
      duration: '8 Hour 2 Min',
      image: 'assets/logo_androidstudio.png',
      modul: 17,
      name: 'Android Studio',
      type: ['Frontend'],
    ),
    Course(
      color: Colors.blue,
      duration: '8 Hour 2 Min',
      image: 'assets/logo_dart.png',
      modul: 17,
      name: 'Dart',
      type: ['Frontend'],
    ),
    Course(
      color: Colors.red,
      duration: '8 Hour 2 Min',
      image: 'assets/logo_java.png',
      modul: 17,
      name: 'Java',
      type: ['Frontend', 'Backend'],
    ),
    Course(
      color: Colors.orange,
      duration: '8 Hour 2 Min',
      image: 'assets/logo_kotlin.png',
      modul: 17,
      name: 'Kotlin',
      type: ['Frontend', 'Backend'],
    ),
    Course(
      color: Colors.indigo,
      duration: '8 Hour 2 Min',
      image: 'assets/logo_php.png',
      modul: 17,
      name: 'Php',
      type: ['Backend'],
    ),
  ];
}
