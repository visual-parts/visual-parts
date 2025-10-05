// This is a basic Flutter widget test.

import 'package:flutter_test/flutter_test.dart';
import 'package:visual_parts/main.dart'; // Garante que a importação está correta

void main() {
  // Um novo teste mais simples, que apenas verifica se o app inicia sem erros.
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Constrói o nosso app e dispara um frame.
    await tester.pumpWidget(const MyApp());

    // A verificação é simples: se o comando pumpWidget acima não lançou uma exceção,
    // significa que o widget principal da aplicação foi construído com sucesso.
    // Podemos adicionar uma verificação genérica para garantir que algo foi renderizado.
    expect(find.byType(MyApp), findsOneWidget);
  });
}