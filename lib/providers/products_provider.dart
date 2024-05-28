// ignore_for_file: unused_import, avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../models/product_model.dart';

class ProductsProvider with ChangeNotifier {
  ProductsProvider() {
    // Constructor içinde fetchProductsFromFirestore fonksiyonunu çağır
    fetchProductsFromFirestore();
  }
  List<ProductModel> products = [];
  Future<void> fetchProductsFromFirestore() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('products').get();
      print('ÇALIŞTIIIII');
      products = querySnapshot.docs.map((doc) {
        return ProductModel(
          productId: doc.id,
          productTitle: doc['productTitle'],
          productPrice: doc['productPrice'],
          productCategory: doc['productCategory'],
          productDescription: doc['productDescription'],
          productImage: doc['productImage'],
          productQuantity: doc['productQuantity'],
        );
      }).toList();

      notifyListeners();
    } catch (error) {
      print('Hata oluştu: $error');
    }
  }
  List<ProductModel> get getProducts {
    return products;
  }

  ProductModel? findByProdId(String productId) {
    if (products.where((element) => element.productId == productId).isEmpty) {
      return null;
    }
    return products.firstWhere((element) => element.productId == productId);
  }

  List<ProductModel> findByCategory({required String categoryName}) {
    List<ProductModel> categoryList = products
        .where(
          (element) => element.productCategory.toLowerCase().contains(
                categoryName.toLowerCase(),
              ),
        )
        .toList();
    return categoryList;
  }

  List<ProductModel> searchQuery(
      {required String searchText, required List<ProductModel> passedList}) {
    List<ProductModel> searchList = passedList
        .where(
          (element) => element.productTitle.toLowerCase().contains(
                searchText.toLowerCase(),
              ),
        )
        .toList();
    return searchList;
  }


}
