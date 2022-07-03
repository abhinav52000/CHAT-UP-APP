import 'package:flutter/material.dart';
import 'package:chat_up/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class MyButton extends StatelessWidget {
  const MyButton({Key? key, this.requiredJob, this.buttondata})
      : super(key: key);

  final String? buttondata;
  final void Function()? requiredJob;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      padding: const EdgeInsets.all(15.0),
      onPressed: requiredJob,
      focusColor: Colors.white,
      fillColor: Colors.blue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      constraints:
          const BoxConstraints(minHeight: 35, minWidth: double.infinity),
      elevation: 15,
      child: Column(
        children: [
          Text(
            '$buttondata',
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ],
      ),
    );
  }
}

Widget messagecard({String? data}) {
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8),
        ),
        constraints:
            const BoxConstraints(maxWidth: double.infinity, maxHeight: 40),
        alignment: Alignment.topLeft,
        child: Text(
          '$data',
          textAlign: TextAlign.left,
          style: const TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.normal),
        ),
      ),
      const SizedBox(
        height: 5,
      )
    ],
  );
}

class PasswordStyle extends StatefulWidget {
  const PasswordStyle(
      {Key? key, this.hinttext, this.requiredjob, this.submittedjob})
      : super(key: key);

  final String? hinttext;
  final void Function(String value)? requiredjob, submittedjob;

  @override
  State<PasswordStyle> createState() => _PasswordStyleState();
}

class _PasswordStyleState extends State<PasswordStyle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 0),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          TextField(
            onChanged: widget.requiredjob,
            onSubmitted: widget.submittedjob,
            obscureText: hidepassword,
            enableSuggestions: false,
            autocorrect: false,
            decoration: InputDecoration(
              // focusedBorder: registraionpagetilesborder,
              focusColor: Colors.white,
              hintText: widget.hinttext,
              // widget khi dikh nhi rha na ki ye varible kha se aaya par ye get function hai inbuilt
              // isme jo ki apko upr wle ka sare data ko . operator ke sath access karne ko dega.
              contentPadding: const EdgeInsets.all(10),
              enabledBorder: registraionpagetilesborder,
              focusedBorder: registraionpagetilesborder,
              constraints: const BoxConstraints.tightFor(width: 270),
              hintStyle: registrationpagestyle(opacity: 0.5),
            ),
            style: registrationpagestyle(),
          ),
          RawMaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            constraints: const BoxConstraints.tightFor(height: 40, width: 40),
            onPressed: (() => setState(() {
                  hidepassword = (hidepassword == true) ? false : true;
                })),
            child: const Icon(
              Icons.remove_red_eye,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// password matching ke liye alert
Alert alertForAll(BuildContext context,
    {String? title,
    String? desc,
    String? buttontext,
    void Function()? butonfunction,
    void Function()? closebutonfunction}) {
  return Alert(
    context: context,
    title: title,
    desc: desc,
    content: const SizedBox(height: 20),
    style: AlertStyle(
      titleStyle:
          registrationpagehead.copyWith(color: Colors.black, fontSize: 17),
      descStyle: registrationpagestyle()
          .copyWith(color: Colors.black.withOpacity(0.6), fontSize: 15),
    ),
    buttons: [
      DialogButton(
        onPressed: butonfunction,
        height: 40,
        child: Text(
          '$buttontext',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      // Jha jaruroi lge ki button chaiye wha dal do jha nhi lge
      // wha apne according chl hi rha hai
    ],
    closeFunction: closebutonfunction ?? butonfunction,
  );
}

// Content jo ki namecard ko show karega har jgh

Widget namecardofusersall(
    {String? printdata,
    String? email,
    Function()? requiredjob,
    Function()? longpressjob}) {
  return GestureDetector(
    onTap: requiredjob,
    onLongPress: longpressjob,
    child: Container(
      margin: const EdgeInsets.only(bottom: 5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: const AssetImage('Asset/messagecontainer.png'),
              fit: BoxFit.fill,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.8), BlendMode.overlay)),
          border: Border.all(color: Colors.white, width: 1),
          borderRadius: BorderRadius.circular(15)),
      constraints:
          const BoxConstraints.tightFor(height: 65, width: double.infinity),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$printdata',
            textAlign: TextAlign.center,
            style: GoogleFonts.alikeAngular(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 19,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            '$email',
            style: GoogleFonts.antic(color: Colors.white, fontSize: 15),
          ),
        ],
      ),
    ),
  );
}

//message card
Widget messagecardofall({String? printdata, String? name, bool? currentuser}) {
  return Padding(
    padding: (currentuser == true)
        ? const EdgeInsets.only(left: 50)
        : const EdgeInsets.only(right: 50),
    child: Container(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      margin: const EdgeInsets.only(bottom: 5, left: 10, right: 10),
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: const AssetImage('Asset/messagecontainer.png'),
            fit: BoxFit.fill,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.8), BlendMode.overlay)),
        border: Border.all(color: Colors.white, width: 1),
        borderRadius: (currentuser == true)
            ? const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
                bottomLeft: Radius.circular(25))
            : const BorderRadius.only(
                bottomRight: Radius.circular(25),
                topRight: Radius.circular(25),
                bottomLeft: Radius.circular(25)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$name',
            textAlign: TextAlign.start,
            style: GoogleFonts.antic(color: Colors.white, fontSize: 15),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            '$printdata',
            textAlign: TextAlign.left,
            style: GoogleFonts.alikeAngular(
              color: Colors.white,
              fontWeight: FontWeight.normal,
              fontSize: 15,
            ),
          ),
        ],
      ),
    ),
  );
}
