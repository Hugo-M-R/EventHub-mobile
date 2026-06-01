import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:eventhub_mobile/screens/login_screen.dart';
void main() {
  testWidgets('Tela de login EventHub carrega', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginScreen(),
      ),
    );
    expect(find.text('EventHub'), findsWidgets);
    expect(find.text('Entrar'), findsWidgets);
  });
}
