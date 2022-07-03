import 'package:chat_up/Screen/chatscreen.dart';
import 'package:chat_up/Screen/searchresult.dart';
import 'package:chat_up/Screen/welcomescreen.dart';
import 'package:chat_up/components/reusablecontent.dart';
import 'package:chat_up/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _cloudauth = FirebaseFirestore.instance;
late User loggedinuser;

class FriendSearch extends StatefulWidget {
  const FriendSearch({Key? key}) : super(key: key);
  static const id = 'Search Friend';

  @override
  State<FriendSearch> createState() => _FriendSearchState();
}

class _FriendSearchState extends State<FriendSearch> {
  final _auth = FirebaseAuth.instance;
  List<String> friendlist = [];

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedinuser = user;
        // print(loggedinuser);
      }
    } catch (e) {
      alertForAll(context,
          title: 'Exception Occured',
          desc: '\n\n$e',
          buttontext: 'Close', butonfunction: (() {
        Navigator.pop(context);
      }));
    }
  }

  @override
  Widget build(BuildContext context1) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent.withOpacity(1),
        elevation: 5,
        leading: const SizedBox(
          width: 1,
        ),
        leadingWidth: 2,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'My Friends',
            ),
            GestureDetector(
              onTap: () {
                alertForAll(context,
                    title: 'Logging Out',
                    desc: '\n\n\nTap [X] To Continue Searching',
                    buttontext: 'Press To Log Out', butonfunction: (() {
                  setState(() {
                    Navigator.pop(context);
                    Navigator.popAndPushNamed(context1, WelcomeScreen.id);
                  });
                }), closebutonfunction: (() {
                  Navigator.pop(context);
                })).show();
              },
              child: Column(
                children: const [
                  Icon(
                    Icons.lock,
                    color: Colors.white,
                  ),
                  Text(
                    'Log Out',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // floatingActionButton: ,
      // floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('Asset/searchscreen.png'),
              fit: BoxFit.fill,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5), BlendMode.overlay),
            ),
          ),
          constraints: const BoxConstraints.expand(),
          child: StreamBuilder<QuerySnapshot>(
            stream: (_cloudauth
                .collection('userlist')
                .doc(loggedinuser.email)
                .collection('friendlist')
                .snapshots()),
            builder: (context, streamsnapshot) {
              if (streamsnapshot.hasError) {
                return Center(
                    child:
                        namecardofusersall(printdata: 'Something went wrong'));
              }

              if (streamsnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                );
              }
              final userlist = streamsnapshot.data!.docs;
              return ListView.builder(
                itemCount: userlist.length + 1,
                itemBuilder: ((context, index) {
                  try {
                    friendlist.clear();
                    (index == 0)
                        ? friendlist.add('')
                        : friendlist.add(userlist[index - 1]['friendemail']);
                    return (index == 0)
                        ? SizedBox(
                            height: 80,
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                TextField(
                                  onSubmitted: ((value) {
                                    setState(() {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return FriendResult(
                                          substring: value.toString(),
                                          friendlist: friendlist,
                                        );
                                      }));
                                    });
                                  }),
                                  textAlign: TextAlign.center,
                                  showCursor: true,
                                  cursorWidth: 0.5,
                                  cursorColor: Colors.white.withOpacity(0),
                                  decoration: InputDecoration(
                                    border: searchscreenpagetilesborder,
                                    enabledBorder: searchscreenpagetilesborder,
                                    focusedBorder: searchscreenpagetilesborder,
                                    hintText:
                                        'Search Your Friend By Name or Email',
                                    hintTextDirection: TextDirection.ltr,
                                    hintStyle:
                                        registrationpagestyle(opacity: 01),
                                  ),
                                  style: registrationpagestyle(),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            child: namecardofusersall(
                                printdata: userlist[index - 1]['friendname'],
                                email: userlist[index - 1]['friendemail'],
                                requiredjob: (() {
                                  setState(() {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return ChatScreen(
                                        friendemaildata: userlist[index - 1]
                                            ['friendemail'],
                                        friendnamedata: userlist[index - 1]
                                            ['friendname'],
                                      );
                                    }));
                                  });
                                }),
                                longpressjob: (() {
                                  return alertForAll(context,
                                      title: 'Delete Conversation',
                                      desc:
                                          '\n\n\nAre You Sure? Want To Delete',
                                      buttontext: 'Confirm',
                                      butonfunction: (() async {
                                    String deletedemail =
                                        (userlist[index - 1]['friendemail']);
                                    setState(() {
                                      Navigator.pop(context);
                                    });
                                    await _cloudauth
                                        .collection('userlist')
                                        .doc(loggedinuser.email)
                                        .collection('friendlist')
                                        .doc(deletedemail)
                                        .delete();
                                  }), closebutonfunction: (() {
                                    setState(() {
                                      Navigator.pop(context);
                                    });
                                  })).show();
                                })),
                          );
                  } catch (e) {
                    return namecardofusersall(
                      printdata: '$e',
                    );
                  }
                }),
              );
            },
          ),
        ),
      ),
    );
  }
}
