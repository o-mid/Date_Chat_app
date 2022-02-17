import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttermoji/fluttermojiFunctions.dart';

// Constants
final sentMsgColor = Color.fromRGBO(55, 155, 255, 1.0);
final receivedMsgColor = Color.fromRGBO(255, 255, 255, 1.0);
final infoMsgColor = Color.fromRGBO(212, 234, 244, 1.0);

// Classes of the custom bubbles
class MessageBubble extends StatelessWidget {
  final String text;
  final String svg;
  final bool showNip;
  final bool received;
  const MessageBubble(
      {required this.svg,
      required this.text,
      this.received = false,
      this.showNip = false,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        textDirection: received ? TextDirection.ltr : TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.string(
            FluttermojiFunctions().decodeFluttermojifromString(svg),
            height: 48,
          ),
          Expanded(
            child: Bubble(
              // nipHeight: 20,
              nipOffset: 15,
              child: Text(
                text.trim(),
                style: TextStyle(
                    fontFamily: "OpenSans",
                    color: received ? Colors.black : Colors.white,
                    fontSize: 13.0,
                    fontWeight: FontWeight.w600),
              ),
              elevation: 2.0,
              padding: BubbleEdges.all(8.0),
              margin: BubbleEdges.only(
                top: 4.0,
                bottom: 2.0,
                left: received ? 4.0 : 64.0,
                right: received ? 64.0 : 4.0,
              ),
              color: received ? receivedMsgColor : sentMsgColor,
              nip: received ? BubbleNip.leftTop : BubbleNip.rightTop,
              alignment:
                  received ? Alignment.centerLeft : Alignment.centerRight,
            ),
          ),
          // received
          //     ? SizedBox()
          //     : SvgPicture.string(
          //         FluttermojiFunctions().decodeFluttermojifromString(svg),
          //         height: 48,
          //       ),
        ],
      ),
    );
  }
}

class InfoBubble extends StatelessWidget {
  final String text;

  const InfoBubble({required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Bubble(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.black, fontSize: 14.0, fontFamily: "OpenSans"),
      ),
      elevation: 0.0,
      color: infoMsgColor,
      padding: BubbleEdges.all(8.0),
      margin: BubbleEdges.symmetric(vertical: 4.0),
    );
  }
}
