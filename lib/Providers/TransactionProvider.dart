import 'dart:collection';
import 'dart:convert';
import 'package:expense_manager/Model/TransactionModel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionProvider with ChangeNotifier {
  List<TransactionModel> _transactions = [];

  TransactionProvider() {
    _loadTransactions();
  }

  UnmodifiableListView<TransactionModel> get allTransactions =>
      UnmodifiableListView(_transactions);

  void addTransaction(TransactionModel transaction) {
    _transactions.add(transaction);
    _saveTransactions(); 
    notifyListeners(); 
  }

  void removeTransaction(TransactionModel transaction) {
    _transactions.remove(transaction);
    _saveTransactions();
    notifyListeners();
  }

  // --- NEW METHOD: For the Reset Button ---
  Future<void> resetData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('transactions'); // Clear from storage
    _transactions.clear(); // Clear from memory
    notifyListeners();
  }

  Future<void> _saveTransactions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> saveList = _transactions
        .map((t) => json.encode(t.toJson()))
        .toList();
    await prefs.setStringList('transactions', saveList);
  }

  Future<void> _loadTransactions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? loadList = prefs.getStringList('transactions');

    if (loadList != null) {
      _transactions = loadList
          .map((t) => TransactionModel.fromJson(json.decode(t)))
          .toList();
    }
    notifyListeners();
  }
}