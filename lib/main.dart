import 'package:expense_manager/Components/CardList.dart';
import 'package:expense_manager/Components/TransactionView.dart';
import 'package:expense_manager/Pages/AddCardPage.dart';
import 'package:expense_manager/Pages/AddTransactionPage.dart';
import 'package:expense_manager/Providers/CardProvider.dart';
import 'package:expense_manager/Providers/TransactionProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => CardProvider()),
          ChangeNotifierProvider(create: (context) => TransactionProvider()),
        ],
        child: new MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(),
          home: HomePage(),
        ),
      ),
    );

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // --- NEW: Function to show the reset confirmation dialog ---
  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text('Reset All Data?'),
          content: Text('This will delete all cards and transactions. This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Call reset on BOTH providers
                Provider.of<CardProvider>(context, listen: false).resetData();
                Provider.of<TransactionProvider>(context, listen: false).resetData();
                Navigator.of(ctx).pop(); // Close the dialog
              },
              child: Text('Reset', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final transactions =
        Provider.of<TransactionProvider>(context).allTransactions;

    return Scaffold(
      backgroundColor: Color.fromRGBO(238, 241, 242, 1),
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: Text("Home page", style: TextStyle(color: Colors.black)),
        backgroundColor: Color.fromRGBO(238, 241, 242, 1),
        elevation: 0,
        leading: null,
        actions: <Widget>[
          // --- NEW: Reset Button ---
          IconButton(
            icon: Icon(Icons.delete_forever, color: Colors.red[700]),
            tooltip: 'Reset all data',
            onPressed: () {
              _showResetDialog(context);
            },
          ),
          
          // Existing "Add Card" button
          IconButton(
            icon: Icon(Icons.add, color: Colors.black45),
            tooltip: 'Add new card',
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddCardPage()));
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_shopping_cart),
        tooltip: 'Add new transaction',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTransactionPage()),
          );
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Card List (Updates automatically now)
              (Provider.of<CardProvider>(context).getCardLength() > 0
                  ? Container(
                      height: 210,
                      child: Consumer<CardProvider>(
                        builder: (context, cards, child) =>
                            CardList(cards: cards.allCards),
                      ),
                    )
                  : Container(
                      height: 210,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Add your new card click the \n + \n button in the top right.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    )),
              SizedBox(height: 30),
              Text(
                "Last Transactions",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black45),
              ),
              SizedBox(height: 15),
              // Real Transaction List
              Expanded(
                child: transactions.isEmpty
                    ? Center(
                        child: Text(
                          'No transactions yet.\nAdd one using the button below!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: transactions.length,
                        itemBuilder: (context, index) {
                          // Build list from newest to oldest
                          final transaction = transactions.reversed.toList()[index];
                          return TransactionView(transaction: transaction);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}