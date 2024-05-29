import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tiklaal/models/product_model.dart';

class FirebaseService {
  FirebaseService._privateConstructor();
  static final FirebaseService instance = FirebaseService._privateConstructor();

  /// Save
  Future<void> saveProduct(ProductModel product) async {
    try {
      await FirebaseFirestore.instance.collection('orders').doc(product.productId).set({
        'productId': product.productId,
        'productTitle': product.productTitle,
        'productPrice': product.productPrice,
        'productCategory': product.productCategory,
        'productDescription': product.productDescription,
        'productImage': product.productImage,
        'productQuantity': product.productQuantity,
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
