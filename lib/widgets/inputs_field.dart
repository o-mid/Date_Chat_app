import 'package:flutter/material.dart';
import '../common/common.dart';

class CustomInput extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const CustomInput(
      {required this.controller, required this.onChanged, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(16.0)),
      borderSide:
          BorderSide(width: 2.0, color: Theme.of(context).primaryColorDark),
    );

    return Expanded(
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: TextField(
          minLines: 1,
          maxLines: 3,
          style: TextStyle(
              fontSize: 14.0,
              letterSpacing: 1,
              color: Colors.black,
              decoration: TextDecoration.none,
              fontFamily: "OpenSans",
              fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            enabled: true,
            enabledBorder: border,
            focusedBorder: border,
            hintText: 'Write a message..',
            contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
            hintStyle: TextStyle(
              color: Colors.black54,
              fontSize: 14.0,
            ),
          ),
          controller: controller,
          onChanged: (_) => onChanged(_),
        ),
      ),
    );
  }
}

class InputFieldSimple extends StatelessWidget {
  final int? flex;
  final String placeholder;
  final TextEditingController controller;
  const InputFieldSimple(
      {Key? key,
      required this.controller,
      this.flex = 1,
      required this.placeholder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: flex ?? 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new TextField(
          controller: this.controller,
          decoration: new InputDecoration(
            hintText: this.placeholder,
          ),
        ),
      ),
    );
  }
}

class RoundedInputFieldSimple extends StatelessWidget {
  final int flex;
  final String placeholder;
  final TextEditingController controller;
  const RoundedInputFieldSimple(
      {Key? key,
      required this.controller,
      required this.flex,
      required this.placeholder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: flex,
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: new TextField(
          controller: controller,
          decoration: new InputDecoration(
            border: new OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                const Radius.circular(10.0),
              ),
            ),
            filled: true,
            hintStyle: new TextStyle(color: Colors.grey[800]),
            hintText: this.placeholder,
            fillColor: Colors.white70,
          ),
        ),
      ),
    );
  }
}

class InputFieldWithIcon extends StatelessWidget {
  final Icon icon;
  final String hintText;
  final TextEditingController controller;
  const InputFieldWithIcon(
      {Key? key,
      required this.controller,
      required this.hintText,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: kBoxDecorationStyle,
      height: 50.0,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'OpenSans',
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 14.0),
          prefixIcon: icon,
          hintText: hintText,
          hintStyle: kHintTextStyle,
        ),
      ),
    );
  }
}

class InputFieldWithIconAndHeader extends StatelessWidget {
  final Icon icon;
  final int maxLength;
  final String header;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController controller;
  const InputFieldWithIconAndHeader({
    Key? key,
    required this.controller,
    this.obscureText = false,
    required this.header,
    required this.hintText,
    required this.icon,
    this.maxLength = 16,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(header, style: kLabelStyle),
        SizedBox(height: 2.0),
        Container(
          decoration: kBoxDecorationStyle,
          height: 50,
          child: TextField(
            maxLength: maxLength,
            controller: controller,
            obscureText: obscureText,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              counterText: "",
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: icon,
              hintText: hintText,
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
        SizedBox(height: 6.0),
      ],
    );
  }
}

class ExpandedInputFieldWithIconAndHeader extends StatelessWidget {
  final Icon icon;
  final int maxLength;
  final String header;
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  const ExpandedInputFieldWithIconAndHeader({
    Key? key,
    required this.controller,
    this.obscureText = false,
    required this.header,
    required this.hintText,
    required this.icon,
    this.maxLength = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(header, style: kLabelStyle),
        SizedBox(height: 2.0),
        Container(
          decoration: kBoxDecorationStyle,
          child: TextFormField(
            maxLength: maxLength,
            maxLines: null,
            controller: controller,
            obscureText: obscureText,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              counterText: "",
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 16, bottom: 16),
              prefixIcon: icon,
              hintText: hintText,
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
        SizedBox(height: 6.0),
      ],
    );
  }
}
