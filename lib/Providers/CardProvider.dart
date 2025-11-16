import 'dart:collection';
import 'dart:convert';

import 'package:expense_manager/Model/CardModel.dart'; // <-- FIX 1: Corrected typo
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardProvider with ChangeNotifier {
  List<CardModel> cards = [];

  CardProvider() {
    initialState();
  }

  UnmodifiableListView<CardModel> get allCards => UnmodifiableListView(cards);

  void initialState() {
    syncDataWithProvider();
  }

  void addCard(CardModel _card) {
    cards.add(_card);
    updateSharedPrefrences();
    notifyListeners();
  }

  void removeCard(CardModel _card) {
    cards.removeWhere((card) => card.number == _card.number);
    updateSharedPrefrences();
    notifyListeners();
  }

  int getCardLength() {
    return cards.length;
  }

  // --- NEW METHOD 1: For updating balance from transactions ---
  void updateCardBalance(String cardNumber, int amount, String type) {
    try {
      // Find the card that matches the transaction's card number
      CardModel card = cards.firstWhere((c) => c.number == cardNumber);
      
      // Update its balance
      if (type == '+') {
        card.available += amount; // Add income
      } else {
        card.available -= amount; // Subtract expense
      }

      // Re-save the *entire* list of cards with the new balance
      updateSharedPrefrences();
      
      // Tell the UI to update
      notifyListeners();

    } catch (e) {
      print("Error: Card not found. $e");
    }
  }

  // --- NEW METHOD 2: For the Reset Button ---
  Future<void> resetData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('cards'); // Clear from storage
    cards.clear(); // Clear from memory
    notifyListeners();
  }

  Future updateSharedPrefrences() async {
    List<String> myCards = cards.map((f) => json.encode(f.toJson())).toList();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    await prefs.setStringList('cards', myCards);
  }

  Future syncDataWithProvider() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var reslut = prefs.getStringList('cards');

    if (reslut != null) {
      cards = reslut.map((f) => CardModel.fromJson(json.decode(f))).toList();
    }

    notifyListeners();
  }
}