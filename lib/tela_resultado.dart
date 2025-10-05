import 'package:flutter/material.dart';
import '../models/codigo_model.dart';
import 'tela_pdf_nativo.dart';

class TelaResultado extends StatelessWidget {
  final int pageNumber;
  final String pdfPath;
  final CodigoItem? codigoItem;

  const TelaResultado({
    super.key,
    required this.pageNumber,
    required this.pdfPath,
    this.codigoItem,
  });

  void _abrirPdf(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaPdfNativo(
          pdfPath: pdfPath,
          paginaEspecifica: pageNumber,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Image.asset('assets/images/logo_cie_2_3.png', height: 40),
        backgroundColor: Colors.white,
        elevation: 1.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (codigoItem != null) ...[
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Código: ${codigoItem!.codigo}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Descrição: ${codigoItem!.descricao}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tipo: ${codigoItem!.tipo}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Página: ${codigoItem!.pagina}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
            ],

            Center(
              child: ElevatedButton(
                onPressed: () => _abrirPdf(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text(
                  'ABRIR PDF NA PÁGINA $pageNumber',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            Spacer(),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('VOLTAR AO SCANNER'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}