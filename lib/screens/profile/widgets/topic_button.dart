import 'package:flutter/material.dart';

class PickATopicBtn extends StatelessWidget {
  final Function showPickTopic;
  final String title;
  final int index;
  const PickATopicBtn(this.showPickTopic, this.index,
      {this.title = "Pick a topic"});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return ElevatedButton(
      onPressed: () => showPickTopic(index),
      style: ElevatedButton.styleFrom(
        fixedSize: Size(screenWidth, 40),
        elevation: 0.5,
        primary: Theme.of(context).primaryColor.withOpacity(0.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        title,
        style: TextStyle(fontFamily: "OpenSans"),
      ),
    );
  }
}
