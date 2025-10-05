import 'package:flutter/material.dart';

class TelaAbertura extends StatefulWidget {
  const TelaAbertura({super.key});

  @override
  State<TelaAbertura> createState() => _TelaAberturaState();
}

class _TelaAberturaState extends State<TelaAbertura> {
  @override
  void initState() {
    super.initState();
    // Vai para tela principal após 3 segundos
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/principal');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo_cie_2_3.png', height: 150),
            const SizedBox(height: 20),
            const CircularProgressIndicator(color: Colors.orange),
            const SizedBox(height: 20),
            const Text(
              'Visual Parts',
              style: TextStyle(
                fontSize: 24, 
                fontWeight: FontWeight.bold, 
                color: Colors.orange
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Scanner de Códigos',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/principal');
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.skip_next, color: Colors.white),
      ),
    );
  }
}
