import 'package:flutter/material.dart';
import 'models/card_item.dart'; 

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  // VARIABLES DE LÓGICA (Añadidas para que funcione el juego)
  List<CardItem> cards = [];
  int? firstSelectedIndex;
  bool isProcessing = false;
  int intentos = 0;

  @override
  void initState() {
    super.initState();
    _setupGame();
  }

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
    });
  }

  void _onCardTap(int index) {
    if (isProcessing || cards[index].isFaceUp || cards[index].isMatched) return;

    setState(() => cards[index].isFaceUp = true);

    if (firstSelectedIndex == null) {
      firstSelectedIndex = index;
    } else {
      intentos++;
      isProcessing = true;
      if (cards[firstSelectedIndex!].id == cards[index].id) {
        cards[firstSelectedIndex!].isMatched = true;
        cards[index].isMatched = true;
        firstSelectedIndex = null;
        isProcessing = false;
      } else {
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Memory Game', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
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
                      crossAxisCount: 6,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.7,
                    ),
                    itemBuilder: (context, index) {
                      final card = cards[index];
                      return GestureDetector(
                        onTap: () => _onCardTap(index),
                        child: Container(
                          decoration: BoxDecoration(
                            color: card.isFaceUp || card.isMatched ? Colors.white : Colors.white24,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: (card.isFaceUp || card.isMatched)
                                ? Icon(card.icon, color: Colors.purple, size: 20)
                                : const Icon(Icons.question_mark, color: Colors.white54),
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
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: Colors.white70)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}