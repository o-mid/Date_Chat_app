import 'package:flutter/material.dart';
import 'package:messageapp/common/router.dart';
import 'package:messageapp/server/server.dart';

void snackbarHandeler() {
  ScaffoldMessenger.of(AppRouter().scaffoldKey!.currentContext!).showSnackBar(
    SnackBar(
      duration: Duration(days: 1),
      backgroundColor: Colors.red,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: Text("You've lost connection to Internet."),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (AppRouter().scaffoldKey!.currentState!.mounted)
                  ScaffoldMessenger.maybeOf(
                          (AppRouter().scaffoldKey!.currentContext!))!
                      .hideCurrentSnackBar();
                Server.connect();
              },
              child: Text(
                "Reconnect",
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    ),
  );
}
