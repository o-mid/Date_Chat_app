import 'package:flutter/material.dart';

import '../common/common.dart';

abstract class Buttons extends Widget {
  factory Buttons.rounded(
          {Key? key,
          required String text,
          required Function onPressed,
          width = 200}) =>
      RoundedRaisedButton(text, width, onPressed);

  factory Buttons.textline(
          {Key? key,
          required String text,
          required Function onPressed,
          Alignment alignment = Alignment.center}) =>
      TextLineButton(text, onPressed, alignment);

  factory Buttons.circleImage({
    required image,
    required onPressed,
    double radius = 60.0,
    Key? key,
  }) =>
      CircleImageButton(image, onPressed, radius);
}

class RoundedRaisedButton extends StatelessWidget implements Buttons {
  final String text;
  final double width;
  final Function onPressed;

  RoundedRaisedButton(this.text, this.width, this.onPressed, {Key? key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      width: width,
      child: ElevatedButton(
        child: Text(text, style: kButtonTextStyle),
        onPressed: () => onPressed(),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0)),
          elevation: MaterialStateProperty.all(5.0),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
        ),
      ),
    );
  }
}

class TextLineButton extends StatelessWidget implements Buttons {
  final String text;
  final Function onPressed;
  final Alignment alignment;
  const TextLineButton(
    this.text,
    this.onPressed,
    this.alignment, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: ElevatedButton(
            onPressed: () => onPressed(),
            child: Text(text, style: kLabelStyle),
          ),
        ));
  }
}

class CircleImageButton extends StatelessWidget implements Buttons {
  final Function onPressed;
  final ImageProvider<Object> image;
  final double radius;
  const CircleImageButton(this.image, this.onPressed, this.radius, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed,
      child: Container(
        height: radius,
        width: radius,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(image: image),
        ),
      ),
    );
  }
}
