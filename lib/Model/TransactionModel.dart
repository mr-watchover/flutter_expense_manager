
class TransactionModel {
  final int? id;
  final String name;
  final int price;
  final String type; // '+' for Income, '-' for Expense
  final String currency;
  final String category;
  final DateTime date;
  
  // --- NEW FIELD ---
  // This links the transaction to a specific card
  final String cardNumber; 

  TransactionModel({
    this.id,
    required this.name,
    required this.price,
    required this.type,
    required this.currency,
    required this.category,
    required this.date,
    required this.cardNumber, // <-- Added to constructor
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'type': type,
        'currency': currency,
        'category': category,
        'date': date.toIso8601String(),
        'cardNumber': cardNumber, // <-- Added to save
      };

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        id: json['id'],
        name: json['name'],
        price: json['price'],
        type: json['type'],
        currency: json['currency'],
        category: json['category'],
        date: DateTime.parse(json['date']),
        cardNumber: json['cardNumber'], // <-- Added to load
      );
}