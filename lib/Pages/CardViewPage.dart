import 'package:expense_manager/Components/CardView.dart';
import 'package:expense_manager/Model/CardModel.dart';
import 'package:expense_manager/Providers/CardProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CardViewPage extends StatefulWidget {
  final CardModel card;

  const CardViewPage({Key? key, required this.card}) : super(key: key);

  @override
  _CardViewPageState createState() => _CardViewPageState();
}

class _CardViewPageState extends State<CardViewPage> {

  void onRemove(card) {
    //
    // --- CHANGE 1: Use 'listen: false' when calling a function ---
    //
    Provider.of<CardProvider>(context, listen: false).removeCard(card);

    Navigator.of(context).pop(true);
  }

  //
  // --- CHANGE 2: Create a new function to show the dialog ---
  //
  void _showDeleteConfirmation(BuildContext context, CardModel card) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Do you want to delete the card "${card.name}"?'),
          actions: [
            // "Cancel" button
            TextButton(
              onPressed: () {
                // Just close the dialog
                Navigator.of(ctx).pop();
              },
              child: Text('Cancel'),
            ),
            // "Delete" button
            TextButton(
              onPressed: () {
                // Call your original remove function
                onRemove(card); 
                // Close the dialog *before* popping the page
                Navigator.of(ctx).pop(); 
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(238, 241, 242, 1),
      appBar: AppBar(
        title: Text("Card View", style: TextStyle(color: Colors.black),),
        backgroundColor: Color.fromRGBO(238, 241, 242, 1),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black45, size: 20,), 
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.black45,
            ),
            //
            // --- CHANGE 3: Call the confirmation dialog instead of onRemove ---
            //
            onPressed: () {
              _showDeleteConfirmation(context, widget.card);
            },
          )
        ], systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Transform.translate(
            offset: Offset.fromDirection(0, 15),
            child: Container(
              height: 210,
              // We use CardView to show the card
              child: CardView(card: widget.card),
            ),
          ),
        ),
      ),
    );
  }
}