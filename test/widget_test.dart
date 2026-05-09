import 'package:flutter_test/flutter_test.dart';
import 'package:catalogo_app/main.dart';

void main() {
  testWidgets('App renders movie catalog', (WidgetTester tester) async {
    await tester.pumpWidget(const CatalogoApp());
    expect(find.text('Catálogo de Películas'), findsWidgets);
  });
}
