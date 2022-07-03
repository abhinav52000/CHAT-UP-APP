import 'package:chat_up/Screen/loginscreen.dart';
import 'package:chat_up/Screen/registrationscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chat_up/components/reusablecontent.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

int isopenonce = 0;

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  static const id = 'welcome Screen';
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation, animation1;
  bool showfield = false;
  // double multiple = 1;

  @override
  void initState() {
    Firebase.initializeApp();
    super.initState();
    controller = AnimationController(
        vsync: this, duration: Duration(seconds: (isopenonce == 0) ? 3 : 1));
    animation = CurvedAnimation(parent: controller, curve: Curves.bounceInOut);
    animation1 =
        AlignmentTween(begin: Alignment.bottomLeft, end: Alignment.center)
            .animate(controller);
    controller.forward();
    animation.addStatusListener((status) {
      if (controller.status == AnimationStatus.completed) {
        showfield = true;
      }
    });
    animation.addListener(() {
      setState(() {
        // multiple = controller.value;
        // ye karne ki jarurat nhi hai apne aap bhi set state mtlb ki pta chl gya
        // ki value update ho rhi hai set state bas hona chahiye
      });
    });
    isopenonce++;
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    // This is important to dispose controller as well reason being agr to and fro man lo
    // Animation lgaya jo ki to and frow karta rhega to if dospose nhi kiya to wo even
    // Screen change ho jaye par backgroung mai chlta rheg hence important is to dispose
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: const AssetImage('Asset/Registrationandloginbg.png'),
              fit: BoxFit.fill,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.2), BlendMode.overlay)),
        ),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          maintainBottomViewPadding: true,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  Hero(
                    tag: 'logo',
                    child: Image(
                        image: const AssetImage('Asset/icondark.png'),
                        height: 350.0 * animation.value,
                        width: 350.0 * animation.value),
                  ),
                  Visibility(
                    visible: showfield,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: MyButton(
                      buttondata: 'Register',
                      requiredJob: (() {
                        Navigator.pushNamed(context, RegistrationScreen.id);
                      }),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    visible: showfield,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: MyButton(
                      buttondata: 'Log In',
                      requiredJob: (() {
                        Navigator.pushNamed(context, LoginScreen.id);
                      }),
                    ),
                  ),
                  const SizedBox(
                    height: 70,
                  ),
                  Visibility(
                    visible: showfield,
                    maintainSize: false,
                    maintainAnimation: false,
                    maintainState: true,
                    child: DefaultTextStyle(
                      style: GoogleFonts.anekBangla(color: Colors.white),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText('Developed by ABHINAV'),
                        ],
                        isRepeatingAnimation: false,
                        onTap: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
