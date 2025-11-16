import 'package:expense_manager/Model/CardModel.dart';
import 'package:expense_manager/Pages/CardViewPage.dart'; // <-- Added this import
import 'package:flutter/material.dart';

//
// --- FIX 1: Changed to a StatelessWidget ---
//
class CardView extends StatelessWidget {

  final CardModel card;

  //
  // --- FIX 2: Fixed the constructor for null-safety ---
  //
  const CardView({Key? key, required this.card}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3.1 / 2,
      child: GestureDetector(
        //
        // --- FIX 3: Added the onTap navigation logic ---
        //
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(card.name, style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    FittedBox(
                      fit: BoxFit.contain,
                      child: Text(card.number, style: TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 10, fontWeight: FontWeight.bold)),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}