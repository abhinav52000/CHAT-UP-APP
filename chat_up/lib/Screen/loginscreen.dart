import 'package:chat_up/Screen/Search_friends_screen.dart';
import 'package:chat_up/components/reusablecontent.dart';
import 'package:chat_up/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const id = 'Login Screen';
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? email;
  String? password;

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('Asset/Registrationandloginbg.png'),
            fit: BoxFit.fill,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5), BlendMode.overlay),
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: ModalProgressHUD(
          inAsyncCall: showspinner,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 5,
                ),
                Hero(
                  tag: 'logo',
                  child: Image.asset('Asset/icondark.png',
                      height: 150, width: 150, alignment: Alignment.center),
                ),
                Text(
                  'Enter Log In Details',
                  style: registrationpagehead,
                ),
                const SizedBox(
                  height: 35,
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  onChanged: (value) {
                    email = value;
                  },
                  autofillHints: const [AutofillHints.email],
                  decoration: inputDecorationfortextfield().copyWith(
                    hintText: 'Phone Number or Email',
                  ),
                  style: registrationpagestyle(),
                ),
                const SizedBox(
                  height: 15,
                ),
                PasswordStyle(
                  requiredjob: (value) {
                    password = value;
                  },
                  hinttext: 'Enter Password',
                ),
                const SizedBox(
                  height: 15,
                ),
                MyButton(
                  requiredJob: (() async {
                    setState(() {
                      showspinner = true;
                    });
                    try {
                      await _auth.signInWithEmailAndPassword(
                          email: email.toString(),
                          password: password.toString());
                      // print(user.additionalUserInfo);
                      // ignore: use_build_context_synchronously
                      Navigator.popAndPushNamed(context, FriendSearch.id);
                      setState(() {
                        showspinner = false;
                      });
                    } catch (e) {
                      setState(() {
                        showspinner = false;
                      });
                      // ignore: await_only_futures
                      await alertForAll(
                        context,
                        title: 'invalid Credentials',
                        desc: '$e',
                        buttontext: 'Re-Enter Credentials',
                        butonfunction: (() {
                          Navigator.pop(context);
                        }),
                      ).show();
                    }
                  }),
                  buttondata: 'Log In',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
