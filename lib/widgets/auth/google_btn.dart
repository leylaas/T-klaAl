import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:tiklaal/root_screen.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key});
Future<void> googleSignSignIn ({required BuildContext context})async{
     if (!context.mounted) return;
         Navigator.pushReplacementNamed(context,RootScreen.routeName);
}
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        elevation: 1,
        padding: const EdgeInsets.all(12.0),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            12.0,
          ),
        ),
      ),
      icon: const Icon(
        Ionicons.logo_google,
        color: Colors.red,
      ),
      label: const Text(
        "Sign in with google",
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () async {},
    );
  }
}