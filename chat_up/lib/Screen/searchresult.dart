import 'package:chat_up/Screen/search_friends_screen.dart';
import 'package:chat_up/components/reusablecontent.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendResult extends StatefulWidget {
  const FriendResult({Key? key, this.substring, this.friendlist})
      : super(key: key);

  static const id = 'Friend Result';
  final String? substring;
  final List<String>? friendlist;

  @override
  State<FriendResult> createState() => _FriendResultState();
}

class _FriendResultState extends State<FriendResult> {
  final _clouddata = FirebaseFirestore.instance.collection('userlist');

  @override
  void initState() {
    // final user = _auth.currentUser; // not necessary
    super.initState();
    widget.friendlist?.add('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('Asset/friendresult.png'),
            fit: BoxFit.fill,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.4), BlendMode.overlay),
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 60.0, 10.0, 15.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: _clouddata.snapshots(),
            builder: (context, streamsnapshot) {
              if (streamsnapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (streamsnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator.adaptive(
                  backgroundColor: Colors.white,
                ));
              }
              final userlist = streamsnapshot.data!.docs;

              return ListView.builder(
                itemCount: userlist.length,
                itemBuilder: ((context, index) {
                  try {
                    bool alreadyfriend = false;

                    widget.friendlist?.forEach((element) {
                      alreadyfriend =
                          (element == userlist[index]['email'].toString())
                              ? true
                              : false;
                    });

                    if (userlist[index]['email']
                            .toString()
                            .contains(widget.substring.toString()) &&
                        userlist[index]['email'].toString() !=
                            loggedinuser.email &&
                        alreadyfriend == false) {
                      return Container(
                        child: namecardofusersall(
                            printdata: userlist[index]['name'].toString(),
                            email: userlist[index]['email'].toString(),
                            requiredjob: (() {
                              String friendemailadd = userlist[index]['email'];
                              String friendnameadd = userlist[index]['name'];
                              return alertForAll(context,
                                  title: 'Add As Friend',
                                  desc:
                                      '\n\n\nConfirm To Add In Your Friendlist',
                                  buttontext: 'Confirm', butonfunction: (() {
                                _clouddata
                                    .doc(loggedinuser.email)
                                    .collection('friendlist')
                                    .doc(friendemailadd)
                                    .set({
                                  'friendname': friendnameadd,
                                  'friendemail': friendemailadd
                                });
                                _clouddata
                                    .doc(friendemailadd)
                                    .collection('friendlist')
                                    .doc(loggedinuser.email)
                                    .set({
                                  'friendname': loggedinuser.displayName,
                                  'friendemail': loggedinuser.email
                                });

                                setState(() {
                                  Navigator.pop(context);
                                });
                              }), closebutonfunction: (() {
                                setState(() {
                                  Navigator.pop(context);
                                });
                              })).show();
                            })),
                      );
                    }
                    return const SizedBox(
                      height: 1,
                    );
                  } catch (e) {
                    return messagecardofall(
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
