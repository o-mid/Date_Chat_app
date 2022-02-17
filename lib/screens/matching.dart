import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:messageapp/common/style.dart';
import 'package:messageapp/models/user.dart';
import 'package:messageapp/screens/screens.dart';

import 'package:messageapp/widgets/user_card.dart';
import '../server/server.dart';
import 'package:get/get.dart';

class Matching extends StatefulWidget {
  static const urlName = "matching";
  final BuildContext context;
  const Matching(this.context, {Key? key}) : super(key: key);

  @override
  _MatchingState createState() => _MatchingState();
}

class _MatchingState extends State<Matching> {
  List<User> users = [];
  bool buttonEnabled = true;
  List<Widget> userCards = [];
  bool loading = false;
  bool noMoreUsers = false;
  bool error = false;
  Timer? loadingTimer;

  Future fetchUsers() async {
    setState(() {
      buttonEnabled = false;
      loading = true;
    });
    Server.sendRequest("Chat/list", {});
    Future.delayed(Duration(seconds: 5), () {
      if (mounted)
        setState(() {
          buttonEnabled = true;
          loading = false;
        });
    });
  }

  void serverRoute(String route, String payload) {
    Map response = jsonDecode(payload);
    String _error = response['error'] ?? "";

    if (_error.contains("Session")) {
      FluttermojiController().dispose();
      Get.delete<FluttermojiController>();
      Server.sendRequest("Client/Logout", {});
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed(LoginScreen.urlName);
    }

    if (route == "Chat/List") {
      users = [];

      List _users = (response['users'] as List);

      if (response['success']) {
        if (_users.length > 0)
          _users.forEach((user) => users.add(User.fromJson(user)));
        setState(() {
          noMoreUsers = false;
          loading = false;
          error = false;
          buttonEnabled = true;
        });
      } else
        setState(() {
          loading = false;
          error = true;
          buttonEnabled = true;
        });
    }
  }

  @override
  void initState() {
    super.initState();
    Server.onServerRouteMessageCall(serverRoute);
    Server.sendRequest('Matching/Enqueue', {});
    Server.sendRequest("Chat/list", {});
  }

  @override
  void dispose() {
    Server.removeServerRouteMessageCall(serverRoute);
    Server.sendRequest('matching/dequeue', {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: kSacffoldBackgroundGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: buttonEnabled ? fetchUsers : null,
                icon: Icon(Icons.refresh,
                    color: buttonEnabled ? Colors.white : Colors.grey))
          ],
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        body: Container(
          // alignment: Alignment.center,
          width: double.infinity,
          // padding: EdgeInsets.only(bottom: 8),
          child: loading
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 12),
                    Text("Searching for Users",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "OpenSans",
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    Text("please be patient",
                        style: TextStyle(
                            fontFamily: "OpenSans", color: Colors.white)),
                  ],
                )
              : error
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                          Text("Sorry, our servers are \nbusy right now.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: "OpenSans",
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text("Try again in 5 seconds",
                              style: TextStyle(
                                  fontFamily: "OpenSans", color: Colors.white)),
                        ])
                  : noMoreUsers
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              Text(
                                  "You've seen all potentional\nmatches in your area",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: "OpenSans",
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600)),
                              SizedBox(height: 8),
                              Text("Refresh the page to see more people",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: "OpenSans",
                                      fontSize: 14,
                                      color: Colors.white60)),
                            ])
                      : users.length > 0
                          ? Stack(alignment: Alignment.center, children: [
                              for (int index = 0; index < users.length; index++)
                                Container(
                                  margin: EdgeInsets.only(
                                      top: (10 * index).toDouble()),
                                  child: UserCard(index, users[index], () {
                                    setState(() {
                                      users.removeAt(index);
                                      users.remove(index);
                                      if (users.isEmpty) noMoreUsers = true;
                                    });
                                  }),
                                )
                            ])
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                  Text(
                                      "There is no one around you\nat the moment",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: "OpenSans",
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600)),
                                  SizedBox(height: 8),
                                  Text("Try again in 5 seconds",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: "OpenSans",
                                          color: Colors.white60)),
                                ]),
        ),
      ),
    );
  }

  void onQuitMatching() {
    Server.sendRequest("MatchingSystem/QuitMatching", {});
  }
}
