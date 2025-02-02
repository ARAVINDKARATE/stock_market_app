import 'package:flutter/material.dart';

import 'views/home_screen.dart';

void main() {
  runApp(FinosaurusApp());
}

class FinosaurusApp extends StatelessWidget {
  const FinosaurusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finosaurus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StockHomeScreen(),
    );
  }
}
