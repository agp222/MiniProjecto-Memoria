import 'package:flutter/material.dart';
import 'models/card_item.dart'; 
import 'package:shared_preferences/shared_preferences.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  // VARIABLES DE ESTADO Y LÓGICA
  List<CardItem> cards = [];
  int? firstSelectedIndex;
  bool isProcessing = false;
  int intentos = 0;
  int highScore = 0; // Variable para el récord local

  @override
  void initState() {
    super.initState();
    _loadHighScore(); // Carga el récord al iniciar
    _setupGame();
  }

  /// Inicializa el tablero generando 18 pares de cartas.
  /// Cumple con el requerimiento de 6x6 (36 cartas).
  void _setupGame() {
    List<IconData> icons = [
      Icons.face, Icons.favorite, Icons.star, Icons.home, Icons.audiotrack,
      Icons.beach_access, Icons.cake, Icons.directions_car, Icons.pets,
      Icons.sunny, Icons.eco, Icons.flash_on, Icons.anchor, Icons.ac_unit,
      Icons.local_pizza, Icons.flight, Icons.celebration, Icons.brush
    ];

    List<CardItem> tempCards = [];
    for (int i = 0; i < icons.length; i++) {
      tempCards.add(CardItem(id: i, icon: icons[i]));
      tempCards.add(CardItem(id: i, icon: icons[i]));
    }
    tempCards.shuffle();
    
    setState(() {
      cards = tempCards;
      intentos = 0;
      firstSelectedIndex = null;
      isProcessing = false;
    });
  }

  /// Carga el puntaje más alto desde el almacenamiento local.
  void _loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      highScore = prefs.getInt('highScore') ?? 0;
    });
  }

  /// Guarda el récord si los intentos actuales son menores al High Score previo.
  void _saveHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    if (highScore == 0 || intentos < highScore) {
      await prefs.setInt('highScore', intentos);
      _loadHighScore(); 
    }
  }

  /// Maneja la lógica de volteo y validación de parejas.
  /// Requisito: Máximo 2 cartas volteadas simultáneamente.
  void _onCardTap(int index) {
    if (isProcessing || cards[index].isFaceUp || cards[index].isMatched) return;

    setState(() => cards[index].isFaceUp = true);

    if (firstSelectedIndex == null) {
      firstSelectedIndex = index;
    } else {
      setState(() => intentos++);
      isProcessing = true;
      
      if (cards[firstSelectedIndex!].id == cards[index].id) {
        // MATCH ENCONTRADO
        cards[firstSelectedIndex!].isMatched = true;
        cards[index].isMatched = true;
        firstSelectedIndex = null;
        isProcessing = false;

        // Verificar si ganó para guardar el High Score
        if (cards.every((card) => card.isMatched)) {
          _saveHighScore();
        }
      } else {
        // FALLO: Se ocultan tras 1 segundo
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            setState(() {
              cards[firstSelectedIndex!].isFaceUp = false;
              cards[index].isFaceUp = false;
              firstSelectedIndex = null;
              isProcessing = false;
            });
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // --- BONO: RESPONSIVIDAD ---
    // Usamos MediaQuery para adaptar iconos según el tamaño de pantalla
    double screenWidth = MediaQuery.of(context).size.width;
    double iconSize = screenWidth > 600 ? 35 : 22; 

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Memory Game', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _setupGame, // Botón para reiniciar (Instinto de calidad)
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // PANEL DE PUNTUACIÓN
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildInfoCard("Récord", highScore == 0 ? "-" : highScore.toString()),
                    _buildInfoCard("Intentos", intentos.toString()),
                  ],
                ),
              ),
              // TABLERO 6x6
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GridView.builder(
                    itemCount: cards.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6, // REQUISITO 6x6
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.8,
                    ),
                    itemBuilder: (context, index) {
                      final card = cards[index];
                      return GestureDetector(
                        onTap: () => _onCardTap(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: card.isFaceUp || card.isMatched ? Colors.white : Colors.white24,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              if (card.isMatched) const BoxShadow(color: Colors.greenAccent, blurRadius: 4)
                            ],
                          ),
                          child: Center(
                            child: (card.isFaceUp || card.isMatched)
                                ? Icon(card.icon, color: Colors.purple, size: iconSize)
                                : Icon(Icons.help_outline, color: Colors.white54, size: iconSize),
                          ),
                        ),
                      );
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
          Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}