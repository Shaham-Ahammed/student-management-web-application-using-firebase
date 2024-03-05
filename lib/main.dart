import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:webapp_student_list/student_list.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyA3XgzTWi7sFEsOWQ5AhKRruZcxTS81C7s",
            appId: "1:1069068264011:web:d055838fa4dd601eaee3ce",
            messagingSenderId: "1069068264011",
            projectId: "flutter-firebase-54d8a",
            storageBucket: "flutter-firebase-54d8a.appspot.com",
             authDomain: "flutter-firebase-54d8a.firebaseapp.com"
            ));
  }
  await Firebase.initializeApp();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Student Management",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const StudentList(),
      
    );
  }
}
