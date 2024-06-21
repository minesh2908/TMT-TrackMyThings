import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModal {
  ProductModal({
    this.productName,
    this.purchasedDate,
    this.warrantyPeriods,
    this.warrantyEndsDate,
    this.billImage,
    this.productImage,
    this.notes,
    this.userId,
    this.productId,
  });

  factory ProductModal.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data()!;
    return ProductModal(
      productId: document.id,
      productName: data['productName'] as String?,
      purchasedDate: data['purchasedDate'] as String?,
      warrantyPeriods: data['warrantyPeriods'] as String?,
      warrantyEndsDate: data['warrantyEndsDate'] as String?,
      billImage: data['billImage'] as String?,
      productImage: data['productImage'] as String?,
      notes: data['notes'] as String?,
      userId: data['userId'] as String?,
    );
  }
  String? productName;
  String? purchasedDate;
  String? warrantyPeriods;
  String? warrantyEndsDate;
  String? billImage;
  String? productImage;
  String? notes;
  String? userId;
  String? productId;

  ProductModal copyWith({
    String? productName,
    String? purchasedDate,
    String? warrantyPeriods,
    String? warrantyEndsDate,
    String? billImage,
    String? productImage,
    String? notes,
    String? userId,
    String? productId,
  }) {
    return ProductModal(
      productName: productName ?? this.productName,
      purchasedDate: purchasedDate ?? this.purchasedDate,
      warrantyPeriods: warrantyPeriods ?? this.warrantyPeriods,
      warrantyEndsDate: warrantyEndsDate ?? this.warrantyEndsDate,
      billImage: billImage ?? this.billImage,
      productImage: productImage ?? this.productImage,
      notes: notes ?? this.notes,
      userId: userId ?? this.userId,
      productId: productId ?? this.productId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'purchasedDate': purchasedDate,
      'warrantyPeriods': warrantyPeriods,
      'warrantyEndsDate': warrantyEndsDate,
      'billImage': billImage,
      'productImage': productImage,
      'notes': notes,
      'userId': userId,
      'productId': productId,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}
