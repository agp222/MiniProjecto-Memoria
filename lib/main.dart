import 'package:flutter/material.dart';
import 'game_board.dart'; 

/// El sistema inicia la ejecucion de la aplicacion mediante la funcion principal.
void main() {
  runApp(const MemoryGameApp());
}

/// Esta clase representa la raiz del proyecto y configura los parametros globales.
class MemoryGameApp extends StatelessWidget {
  const MemoryGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    // El sistema retorna un widget de tipo MaterialApp para definir el entorno visual.
    return MaterialApp(
      title: 'Juego de Memoria',
      debugShowCheckedModeBanner: false, // El sistema oculta la etiqueta de depuracion.
      
      // El sistema define el tema visual utilizando Material 3 y colores personalizados.
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      
      // El sistema establece el tablero de juego como la pantalla de inicio.
      home: const GameBoard(), 
    );
  }
}