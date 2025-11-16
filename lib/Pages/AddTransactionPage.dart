import 'package:expense_manager/Model/CardModel.dart';
import 'package:expense_manager/Model/TransactionModel.dart';
import 'package:expense_manager/Providers/CardProvider.dart';
import 'package:expense_manager/Providers/TransactionProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddTransactionPage extends StatefulWidget {
  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final amountController = TextEditingController();
  final categoryController = TextEditingController();

  String _selectedType = '-'; // Default to Expense
  String? _selectedCardNumber; // --- NEW: To store the selected card ---

  void onAdd() {
    if (_formKey.currentState!.validate()) {
      // Check if a card is selected
      if (_selectedCardNumber == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a card!')),
        );
        return; // Stop if no card is selected
      }

      final newTransaction = TransactionModel(
        name: nameController.text,
        price: int.tryParse(amountController.text) ?? 0,
        category: categoryController.text,
        date: DateTime.now(),
        type: _selectedType,
        currency: 'USD', 
        cardNumber: _selectedCardNumber!, // <-- Pass the selected card number
      );

      // --- NEW: Get CardProvider to update balance ---
      final cardProvider = Provider.of<CardProvider>(context, listen: false);

      // Call BOTH providers to update their data
      Provider.of<TransactionProvider>(context, listen: false)
          .addTransaction(newTransaction);
          
      cardProvider.updateCardBalance(
        _selectedCardNumber!,
        newTransaction.price,
        newTransaction.type,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transaction Added!')),
      );

      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // --- NEW: Get card list for the dropdown ---
    final cardProvider = Provider.of<CardProvider>(context);

    return Scaffold(
      backgroundColor: Color.fromRGBO(238, 241, 242, 1),
      appBar: AppBar(
        title: Text("Add Transaction", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black45, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                // --- NEW: Card Selector Dropdown ---
                DropdownButtonFormField<String>(
                  initialValue: _selectedCardNumber,
                  hint: Text('Select Card to Use'),
                  decoration: InputDecoration(
                    labelText: 'Card',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: cardProvider.allCards.map((CardModel card) {
              // --- FIX: Safely get the last 4 digits ---
              String lastFourDigits = card.number.length > 4
                  ? card.number.substring(card.number.length - 4)
                  : card.number;

              return DropdownMenuItem<String>(
                value: card.number,
                child: Text("${card.name} (...$lastFourDigits)"),
              );
            }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCardNumber = newValue;
                    });
                  },
                  validator: (value) => value == null ? 'Please select a card' : null,
                ),
                SizedBox(height: 15),

                // Type Selector
                DropdownButtonFormField<String>(
                  initialValue: _selectedType,
                  decoration: InputDecoration(
                    labelText: 'Transaction Type',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: [
                    DropdownMenuItem(value: '-', child: Text('Expense')),
                    DropdownMenuItem(value: '+', child: Text('Income')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value!;
                    });
                  },
                ),
                SizedBox(height: 15),

                // Transaction Name
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name (e.g., Coffee, Salary)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),

                // Amount
                TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),

                // Category
                TextFormField(
                  controller: categoryController,
                  decoration: InputDecoration(
                    labelText: 'Category (e.g., Food, Transport)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a category';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),

                // Add Button
                MaterialButton(
                  elevation: 0,
                  minWidth: double.infinity,
                  padding: EdgeInsets.all(15),
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Text('Add Transaction', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  onPressed: onAdd,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}