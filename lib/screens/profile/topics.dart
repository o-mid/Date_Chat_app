import 'package:flutter/material.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:messageapp/common/style.dart';
import 'package:messageapp/providers/profile_provider.dart';
import 'package:messageapp/screens/matching.dart';
import 'package:messageapp/screens/screens.dart';
import 'package:messageapp/server/server.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class Topics extends StatefulWidget {
  static const urlName = "topics";
  Topics({Key? key}) : super(key: key);
  @override
  _TopicsState createState() => _TopicsState();
}

class _TopicsState extends State<Topics> {
  late ProfileProvider profileProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    profileProvider = Provider.of<ProfileProvider>(context);
  }

  @override
  void dispose() {
    super.dispose();
    FluttermojiController().dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        gradient: kSacffoldBackgroundGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            color: Colors.white,
            onPressed: () =>
                Navigator.of(context).pushNamed(EditProfile.urlName),
            icon: Icon(Icons.edit),
          ),
          actions: [
            IconButton(
              alignment: Alignment.centerLeft,
              color: Colors.white,
              onPressed: () {
                FluttermojiController().dispose();
                Get.delete<FluttermojiController>();
                Server.sendRequest("Client/Logout", {});
                Navigator.of(context).pushReplacementNamed(LoginScreen.urlName);
              },
              icon: Icon(Icons.exit_to_app_outlined),
            ),
          ],
        ),
        body: Container(
          child: Column(
            children: [
              Spacer(),
              Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FluttermojiCircleAvatar(
                      radius: height * 0.15,
                      backgroundColor: Colors.white,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "loading",
                      style: Theme.of(context).textTheme.headline3,
                    )
                  ],
                ),
              ),
              Spacer(flex: 5),
              GestureDetector(
                onTap: () {
                  profileProvider.stopListeningToChanges();
                  Navigator.of(context)
                      .pushNamed(Matching.urlName)
                      .then((value) {
                    profileProvider.startListeningToChanges();
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 64, vertical: 16),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  child: Text(
                    "Match Me !",
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        ?.copyWith(color: Colors.blue),
                  ),
                ),
              ),
              Spacer()
            ],
          ),
        ),
      ),
    );
  }
}
