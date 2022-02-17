import 'package:flutter/material.dart';

class CardsVertical extends StatelessWidget {
  final List<Widget> children;
  const CardsVertical({Key? key, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: this.children,
      ),
    );
  }
}

class CardsHorizontal extends StatelessWidget {
  final List<Widget> children;
  const CardsHorizontal({Key? key, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: this.children,
      ),
    );
  }
}
