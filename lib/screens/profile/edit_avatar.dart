import 'package:flutter/material.dart';
import 'package:messageapp/common/style.dart';
import 'package:fluttermoji/fluttermojiCustomizer.dart';
import 'package:fluttermoji/fluttermojiCircleAvatar.dart';

class EditAvatar extends StatefulWidget {
  static const urlName = "edit-avatar";
  EditAvatar({Key? key}) : super(key: key);
  @override
  _EditAvatarState createState() => _EditAvatarState();
}

class _EditAvatarState extends State<EditAvatar> {
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: kSacffoldBackgroundGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FluttermojiCircleAvatar(
              backgroundColor: Colors.transparent,
              radius: MediaQuery.of(context).size.height * 0.15,
            ),
            FluttermojiCustomizer(showSaveButton: false)
            // Spacer(),
          ],
        ),
      ),
    );
  }
}
