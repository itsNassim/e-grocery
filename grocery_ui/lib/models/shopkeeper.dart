class Shopkeeper {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String profileImageUrl;
  final String shopName;
  final String shopAddress;
  final String shopDescription;
  final List<BusinessHour> businessHours;
  final PaymentInfo paymentInfo;
  final bool isVerified;
  final DateTime joinDate;

  Shopkeeper({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.profileImageUrl,
    required this.shopName,
    required this.shopAddress,
    required this.shopDescription,
    required this.businessHours,
    required this.paymentInfo,
    required this.isVerified,
    required this.joinDate,
  });

  Shopkeeper copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? profileImageUrl,
    String? shopName,
    String? shopAddress,
    String? shopDescription,
    List<BusinessHour>? businessHours,
    PaymentInfo? paymentInfo,
    bool? isVerified,
    DateTime? joinDate,
  }) {
    return Shopkeeper(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      shopName: shopName ?? this.shopName,
      shopAddress: shopAddress ?? this.shopAddress,
      shopDescription: shopDescription ?? this.shopDescription,
      businessHours: businessHours ?? this.businessHours,
      paymentInfo: paymentInfo ?? this.paymentInfo,
      isVerified: isVerified ?? this.isVerified,
      joinDate: joinDate ?? this.joinDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profileImageUrl': profileImageUrl,
      'shopName': shopName,
      'shopAddress': shopAddress,
      'shopDescription': shopDescription,
      'businessHours': businessHours.map((hour) => hour.toJson()).toList(),
      'paymentInfo': paymentInfo.toJson(),
      'isVerified': isVerified,
      'joinDate': joinDate.toIso8601String(),
    };
  }

  factory Shopkeeper.fromJson(Map<String, dynamic> json) {
    return Shopkeeper(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      profileImageUrl: json['profileImageUrl'],
      shopName: json['shopName'],
      shopAddress: json['shopAddress'],
      shopDescription: json['shopDescription'],
      businessHours: (json['businessHours'] as List)
          .map((hour) => BusinessHour.fromJson(hour))
          .toList(),
      paymentInfo: PaymentInfo.fromJson(json['paymentInfo']),
      isVerified: json['isVerified'],
      joinDate: DateTime.parse(json['joinDate']),
    );
  }
}

class BusinessHour {
  final String day;
  final String openTime;
  final String closeTime;
  final bool isClosed;

  BusinessHour({
    required this.day,
    required this.openTime,
    required this.closeTime,
    this.isClosed = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'openTime': openTime,
      'closeTime': closeTime,
      'isClosed': isClosed,
    };
  }

  factory BusinessHour.fromJson(Map<String, dynamic> json) {
    return BusinessHour(
      day: json['day'],
      openTime: json['openTime'],
      closeTime: json['closeTime'],
      isClosed: json['isClosed'],
    );
  }
}

class PaymentInfo {
  final String bankName;
  final String accountNumber;
  final String accountHolderName;
  final String taxId;

  PaymentInfo({
    required this.bankName,
    required this.accountNumber,
    required this.accountHolderName,
    required this.taxId,
  });

  Map<String, dynamic> toJson() {
    return {
      'bankName': bankName,
      'accountNumber': accountNumber,
      'accountHolderName': accountHolderName,
      'taxId': taxId,
    };
  }

  factory PaymentInfo.fromJson(Map<String, dynamic> json) {
    return PaymentInfo(
      bankName: json['bankName'],
      accountNumber: json['accountNumber'],
      accountHolderName: json['accountHolderName'],
      taxId: json['taxId'],
    );
  }
}