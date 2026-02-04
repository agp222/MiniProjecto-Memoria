import 'package:flutter/material.dart';

class CardItem {
  final int id;
  final IconData icon;
  bool isFaceUp;
  bool isMatched;

  CardItem({
    required this.id,
    required this.icon,
    this.isFaceUp = false,
    this.isMatched = false,
  });
}