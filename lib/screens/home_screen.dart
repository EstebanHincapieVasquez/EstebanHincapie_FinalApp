import 'package:aplicacion_final_app/models/token.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {

  final Token token;

  HomeScreen({required this.token});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Examen - Final - App'),
      ),
      body: _formulario()
    );
  }

  _formulario() {

  }
}