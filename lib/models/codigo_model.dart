class CodigoItem {
  final String codigo;
  final String descricao;
  final int pagina;
  final String tipo;

  CodigoItem({
    required this.codigo,
    required this.descricao,
    required this.pagina,
    required this.tipo,
  });

  factory CodigoItem.fromJson(Map<String, dynamic> json) {
    return CodigoItem(
      codigo: json['codigo'],
      descricao: json['descricao'],
      pagina: json['pagina'],
      tipo: json['tipo'],
    );
  }
}