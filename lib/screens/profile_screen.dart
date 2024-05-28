// ignore_for_file: avoid_print, unnecessary_brace_in_string_interps

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:tiklaal/screens/auth/login.dart';
import 'package:tiklaal/screens/inner_screen/viewed_recently.dart';
import 'package:tiklaal/screens/inner_screen/wishlist.dart';
import 'package:tiklaal/services/assets_manager.dart';
import 'package:tiklaal/widgets/subtitle_text.dart';
import 'package:tiklaal/screens/inner_screen/orders/orders_screen.dart';
import '../providers/theme_provider.dart';
import '../services/my_app_functions.dart';
import '../widgets/app_name_text.dart';
import '../widgets/title_text.dart';


// Kullanıcı bilgilerini almak için bir fonksiyon

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user;
  String displayName = "";
  String email = "";

@override
void initState() {
  super.initState();
  user = FirebaseAuth.instance.currentUser;
  FirebaseAuth auth = FirebaseAuth.instance;
  auth.authStateChanges().listen((User? user) {
    if (user == null) {
      setState(() {
        displayName = "ben giriş yapmadım";
      });
      print('Kullanıcı oturum açmamış');
    } else {
      String? namee = user.email;
      List<String> parts = namee!.split('@');
      print(parts); //
      setState(() {
        displayName = parts[0];
        email = user.email ?? "";
      });
      print('Kullanıcı oturum açmış');
      print('Kullanıcı ID: ${user.uid}');
      print('Kullanıcı adı: ${user.displayName}');
      print('Kullanıcı e-posta: ${user.email}');
    }
  });
}

@override
Widget build(BuildContext context) {
  final themeProvider = Provider.of<ThemeProvider>(context);
  final currentUser = FirebaseAuth.instance.currentUser;
  return Scaffold(
    appBar: AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          AssetsManager.shoppingCart,
        ),
      ),
      title: const AppNameTextWidget(fontSize: 20),
    ),
    body: SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: currentUser == null,
            child: const Padding(
              padding: EdgeInsets.all(18.0),
              child: TitlesTextWidget(
                label: "Erişim için lütfen giriş yapınız",
              ),
            ),
          ),
          Visibility(
            visible: currentUser != null,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).cardColor,
                      border: Border.all(
                          color: Theme.of(context).colorScheme.background,
                          width: 3),
                      image: const DecorationImage(
                        image: NetworkImage(
                          "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png",
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitlesTextWidget(label: displayName),
                      // Diğer widget'lar buraya eklenebilir
                      const SizedBox(
                        height: 6,
                      ),
                      SubtitleTextWidget(label: email)
                    ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(
                    thickness: 1,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const TitlesTextWidget(
                    label: "Genel İşlemler",
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomListTile(
                    text: "Tüm Siparişler",
                    imagePath: AssetsManager.orderSvg,
                    function: () {Navigator.pushNamed(context, OrdersScreenFree.routeName);},
                  ),
                  CustomListTile(
                    text: "Beğeniler",
                    imagePath: AssetsManager.wishlistSvg,
                    function: () {
                      Navigator.pushNamed(context, WishlistScreen.routName);
                    },
                  ),
                  CustomListTile(
                    text: "Son Görüntülenenler",
                    imagePath: AssetsManager.recent,
                    function: () {
                      Navigator.pushNamed(
                          context, ViewedRecentlyScreen.routName);
                    },
                  ),
                  const SizedBox(height: 6),
                  const Divider(
                    thickness: 1,
                  ),
                  const SizedBox(height: 6),
                  const TitlesTextWidget(
                    label: "Ayarlar",
                  ),
                  const SizedBox(height: 10),
                  SwitchListTile(
                    secondary: Image.asset(
                      AssetsManager.theme,
                      height: 34,
                    ),
                    title: Text(themeProvider.getIsDarkTheme
                        ? "Karanlık Görünüm"
                        : "Aydınlık Görünüm"),
                    value: themeProvider.getIsDarkTheme,
                    onChanged: (value) {
                      themeProvider.setDarkTheme(themeValue: value);
                    },
                  ),
                ],
              ),
            ),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      30.0,
                    ),
                  ),
                ),
                icon: Icon(user== null ? Icons.login :  Icons.logout),
                label: Text(user== null ? "Login":"Logout"),
                onPressed: () async {
                  if (user==null) {
                    Navigator.pushNamed(context,LoginScreen.routeName);
                  }
                  else{
                    await MyAppFunctions.showErrorOrWarningDialog(
                    context: context,
                    subtitle: "Çıkış yapmak istediğinize emin misiniz?",
                    popScreen: false,
                    fct: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    ),
                    isError: false,
                  );
                  }
                  
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.imagePath,
    required this.text,
    required this.function,
  });
  final String imagePath, text;
  final Function function;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        function();
      },
      title: SubtitleTextWidget(label: text),
      leading: Image.asset(
        imagePath,
        height: 34,
      ),
      trailing: const Icon(IconlyLight.arrowRight2),
    );
  }
}
