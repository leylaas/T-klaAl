import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiklaal/consts/theme_data.dart';
import 'package:tiklaal/firebase_options.dart';
import 'package:tiklaal/providers/cart_provider.dart';
import 'package:tiklaal/providers/products_provider.dart';
import 'package:tiklaal/providers/theme_provider.dart';
import 'package:tiklaal/providers/viewed_recently_provider.dart';
import 'package:tiklaal/providers/wishlist_provider.dart';
import 'package:tiklaal/root_screen.dart';
import 'package:tiklaal/screens/auth/forgot_password.dart';
import 'package:tiklaal/screens/auth/login.dart';
import 'package:tiklaal/screens/auth/register.dart';
import 'package:tiklaal/screens/inner_screen/orders/orders_screen.dart';
import 'package:tiklaal/screens/inner_screen/product_details.dart';
import 'package:tiklaal/screens/inner_screen/viewed_recently.dart';
import 'package:tiklaal/screens/inner_screen/wishlist.dart';
import 'package:tiklaal/screens/search_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          return ThemeProvider();
        }),
        ChangeNotifierProvider(create: (_) {
          return ProductsProvider();
        }),
        ChangeNotifierProvider(create: (_) {
          return CartProvider();
        }),
        ChangeNotifierProvider(create: (_) {
          return WishlistProvider();
        }),
        ChangeNotifierProvider(create: (_) {
          return ViewedProdProvider();
        }),
      ],
      child: Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'TıklaAL',
          theme: Styles.themeData(
              isDarkTheme: themeProvider.getIsDarkTheme, context: context),
          home: const LoginScreen(),
          // home: const LoginScreen(),
          routes: {
            RootScreen.routeName: (context) => const RootScreen(),
            ProductDetailsScreen.routName: (context) =>
                const ProductDetailsScreen(),
            WishlistScreen.routName: (context) => const WishlistScreen(),
            ViewedRecentlyScreen.routName: (context) =>
                const ViewedRecentlyScreen(),
            RegisterScreen.routName: (context) => const RegisterScreen(),
            LoginScreen.routeName: (context) => const LoginScreen(),
            OrdersScreenFree.routeName: (context) => const OrdersScreenFree(),
            ForgotPasswordScreen.routeName: (context) =>
                const ForgotPasswordScreen(),
            SearchScreen.routeName: (context) => const SearchScreen(),
          },
        );
      }),
    );
  }
}
