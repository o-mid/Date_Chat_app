import 'package:flutter/material.dart';

class Purpose extends StatelessWidget {
  const Purpose({required this.dropdownValue, required this.updateValue});
  final String dropdownValue;
  final Function updateValue;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "I am here ",
          style: TextStyle(
            fontSize: 16,
            fontFamily: "OpenSans",
            color: Colors.white,
          ),
        ),
        Expanded(
          child: DropdownButton<String>(
            iconEnabledColor: Colors.white54,
            isExpanded: true,
            value: dropdownValue,
            underline: SizedBox(),
            icon: Icon(Icons.keyboard_arrow_down),
            dropdownColor: Color(0xFF73AEF5),
            items: <DropdownMenuItem<String>>[
              DropdownMenuItem(
                  value: "For Help",
                  child: Text(
                    "for help",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: "OpenSans",
                      color: Colors.white,
                    ),
                  )),
              DropdownMenuItem(
                  value: "To Help",
                  child: Text(
                    "to offer help",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: "OpenSans",
                      color: Colors.white,
                    ),
                  )),
              DropdownMenuItem(
                  value: "Both",
                  child: Text(
                    "for both",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: "OpenSans",
                      color: Colors.white,
                    ),
                  ))
            ],
            onChanged: (String? newValue) {
              updateValue(newValue);
            },
          ),
        ),
      ],
    );
  }
}
