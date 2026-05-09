import 'package:flutter_test/flutter_test.dart';
import 'package:catalogo_app/main.dart';

void main() {
  testWidgets('App renders CineHub home', (WidgetTester tester) async {
    await tester.pumpWidget(const CineHubApp());
    expect(find.text('CineHub'), findsWidgets);
  });
}
