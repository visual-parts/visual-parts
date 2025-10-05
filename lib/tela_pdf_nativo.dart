import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

class TelaPdfNativo extends StatefulWidget {
  final String pdfPath;
  final int? paginaEspecifica; // NOVO PARÂMETRO

  const TelaPdfNativo({
    Key? key,
    required this.pdfPath,
    this.paginaEspecifica, // NOVO PARÂMETRO
  }) : super(key: key);

  @override
  _TelaPdfNativoState createState() => _TelaPdfNativoState();
}

class _TelaPdfNativoState extends State<TelaPdfNativo> {
  bool _isLoading = false;

  Future<void> _abrirPdfExterno() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Copia o arquivo do assets para o diretório temporário
      final byteData = await rootBundle.load(widget.pdfPath);
      final buffer = byteData.buffer;
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/Repack_2.0.1.pdf');

      await tempFile.writeAsBytes(
          buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

      // Abre com o visualizador nativo do Android
      final result = await OpenFile.open(tempFile.path);

      print('Resultado: ${result.message}');

    } catch (e) {
      print('Erro ao abrir PDF: $e');
      _mostrarErro();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _mostrarErro() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Erro ao abrir PDF. Verifique se há um app para visualizar PDFs instalado.'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _voltar() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // CONTEÚDO PRINCIPAL
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.picture_as_pdf,
                    size: 80,
                    color: Colors.white,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Repack_2.0.1.pdf',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 30),
                  if (!_isLoading)
                    ElevatedButton(
                      onPressed: _abrirPdfExterno,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                      child: Text(
                        'ABRIR PDF',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // LOADING
            if (_isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black54,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Abrindo PDF...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // BOTÃO VOLTAR
            Positioned(
              top: 10,
              left: 10,
              child: GestureDetector(
                onTap: _voltar,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}