import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/codigo_model.dart';

class DatabaseService {
  static List<CodigoItem> _codigos = [];

  static Future<void> carregarDados() async {
    try {
      final String response = await rootBundle.loadString('assets/database/codigos.json');
      final data = await json.decode(response);

      _codigos = (data['codigos'] as List)
          .map((item) => CodigoItem.fromJson(item))
          .toList();

      print('✅ Banco de dados carregado: ${_codigos.length} códigos');
    } catch (e) {
      print('❌ Erro ao carregar banco de dados: $e');
    }
  }

  static CodigoItem? buscarPorCodigo(String codigo) {
    try {
      final resultado = _codigos.firstWhere(
            (item) => item.codigo == codigo,
      );
      print('✅ Código encontrado: $codigo - Página: ${resultado.pagina}');
      return resultado;
    } catch (e) {
      print('❌ Código não encontrado: $codigo');
      return null;
    }
  }

  static List<CodigoItem> buscarPorTexto(String texto) {
    return _codigos.where((item) =>
    item.codigo.toLowerCase().contains(texto.toLowerCase()) ||
        item.descricao.toLowerCase().contains(texto.toLowerCase()) ||
        item.tipo.toLowerCase().contains(texto.toLowerCase())).toList();
  }
}