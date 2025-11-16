class CardModel {
  
  //
  // FIX 1: Make 'id' nullable by adding '?'
  //
  final int? id;
  final String name;
  final String bankName;
  final String number;
  final String currency;

  int available;

  //
  // FIX 2: Remove 'required' from 'this.id'
  //
  CardModel({this.id, required this.name, required this.bankName, required this.number, required this.currency, required this.available});

  Map toJson() => {
    'id': id,
    'name': name,
    'bankName': bankName,
    'number': number,
    'currency': currency,
    'available': available
  };

  CardModel.fromJson(Map json) :
  // This part will now correctly assign null if 'id' is missing
  id = json['id'],
  name = json['name'],
  bankName = json['bankName'],
  number = json['number'],
  currency = json['currency'],
  available = json['available'];
  
}