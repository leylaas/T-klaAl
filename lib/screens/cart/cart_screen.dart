import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiklaal/providers/cart_provider.dart';
import 'package:tiklaal/screens/cart/cart_widget.dart';
import 'package:tiklaal/services/assets_manager.dart';
import 'package:tiklaal/services/my_app_functions.dart';
import 'package:tiklaal/widgets/empty_bag.dart';
import 'package:tiklaal/widgets/title_text.dart';
import 'package:tiklaal/screens/home_screen.dart';

import 'bottom_checkout.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  final bool isEmpty = false;
  @override
  Widget build(BuildContext context) {
    // final productsProvider = Provider.of<ProductsProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    return cartProvider.getCartitems.isEmpty
        ? Scaffold(
            body: EmptyBagWidget(
              imagePath: AssetsManager.shoppingBasket,
              title: "Sepetiniz Boş :( )",
              subtitle:
                  "Görünüşe göre sepetiniz boş, bir şeyler ekleyin ve sizi mutlu edelim!",
              buttonText: "Şimdi Al", onPressed: () {  Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()), // yönlendirme işlemi
          ); },
            ),
          )
        : Scaffold(
            bottomSheet: const CartBottomSheetWidget(),
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  AssetsManager.shoppingCart,
                ),
              ),
              title: TitlesTextWidget(
                  label: "Sepet (${cartProvider.getCartitems.length})"),
              actions: [
                IconButton(
                  onPressed: () {
                    MyAppFunctions.showErrorOrWarningDialog(
                      isError: false,
                      context: context,
                      subtitle: "Sepeti Temizle?",
                      fct: () {
                        cartProvider.clearLocalCart();
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.delete_forever_rounded,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: cartProvider.getCartitems.length,
                      itemBuilder: (context, index) {
                        return ChangeNotifierProvider.value(
                            value: cartProvider.getCartitems.values
                                .toList()[index],
                            child: const CartWidget());
                      }),
                ),
                const SizedBox(
                  height: kBottomNavigationBarHeight + 10,
                )
              ],
            ),
          );
  }
}

