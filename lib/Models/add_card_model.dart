class cardDetailsModel {
  final String id;
  final String cardHolderName;
  final String cardNumber;
  final String expiryDate;
  final String cvv;
  final bool checked;

  cardDetailsModel({
    required this.id,
    required this.cardHolderName,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
    required this.checked,
  });

  cardDetailsModel copyWith({
    String? id,
    String? cardHolderName,
    String? cardNumber,
    String? expiryDate,
    String? cvv,
    bool? checked,
  }) {
    return cardDetailsModel(
      id: id ?? this.id,
      cardHolderName: cardHolderName ?? this.cardHolderName,
      cardNumber: cardNumber ?? this.cardNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      cvv: cvv ?? this.cvv,
      checked: checked ?? this.checked,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cardHolderName': cardHolderName,
      'cardNumber': cardNumber,
      'expiryDate': expiryDate,
      'cvv': cvv,
      'checked': checked,
    };
  }

  factory cardDetailsModel.fromMap(Map<String, dynamic> map) {
    return cardDetailsModel(
      id: map['id'] ?? '',
      cardHolderName: map['cardHolderName'] ?? '',
      cardNumber: map['cardNumber'] ?? '',
      expiryDate: map['expiryDate'] ?? '',
      cvv: map['cvv'] ?? '',
      checked: map['checked'] ?? false,
    );
  }
}

List<cardDetailsModel> dummyCardData = [];
