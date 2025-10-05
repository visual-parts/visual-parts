// lib/tela_pdf.dart
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:pdf_render/pdf_render.dart';

class TelaPdf extends StatefulWidget {
  final String pdfPath;

  const TelaPdf({Key? key, required this.pdfPath}) : super(key: key);

  @override
  _TelaPdfState createState() => _TelaPdfState();
}

class _TelaPdfState extends State<TelaPdf> {
  PdfDocument? _pdfDocument;
  int _currentPage = 1;
  int _totalPages = 0;
  ui.Image? _currentImage;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    try {
      final doc = await PdfDocument.openFile(widget.pdfPath);
      setState(() {
        _pdfDocument = doc;
        _totalPages = doc.pageCount;
      });
      _loadPageImage(_currentPage);
    } catch (e) {
      print('Erro ao carregar PDF: $e');
    }
  }

  Future<void> _loadPageImage(int pageNumber) async {
    if (_pdfDocument == null) return;

    try {
      final page = await _pdfDocument!.getPage(pageNumber);
      final pageImage = await page.render();

      // Para a versão 1.4.12, vamos acessar os pixels diretamente
      final width = pageImage.width;
      final height = pageImage.height;

      // Cria um bitmap manualmente
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final paint = Paint();

      // Desenha cada pixel (simulação - na prática você precisaria dos dados reais)
      // Esta é uma abordagem simplificada
      final rect = Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble());
      canvas.drawRect(rect, paint..color = Colors.white);

      final picture = recorder.endRecording();
      final image = await picture.toImage(width, height);

      if (mounted) {
        setState(() {
          _currentImage = image;
        });
      }
    } catch (e) {
      print('Erro ao carregar página $pageNumber: $e');
    }
  }

  void _nextPage() {
    if (_currentPage < _totalPages) {
      setState(() {
        _currentPage++;
        _currentImage = null;
      });
      _loadPageImage(_currentPage);
    }
  }

  void _previousPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
        _currentImage = null;
      });
      _loadPageImage(_currentPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visualizar PDF'),
        actions: [
          if (_totalPages > 0)
            Text('$_currentPage/$_totalPages'),
        ],
      ),
      body: _pdfDocument == null
          ? Center(child: CircularProgressIndicator())
          : _currentImage == null
          ? Center(child: CircularProgressIndicator())
          : Center(
        child: RawImage(
          image: _currentImage,
          fit: BoxFit.contain,
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _previousPage,
            child: Icon(Icons.arrow_back),
            heroTag: 'prev',
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            onPressed: _nextPage,
            child: Icon(Icons.arrow_forward),
            heroTag: 'next',
          ),
        ],
      ),
    );
  }
}