import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiklaal/models/cart_model.dart';
import 'package:tiklaal/services/firebase_service.dart';
import 'package:tiklaal/widgets/subtitle_text.dart';
import 'package:tiklaal/widgets/title_text.dart';

import '../../providers/cart_provider.dart';
import '../../providers/products_provider.dart';

class CartBottomSheetWidget extends StatelessWidget {
  const CartBottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: const Border(
          top: BorderSide(width: 1, color: Colors.grey),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: kBottomNavigationBarHeight + 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(child: TitlesTextWidget(label: "Toplam (${cartProvider.getCartitems.length} ürün /${cartProvider.getQty()} adet)")),
                    SubtitleTextWidget(
                      label: "${cartProvider.getTotal(productsProvider: productsProvider).toStringAsFixed(2)}₺",
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final productsProvider = Provider.of<ProductsProvider>(context, listen: false);
                  final cartProvider = Provider.of<CartProvider>(context, listen: false);

                  ///
                  List<CartModel> list = cartProvider.getCartItemsList;
                  for (int i = 0; i < list.length; i++) {
                    final getCurrProduct = productsProvider.findByProdId(list[i].productId);
                    Provider.of<CartProvider>(context, listen: false).addProductModelToMyOrderList(
                      productModel: getCurrProduct!,
                    );

                    // Firebase
                    FirebaseService.instance.saveProduct(getCurrProduct);
                  }
                },
                child: const Text("Ödeme Yap"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
