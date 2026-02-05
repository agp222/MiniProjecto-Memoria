import 'package:flutter/material.dart';
import 'models/card_item.dart'; 
import 'package:shared_preferences/shared_preferences.dart';

/// Clase que gestiona la pantalla principal y la logica del juego de memoria.
class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  // Variables de control para el estado de las cartas y el flujo del juego.
  List<CardItem> cards = [];
  int? firstSelectedIndex;
  bool isProcessing = false;
  int intentos = 0;
  int highScore = 0; // Almacena el record local recuperado.

  @override
  void initState() {
    super.initState();
    _loadHighScore(); // El sistema recupera el record al iniciar.
    _setupGame();
  }

  /// El sistema genera 18 pares de cartas para completar la cuadricula de 6x6.
  void _setupGame() {
    List<IconData> icons = [
      Icons.face, Icons.favorite, Icons.star, Icons.home, Icons.audiotrack,
      Icons.beach_access, Icons.cake, Icons.directions_car, Icons.pets,
      Icons.sunny, Icons.eco, Icons.flash_on, Icons.anchor, Icons.ac_unit,
      Icons.local_pizza, Icons.flight, Icons.celebration, Icons.brush
    ];

    List<CardItem> tempCards = [];
    for (int i = 0; i < icons.length; i++) {
      // Se añaden dos instancias de cada icono para formar las parejas.
      tempCards.add(CardItem(id: i, icon: icons[i]));
      tempCards.add(CardItem(id: i, icon: icons[i]));
    }
    tempCards.shuffle(); // El sistema mezcla la lista aleatoriamente.
    
    setState(() {
      cards = tempCards;
      intentos = 0;
      firstSelectedIndex = null;
      isProcessing = false;
    });
  }

  /// Recupera el valor del record mas alto desde el almacenamiento local.
  void _loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      highScore = prefs.getInt('highScore') ?? 0;
    });
  }

  /// Evalua y guarda el record de intentos si el puntaje actual es superior.
  void _saveHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    if (highScore == 0 || intentos < highScore) {
      await prefs.setInt('highScore', intentos);
      _loadHighScore(); 
    }
  }

  /// Gestiona el evento de seleccion de una carta y la logica de comparacion.
  void _onCardTap(int index) {
    // El sistema ignora el toque si hay procesos pendientes o la carta ya esta visible.
    if (isProcessing || cards[index].isFaceUp || cards[index].isMatched) return;

    setState(() => cards[index].isFaceUp = true);

    if (firstSelectedIndex == null) {
      // El sistema registra el indice de la primera carta seleccionada.
      firstSelectedIndex = index;
    } else {
      setState(() => intentos++);
      isProcessing = true;
      
      if (cards[firstSelectedIndex!].id == cards[index].id) {
        // En caso de coincidencia, el sistema bloquea ambas cartas.
        cards[firstSelectedIndex!].isMatched = true;
        cards[index].isMatched = true;
        firstSelectedIndex = null;
        isProcessing = false;

        // El sistema comprueba si el usuario ha finalizado el juego.
        if (cards.every((card) => card.isMatched)) {
          _saveHighScore();
        }
      } else {
        // Si no hay coincidencia, el sistema oculta las cartas tras un segundo.
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
    // El sistema calcula el tamaño de los iconos segun el ancho de pantalla.
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
            onPressed: _setupGame, // El sistema reinicia el estado del tablero.
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
              // El sistema muestra la informacion de intentos y record actual.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildInfoCard("Record", highScore == 0 ? "-" : highScore.toString()),
                    _buildInfoCard("Intentos", intentos.toString()),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GridView.builder(
                    itemCount: cards.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6, // El sistema genera las 6 columnas solicitadas.
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

  /// El sistema genera una tarjeta visual para mostrar datos de puntuacion.
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