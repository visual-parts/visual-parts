import 'package:flutter/material.dart';
import 'package:visual_parts/tela_scan.dart';
import 'tela_pdf_nativo.dart'; // CORRIGIDO: Importe o arquivo correto

class TelaPrincipal extends StatelessWidget {
  const TelaPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // BOTÃO SCAN PARTS
              SizedBox(
                width: 200,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TelaScan()),
                    );
                  },
                  child: const Text(
                    "SCAN PARTS",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // BOTÃO ABRIR PDF (ATUALIZADO)
              SizedBox(
                width: 200,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TelaPdfNativo(
                          pdfPath: 'assets/pdf/Repack_2.0.1.pdf',
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "ABRIR PDF",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
              Image.asset(
                'assets/images/Logo_CIE_Abertura.png',
                width: 150,
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}