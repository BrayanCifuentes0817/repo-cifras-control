// Importa el widget Dashboard, que será la pantalla principal de la aplicación.
import 'package:demo_cifras_control/widgets/dashboard.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo Cifras',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //Define la pantalla inicial de la aplicación.
      //En este caso, el widget Dashboard.
      home: const Dashboard(),
    );
  }
}
