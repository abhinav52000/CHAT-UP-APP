import 'package:chat_up/components/reusablecontent.dart';
import 'package:chat_up/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _cloudauth = FirebaseFirestore.instance;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, this.friendemaildata, this.friendnamedata})
      : super(key: key);
  static const id = 'Chat Screen';
  final String? friendemaildata;
  final String? friendnamedata;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _controller = ScrollController();

  void _scrollDown() {
    _controller.jumpTo(_controller.initialScrollOffset);
  }

  final _auth = FirebaseAuth.instance;
  late User loggedinuser;
  late String sentmessage;
  final messagecontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedinuser = user;
      }
    } catch (e) {
      alertForAll(
        context,
        title: 'Error',
        desc: '$e',
        buttontext: 'Close',
        butonfunction: (() {
          Navigator.pop(context);
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: GestureDetector(
      //   onTap: () {
      //     _auth.signOut;
      //     alertForAll(context,
      //         title: 'Logging Out',
      //         desc: '\n\n\nTap [X] To Continue Chatting',
      //         buttontext: 'Press To Log Out', butonfunction: (() {
      //       Navigator.restorablePopAndPushNamed(context, WelcomeScreen.id);
      //     }), closebutonfunction: (() {
      //       Navigator.pop(context);
      //     })).show();
      //   },
      //   child: const Icon(
      //     Icons.lock,
      //     color: Colors.white,
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('Asset/chatscreen.png'),
            fit: BoxFit.fill,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.2), BlendMode.darken),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: (_cloudauth
                      .collection('userlist')
                      .doc(loggedinuser.email)
                      .collection('friendlist')
                      .doc(widget.friendemaildata)
                      .collection("message")
                      .orderBy('timestamp', descending: false)
                      .snapshots()),
                  builder: (context, streamsnapshot) {
                    if (streamsnapshot.hasError) {
                      return Center(
                          child: namecardofusersall(
                              printdata: 'Something went wrong'));
                    }

                    if (streamsnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                      );
                    }
                    final userlist = streamsnapshot.data!.docs;
                    return ListView.builder(
                      reverse: true,
                      controller: _controller,
                      itemCount: userlist.length,
                      itemBuilder: ((context, index) {
                        try {
                          return Container(
                            child: messagecardofall(
                              name: (userlist[userlist.length - index - 1]
                                          ['sender'] ==
                                      widget.friendemaildata)
                                  ? widget.friendnamedata
                                  : 'You',
                              printdata: userlist[userlist.length - index - 1]
                                  ['senttext'],
                              currentuser:
                                  (userlist[userlist.length - index - 1]
                                              ['sender'] ==
                                          loggedinuser.email)
                                      ? true
                                      : false,
                            ),
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
              Row(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 2.0, bottom: 2, top: 2),
                    child: SizedBox(
                      width: 308,
                      height: 50,
                      child: TextField(
                        onChanged: ((value) {
                          sentmessage = value;
                        }),
                        controller: messagecontroller,
                        keyboardType: TextInputType.multiline,
                        maxLines: 1000,
                        showCursor: true,
                        cursorWidth: 0.5,
                        cursorColor: Colors.white.withOpacity(0),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 8.0),
                          border: searchscreenpagetilesborder,
                          enabledBorder: searchscreenpagetilesborder,
                          focusedBorder: searchscreenpagetilesborder,
                          hintText: 'Enter Your Message',
                          hintTextDirection: TextDirection.ltr,
                          hintStyle: registrationpagestyle(opacity: 01),
                        ),
                        style: registrationpagestyle(),
                      ),
                    ),
                  ),
                  RawMaterialButton(
                    onPressed: () {
                      messagecontroller.clear();

                      _scrollDown();

                      _cloudauth
                          .collection('userlist')
                          .doc(loggedinuser.email)
                          .collection('friendlist')
                          .doc(widget.friendemaildata)
                          .collection("message")
                          .add({
                        'sender': loggedinuser.email,
                        'senttext': sentmessage,
                        'timestamp': DateTime.now(),
                      });
                      _cloudauth
                          .collection('userlist')
                          .doc(widget.friendemaildata)
                          .collection('friendlist')
                          .doc(loggedinuser.email)
                          .collection("message")
                          .add({
                        'sender': loggedinuser.email,
                        'senttext': sentmessage,
                        'timestamp': DateTime.now(),
                      });
                    },
                    elevation: 6,
                    constraints:
                        const BoxConstraints.tightFor(height: 50, width: 50),
                    child: Transform.scale(
                      scale: 1.5,
                      child: const Icon(
                        Icons.send,
                        color: Colors.blueAccent,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),

      // bottomSheet:
    );
  }
}
