import 'package:flutter_test/flutter_test.dart';

import 'package:eventhub_mobile/app/eventhub_app.dart';

void main() {
  testWidgets('Tela de login EventHub carrega', (WidgetTester tester) async {
    await tester.pumpWidget(const EventHubApp());
    expect(find.text('EventHub'), findsWidgets);
    expect(find.text('Entrar'), findsWidgets);
  });
}
