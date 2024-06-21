import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:warranty_tracker/modal/product_modal.dart';
import 'package:warranty_tracker/service/shared_prefrence.dart';

class ProductRepository {
  CollectionReference<Map<String, dynamic>> productCollection =
      FirebaseFirestore.instance.collection('productCollection');

  Future<void> addProduct(ProductModal? productModal, String uid) async {
    // print('add product');

    try {
      final product =
          await productCollection.doc(uid).set(productModal!.toMap());
    } catch (e) {
      log(e.toString());
      throw Exception();
    }
  }

  Future<String?> addImage(File? file) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      final storageRef = FirebaseStorage.instance.ref();
      final fileName = file!.path.split('/').last;
      final timeStamp = DateTime.now().microsecondsSinceEpoch;
      final uploadRef = storageRef.child('images/$userId/$timeStamp-$fileName');

      await uploadRef.putFile(file);
      final uploadedUrl = await uploadRef.getDownloadURL();
      log('Image added');
      return uploadedUrl;
    } catch (e) {
      throw Exception();
    }
  }

  Future<List<ProductModal>> getAllProducts() async {
    final userId = AppPrefHelper.getUID();
    try {
      final productListSnapshot =
          await productCollection.where('userId', isEqualTo: userId).get();
      final productList =
          productListSnapshot.docs.map(ProductModal.fromSnapshot).toList();

      //print(productList);
      return productList;
    } catch (e) {
      // print('!!!!!!!!!!!!!');
      // print(e);
      throw Exception();
    }
  }

  Future<void> updateProduct(ProductModal productModal) async {
    try {
      print('product ID from repo - ${productModal.productId}');
      await productCollection
          .doc(productModal.productId)
          .set(productModal.toMap());
    } catch (e) {
      print(e);
      throw Exception();
    }
  }

  Future<void> deleteProduct(ProductModal productModal) async {
    try {
      await productCollection.doc(productModal.productId).delete();
    } catch (e) {
      throw Exception();
    }
  }

  Future<void> deleteAllProduct(List<ProductModal> productModal) async {
    try {
      for (final product in productModal) {
        await productCollection.doc(product.productId).delete();
        print('deleted all products');
      }
    } catch (e) {
      throw Exception();
    }
  }
}
