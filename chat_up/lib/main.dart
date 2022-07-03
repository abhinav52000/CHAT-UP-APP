import 'package:chat_up/Screen/search_friends_screen.dart';
import 'package:chat_up/Screen/chatscreen.dart';
import 'package:chat_up/Screen/loginscreen.dart';
import 'package:chat_up/Screen/registrationscreen.dart';
import 'package:chat_up/Screen/welcomescreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const FlashChat());
}

class FlashChat extends StatelessWidget {
  const FlashChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        RegistrationScreen.id: (context) => const RegistrationScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        ChatScreen.id: (context) => const ChatScreen(),
        FriendSearch.id: (context) => const FriendSearch(),
        // FriendResult.id():(context) => const FriendResult()
      },
    );
  }
}
