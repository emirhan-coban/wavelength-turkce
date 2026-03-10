import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:wavelength/main.dart';
import 'package:wavelength/providers/game_provider.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => GameProvider(),
        child: const ZihindarApp(),
      ),
    );
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
