import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../services/database_service.dart'; // ADICIONE ESTE IMPORT
import 'tela_resultado.dart';

class TelaScan extends StatefulWidget {
  const TelaScan({super.key});

  @override
  State<TelaScan> createState() => _TelaScanState();
}

class _TelaScanState extends State<TelaScan> {
  CameraController? _controller;
  bool _isCameraReady = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );

    await _controller!.initialize();

    setState(() {
      _isCameraReady = true;
    });
  }

  // MÉTODO PRINCIPAL MODIFICADO - SÓ RECONHECIMENTO DE TEXTO
  Future<void> _capturarETratarImagem() async {
    if (_isProcessing || _controller == null) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      // Capturar imagem da câmera
      final image = await _controller!.takePicture();

      // USAR APENAS RECONHECIMENTO DE TEXTO - SEM CÓDIGO DE BARRAS
      final resultadoTexto = await _processarTextoDaImagem(image.path);

      if (resultadoTexto.isNotEmpty) {
        _processarResultadoTexto(resultadoTexto);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Nenhum texto encontrado na imagem')),
        );
      }

    } catch (e) {
      print('Erro ao processar imagem: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao processar imagem: $e')),
      );
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  // MÉTODO APENAS PARA TEXTO - SEM CÓDIGO DE BARRAS
  Future<String> _processarTextoDaImagem(String imagePath) async {
    try {
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final inputImage = InputImage.fromFilePath(imagePath);
      final recognizedText = await textRecognizer.processImage(inputImage);

      await textRecognizer.close();

      return recognizedText.text;
    } catch (e) {
      print('Erro no reconhecimento de texto: $e');
      return '';
    }
  }

  void _processarResultadoTexto(String texto) {
    // Aqui você processa apenas o texto reconhecido
    // Pode buscar por padrões específicos no texto
    print('Texto reconhecido: $texto');

    // Exemplo: buscar códigos no texto reconhecido
    final linhas = texto.split('\n');

    for (final linha in linhas) {
      final linhaLimpa = linha.trim();

      // Buscar por padrões de código (exemplo: 519498333)
      if (RegExp(r'^\d{9}$').hasMatch(linhaLimpa)) {
        _verificarCodigoNoBanco(linhaLimpa);
        return;
      }

      // Ou buscar por padrões mais complexos
      if (linhaLimpa.length >= 6 && RegExp(r'\d').hasMatch(linhaLimpa)) {
        _verificarCodigoNoBanco(linhaLimpa);
        return;
      }
    }

    // Se não encontrou padrão específico, mostrar texto completo
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Texto Reconhecido'),
        content: SingleChildScrollView(
          child: Text(texto),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _verificarCodigoNoBanco(String codigo) {
    // Usar seu DatabaseService existente
    final resultado = DatabaseService.buscarPorCodigo(codigo);

    if (resultado != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TelaResultado(
            pageNumber: resultado.pagina,
            pdfPath: 'assets/pdf/catalogo.pdf',
            codigoItem: resultado,
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Código Não Encontrado'),
          content: Text('O código "$codigo" não foi encontrado no banco de dados.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/logo_cie_2_3.png', height: 40),
        backgroundColor: Colors.white,
        elevation: 1.0,
        automaticallyImplyLeading: false,
      ),
      body: _isCameraReady
          ? CameraPreview(_controller!)
          : Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        onPressed: _isProcessing ? null : _capturarETratarImagem,
        backgroundColor: _isProcessing ? Colors.grey : Colors.orange,
        child: _isProcessing
            ? CircularProgressIndicator(color: Colors.white)
            : Icon(Icons.camera_alt, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}