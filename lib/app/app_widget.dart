
import 'package:e_reader/app/views/home_page.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Reader',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.lightBlue,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}