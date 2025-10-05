import 'package:flutter/material.dart';
import 'tela_abertura.dart';
import 'tela_principal.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Visual Parts',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/abertura',
      routes: {
        '/abertura': (context) => const TelaAbertura(),
        '/principal': (context) => const TelaPrincipal(),
      },
    );
  }
}