import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  UserModel({
    this.email,
    this.name,
    this.phoneNumber,
    this.userId,
    this.defaultWarrantyPeriod,
    this.sortItemBy,
  });

  factory UserModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data()!;
    return UserModel(
      userId: document.id,
      name: data['name'] as String?,
      email: data['email'] as String?,
      phoneNumber: data['phoneNumber'] as String?,
      defaultWarrantyPeriod: data['defaultWarrantyPeriod'] as String?,
      sortItemBy: data['sortItemBy'] as String?,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] as String,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      userId: json['userId'] as String,
      defaultWarrantyPeriod: json['defaultWarrantyPeriod'] as String,
      sortItemBy: json['sortItemBy'] as String,
    );
  }
  String? email;
  String? name;
  String? phoneNumber;
  String? userId;
  String? defaultWarrantyPeriod;
  String? sortItemBy;
  UserModel copyWith({
    String? email,
    String? name,
    String? phoneNumber,
    String? userId,
    String? defaultWarrantyPeriod,
    String? sortItemBy,
  }) {
    return UserModel(
      email: email ?? this.email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      userId: userId ?? this.userId,
      defaultWarrantyPeriod:
          defaultWarrantyPeriod ?? this.defaultWarrantyPeriod,
      sortItemBy: sortItemBy ?? this.sortItemBy,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'userId': userId,
      'defaultWarrantyPeriod': defaultWarrantyPeriod,
      'sortItemBy': sortItemBy,
    };
  }

  @override
  String toString() {
    return '''User(email: $email, name: $name, phoneNumber: $phoneNumber, userId: $userId, defaultWarrantyPeriod : $defaultWarrantyPeriod, sortItemBy:$sortItemBy)''';
  }
}
