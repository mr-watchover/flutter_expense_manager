import 'package:expense_manager/Model/CardModel.dart';
import 'package:expense_manager/Pages/CardViewPage.dart';
import 'package:flutter/material.dart';

class CardView extends StatelessWidget {
  final CardModel card;
  const CardView({Key? key, required this.card}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //
    // --- NEW: Card Number Formatting Logic ---
    //
    String formattedNumber = card.number; // Default to the full number
    if (card.number.length > 8) {
      // Only format if the number is long enough
      String firstFour = card.number.substring(0, 4);
      String lastFour = card.number.substring(card.number.length - 4);
      formattedNumber = "$firstFour **** **** $lastFour";
    }

    return AspectRatio(
      aspectRatio: 3.1 / 2,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CardViewPage(card: card),
            ),
          );
        },
        child: Container(
          margin: EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              // --- CHANGED: Align text to the left ---
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // Top Row: Logo and Balance (This part is the same)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(.8),
                            shape: BoxShape.circle
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(-15, 0),
                          child: Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(.8),
                              shape: BoxShape.circle
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(card.available.toString(), style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),),
                        Text(" " + card.currency, style: TextStyle(color: Colors.white, fontSize: 15),)
                      ],
                    )
                  ],
                ),
                
                // --- CHANGE 1: Moved Card Name here ---
                // This matches the "MasterCard" text in the screenshot
                Text(
                  card.name,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),
                ),

                // --- CHANGE 2: Formatted the Card Number ---
                // This matches the "5512 **** **** 4748" format
                Text(
                  formattedNumber,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    letterSpacing: 3, // Adds space between numbers
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}