import 'package:expense_manager/Model/TransactionModel.dart'; // <-- THIS LINE IS NOW FIXED
import 'package:flutter/material.dart';

class TransactionView extends StatelessWidget {
  //
  // FIX 1: Added 'Key?' and 'required' to fix null-safety
  //
  const TransactionView({Key? key, required this.transaction}) : super(key: key);

  final TransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    //
    // FIX 2: Wrapped the whole widget in a 'GestureDetector'
    //
    return GestureDetector(
      onTap: () {
        // This code will run when you tap the item!
        print("You clicked on ${transaction.name}!");
        
        // ---
        // LATER, you can add code here to navigate to a new page
        //
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => TransactionDetailsPage(transaction: transaction),
        //   ),
        // );
        // ---
      },
      child: Container(
        padding: EdgeInsets.all(15.0),
        margin: EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Icon
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: transaction.type == '+' ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                transaction.type == '+' ? Icons.arrow_upward : Icons.arrow_downward,
                color: transaction.type == '+' ? Colors.green : Colors.red,
              ),
            ),
            
            SizedBox(width: 15),

            // Name
            Expanded(
              child: Text(
                transaction.name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Price and Currency
            Text(
              '${transaction.type}${transaction.price} ${transaction.currency}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: transaction.type == '+' ? Colors.green : Colors.red,
              ),
            )
          ],
        ),
      ),
    );
  }
}