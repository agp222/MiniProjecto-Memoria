// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_memory_game/main.dart';

/// El sistema define las pruebas unitarias para verificar la integridad de los widgets.
void main() {
  /// El sistema ejecuta una prueba de humo para validar la carga inicial de la aplicacion.
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // El sistema construye el widget principal y dispara un frame de renderizado.
    await tester.pumpWidget(const MemoryGameApp());

    // El sistema verifica la existencia de elementos textuales especificos en la interfaz.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // El sistema simula una interaccion de usuario mediante un toque en un icono.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // El sistema valida que el estado interno haya cambiado tras la interaccion.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}