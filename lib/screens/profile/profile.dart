import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:messageapp/common/style.dart';
import 'package:messageapp/common/router.dart';
import 'package:messageapp/models/user.dart';
import 'package:messageapp/screens/matching.dart';
import 'package:messageapp/screens/screens.dart';
import 'package:messageapp/server/server.dart';
import 'package:messageapp/widgets/invitation_card.dart';
import 'package:messageapp/providers/profile_provider.dart';

class Profile extends StatefulWidget {
  static const urlName = "profile";
  Profile({Key? key}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // Router Variables
  AppRouter appRouter = AppRouter();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // User Data
  late User user;
  bool alreadyInChat = false;
  late ProfileProvider profileProvider;

  // UI Variables
  bool handlerSet = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    profileProvider = Provider.of<ProfileProvider>(context);
    user = profileProvider.user;
  }

  @override
  void initState() {
    super.initState();
    Server.onServerRouteMessageCall(serverRoute);
    appRouter.scaffoldKey = scaffoldKey;
  }

  @override
  void dispose() {
    super.dispose();
    FluttermojiController().dispose();
  }

  void serverRoute(String route, String payload) {
    if (route == "Chat/Active" && !alreadyInChat) {
      alreadyInChat = true;
      if (ModalRoute.of(context)?.settings.name == "matching")
        Navigator.of(context)
            .pushReplacementNamed(ChatScreen.urlName)
            .then((_) {
          alreadyInChat = false;
        });
      else
        Navigator.of(context).pushNamed(ChatScreen.urlName).then((_) {
          alreadyInChat = false;
        });
      return;
    } else if (route == "Chat/Invitation") {
      if (!alreadyInChat)
        showDialog(
            context: context,
            builder: (BuildContext ctx) {
              return InvitationCard(payload: payload);
            });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        gradient: kSacffoldBackgroundGradient,
      ),
      child: Scaffold(
        key: scaffoldKey,
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
                profileProvider.logout();
                Server.sendRequest("Client/Logout", {});
                Navigator.of(context).pushReplacementNamed(LoginScreen.urlName);
              },
              icon: Icon(Icons.exit_to_app_outlined),
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FluttermojiCircleAvatar(
                      radius: height * 0.12,
                      backgroundColor: Colors.white,
                    ),
                    SizedBox(height: 16),
                    Text(
                      user.username,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    SizedBox(height: 8),
                    Text(user.biography,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            ?.copyWith(fontFamily: "OpenSans")),
                    Text(
                        user.heretohelp
                            ? "I am here to help"
                            : "I am here for help",
                        style: TextStyle(fontFamily: "OpenSans")),
                    SizedBox(height: 16),
                    Wrap(
                        spacing: 5,
                        alignment: WrapAlignment.center,
                        children: user.personalIssues
                            .map((element) => Container(
                                  margin: EdgeInsets.symmetric(vertical: 4),
                                  decoration: BoxDecoration(
                                      // color: Colors.primaries[Random()
                                      //     .nextInt(Colors.primaries.length)],
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20)),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 8),
                                  child: Text(element,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "OpenSans",
                                          fontSize: 12)),
                                ))
                            .toList())
                  ],
                ),
              ),
              Spacer(),
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
                  padding: EdgeInsets.symmetric(horizontal: 64, vertical: 8),
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
