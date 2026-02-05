import 'package:flutter/material.dart';

// Nota: Asumo que ya tienes tu widget MemoryCard. 
// Si se llama diferente, cambia el nombre aquí abajo o importa tu archivo.
// Por ahora, he puesto una "MemoryCard" de prueba al final del archivo para que veas el diseño.

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar transparente para que luzca el fondo
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Memory Game',
          style: TextStyle(
            color: Colors.white, 
            fontWeight: FontWeight.bold,
            fontSize: 24
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        // 1. Fondo atractivo (Gradient)
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6A11CB), // Morado vibrante
              Color(0xFF2575FC), // Azul vibrante
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 2. Panel de Puntuación (Tiempo e Intentos)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildInfoCard("Tiempo", "00:00"),
                    _buildInfoCard("Intentos", "0"),
                  ],
                ),
              ),
              
              const SizedBox(height: 10),

              // 3. La Cuadrícula 6x6 (El corazón del juego)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GridView.builder(
                    // Requisito: 6x6 cartas = 36 items
                    itemCount: 36, 
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6, // 6 columnas (Requisito PDF)
                      crossAxisSpacing: 8, // Espacio horizontal entre cartas
                      mainAxisSpacing: 8,  // Espacio vertical entre cartas
                      childAspectRatio: 0.7, // Ajusta esto para hacerlas más altas o cuadradas
                    ),
                    itemBuilder: (context, index) {
                      // AQUÍ es donde tu compañero conectará la lógica.
                      // Por ahora mostramos el diseño visual.
                      return const MemoryCard(index: index);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget auxiliar para las tarjetitas de info (Tiempo/Intentos)
  Widget _buildInfoCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white, 
              fontSize: 20, 
              fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
    );
  }
}

// --- WIDGET PROVISIONAL ---
// Elimina esto cuando importes tu propio widget "MemoryCard"
class MemoryCard extends StatelessWidget {
  final int index;
  const MemoryCard({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.question_mark, 
          color: Colors.purple.shade300,
          size: 20,
        ),
      ),
    );
  }
}