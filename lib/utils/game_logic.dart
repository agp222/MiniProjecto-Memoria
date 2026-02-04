import 'package:flutter/material.dart';
import '../models/card_item.dart';

class GameLogic {
  final List<IconData> _hiddenIcons = [
    Icons.pets,
    Icons.ac_unit,
    Icons.access_alarm,
    Icons.accessibility,
    Icons.account_balance,
    Icons.account_circle,
    Icons.adb,
    Icons.add_a_photo,
    Icons.add_shopping_cart,
    Icons.airplanemode_active,
    Icons.airport_shuttle,
    Icons.album,
    Icons.all_inclusive,
    Icons.anchor,
    Icons.apartment,
    Icons.api,
    Icons.architecture,
    Icons.assistant_photo,
  ];

  List<CardItem> generateCards() {
    List<CardItem> cards = [];

    for (int i = 0; i < 18; i++) {
      cards.add(CardItem(id: i, icon: _hiddenIcons[i]));
      cards.add(CardItem(id: i, icon: _hiddenIcons[i]));
    }

    cards.shuffle();
    return cards;
  }
}