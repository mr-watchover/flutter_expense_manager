import 'package:expense_manager/Model/CardModel.dart';
import 'package:expense_manager/Providers/CardProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddCardPage extends StatefulWidget {
  @override
  _AddCardPageState createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {

  //
  // --- CHANGE 1: Add a GlobalKey for the Form ---
  //
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = new TextEditingController();
  TextEditingController numberController = new TextEditingController();
  TextEditingController bankNameController = new TextEditingController();
  TextEditingController availableController = new TextEditingController();
  TextEditingController currencyController = new TextEditingController();

  void onAdd() {
    //
    // --- CHANGE 2: Check if the form is valid before proceeding ---
    //
    if (_formKey.currentState!.validate()) {
      // If the form is valid, create the card
      CardModel card = CardModel(name: nameController.text, 
        number: numberController.text, 
        bankName: bankNameController.text, 
        available: int.tryParse(availableController.text) ?? 0,
        currency: currencyController.text
      );

      //
      // --- CHANGE 3: Use 'listen: false' when calling a function ---
      //
      Provider.of<CardProvider>(context, listen: false).addCard(card);

      //
      // --- CHANGE 4: Show a confirmation SnackBar ---
      //
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"${card.name}" card added!'),
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(238, 241, 242, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Add Card", style: TextStyle(color: Colors.black),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black45, size: 20,), 
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ), systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: EdgeInsets.all(15.0),
            //
            // --- CHANGE 5: Wrap your Column in a Form widget ---
            //
            child: Form(
              key: _formKey, // Assign the key
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    //
                    // --- CHANGE 6: Change TextField to TextFormField ---
                    //
                    child: TextFormField( // <-- Was TextField
                      controller: nameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Card name",
                        hintStyle: TextStyle(color: Colors.grey)
                      ),
                      //
                      // --- CHANGE 7: Add a validator ---
                      //
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a card name';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: TextFormField( // <-- Was TextField
                      controller: numberController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Card Number",
                        hintStyle: TextStyle(color: Colors.grey)
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a card number';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: TextFormField( // <-- Was TextField
                      controller: bankNameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Bank Name",
                        hintStyle: TextStyle(color: Colors.grey)
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a bank name';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: TextFormField( // <-- Was TextField
                      controller: availableController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Available Balance",
                        hintStyle: TextStyle(color: Colors.grey)
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a balance';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: TextFormField( // <-- Was TextField
                      controller: currencyController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Currency (e.g., USD, INR)",
                        hintStyle: TextStyle(color: Colors.grey)
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a currency';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  MaterialButton(
                    elevation: 0,
                    minWidth: double.infinity,
                    padding: EdgeInsets.all(15),
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Text('Add', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),), 
                    onPressed: () => onAdd(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}