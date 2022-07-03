import 'package:chat_up/Screen/search_friends_screen.dart';
import 'package:chat_up/Screen/welcomescreen.dart';
import 'package:chat_up/components/reusablecontent.dart';
import 'package:flutter/material.dart';
import 'package:chat_up/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);
  static const id = 'Registration Screen';
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String? fname, lname;
  String? email;
  String? phone;
  String? dob;
  String? password = '', cpassword = '';
  // bool showspinner = false;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context1) {
    // Here context1 isliye kiya hai kyoki yar jab aapko pop kar na hai to
    // BuildContext ka parameter context variable ke sath aur jgh bhi use
    // ho rha hai
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 32),
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
              child: Column(
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child: Image.asset('Asset/icondark.png',
                        height: 150, width: 150, alignment: Alignment.center),
                  ),
                  Text(
                    'Enter Your Details',
                    style: registrationpagehead,
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Row(
                    children: [
                      TextField(
                        onChanged: ((value) {
                          fname = value;
                        }),
                        textAlign: TextAlign.center,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: inputDecorationfortextfield().copyWith(
                            hintText: 'First Name',
                            constraints: const BoxConstraints(maxWidth: 150),
                            errorStyle: registrationpagestyle(opacity: 0.5)),
                        style: registrationpagestyle(),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      TextField(
                        onChanged: (value) {
                          lname = value;
                        },
                        textAlign: TextAlign.center,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: inputDecorationfortextfield().copyWith(
                          hintText: 'Last Name',
                          constraints: const BoxConstraints(maxWidth: 150),
                        ),
                        style: registrationpagestyle(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: inputDecorationfortextfield()
                        .copyWith(hintText: 'Email'),
                    style: registrationpagestyle(),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    onChanged: ((value) {
                      phone = value;
                    }),
                    autofillHints: const [AutofillHints.telephoneNumber],
                    keyboardType: TextInputType.phone,
                    decoration: inputDecorationfortextfield()
                        .copyWith(hintText: 'Phone Number'),
                    style: registrationpagestyle(),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    onTap: () async {
                      final date = await showDatePicker(
                          context: context,
                          initialEntryMode: DatePickerEntryMode.calendar,
                          firstDate: DateTime(1960),
                          initialDate: DateTime.now(),
                          lastDate: DateTime.now());
                      if (date != null) {
                        setState(() {
                          dob = date.toString().substring(0, 10);
                        });
                      }
                    },
                    readOnly: true,
                    keyboardType: TextInputType.datetime,
                    decoration: inputDecorationfortextfield().copyWith(
                      hintText: dob ?? 'Date Of Birth',
                      hintStyle: (dob != null)
                          ? registrationpagestyle()
                          : registrationpagestyle(opacity: 0.5),
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
                      hinttext: 'Create Password'),
                  const SizedBox(
                    height: 15,
                  ),
                  PasswordStyle(
                      requiredjob: (value) {
                        cpassword = value;
                      },
                      submittedjob: (value) {
                        if (cpassword != password) {
                          alertForAll(context,
                              title: "Password do not Match",
                              desc: "Please Re-Enter your Password.",
                              buttontext: 'Close', butonfunction: (() {
                            setState(() {
                              Navigator.pop(context);
                            });
                          })).show();
                        }
                      },
                      hinttext: 'Confirm Password'),
                  const SizedBox(
                    height: 15,
                  ),
                  MyButton(
                    requiredJob: () async {
                      if ((cpassword == password &&
                              password != '' &&
                              cpassword != '') &&
                          (fname?.isNotEmpty == true &&
                              lname?.isNotEmpty == true &&
                              email?.isNotEmpty == true &&
                              phone?.isNotEmpty == true &&
                              dob?.isNotEmpty == true)) {
                        try {
                          setState(() {
                            showspinner = true;
                          });

                          await _auth.createUserWithEmailAndPassword(
                            email: email.toString(),
                            password: password.toString(),
                          );
                          await _auth.currentUser
                              ?.updateDisplayName('$fname $lname');

                          try {
                            await _firestore
                                .collection('userlist')
                                .doc('$email')
                                .set({
                              'email': '$email',
                              'name': '$fname $lname',
                              'dob': '$dob',
                              'phone': '$phone'
                            });

                            await _firestore
                                .collection(
                                    'userlist/$email/userdetails/$email')
                                .add({
                              'name': '$fname $lname',
                              'dob': '$dob',
                              'phone': '$phone'
                            });
                          } catch (e) {
                            // ignore: use_build_context_synchronously
                            alertForAll(
                              context,
                              title: 'Failure',
                              desc: '\n\nRegistration Failed Due To \n\n$e',
                              buttontext: 'close',
                              butonfunction: (() {
                                Navigator.pop(context);
                              }),
                            );
                          }
                          setState(() {
                            showspinner = false;
                          });
                          // ignore: use_build_context_synchronously
                          alertForAll(
                            context,
                            title: 'Congratulations',
                            desc:
                                '\n\nYour Registration is Completed 😊\n\nPress [X] For Registration Screen',
                            buttontext: 'Start Chat Up Now 💕',
                            butonfunction: (() {
                              setState(() {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const FriendSearch();
                                }));
                              });
                            }),
                            closebutonfunction: (() {
                              Navigator.popAndPushNamed(
                                  context, WelcomeScreen.id);
                            }),
                          ).show();
                        } on FirebaseAuthException catch (e) {
                          setState(() {
                            showspinner = false;
                          });
                          if (e.code == 'weak-password') {
                            alertForAll(context,
                                title: 'Invalid Register Attempt',
                                desc:
                                    '\n\nError Reason\n\nThe password provided is too weak',
                                buttontext: 'Re-Enter Your Details',
                                butonfunction: (() {
                              Navigator.pop(context);
                            })).show();
                          } else if (e.code == 'email-already-in-use') {
                            alertForAll(context,
                                title: 'Invalid Register Attempt',
                                desc:
                                    '\n\nError Reason\n\nThe account already exists for that email',
                                buttontext: 'Re-Enter Your Details',
                                butonfunction: (() {
                              Navigator.pop(context);
                            })).show();
                          }
                        } catch (e) {
                          setState(() {
                            showspinner = false;
                          });

                          alertForAll(context,
                              title: 'Invalid Register Attempt',
                              desc: '\n\nError Reason\n\n$e',
                              buttontext: 'Re-Enter Your Details',
                              butonfunction: (() {
                            Navigator.pop(context);
                          })).show();
                        }
                      } else {
                        alertForAll(context,
                            title: "Please Re-Enter your Details.",
                            desc:
                                "\n\nPassword do not Match \nOR \nSome Field Left Empty",
                            buttontext: 'Close', butonfunction: (() {
                          setState(() {
                            Navigator.pop(context);
                          });
                        })).show();
                      }
                    },
                    buttondata: 'Sign UP',
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
