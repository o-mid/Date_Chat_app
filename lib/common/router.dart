import 'package:flutter/material.dart';
import '../screens/screens.dart';

class AppRouter {
  GlobalKey<ScaffoldState>? scaffoldKey;
  static final AppRouter _instance = AppRouter._internal();
  factory AppRouter() => _instance;
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name?.toLowerCase()) {
      case '/':
        return MaterialPageRoute(builder: (context) => LoginScreen());
      // Authorization Views
      // case SplachScreen.urlName:
      //   return MaterialPageRoute(builder: (context) => SplachScreen());
      // Authorization Views
      case LoginScreen.urlName:
        return MaterialPageRoute(builder: (context) => LoginScreen());

      // Homescreen Views
      case Profile.urlName:
        return MaterialPageRoute(builder: (context) => Profile());

      // Homescreen Views
      // case HomeScreenMatchPage.urlName:
      //   return MaterialPageRoute(builder: (context) => HomeScreen());

      case EditProfile.urlName:
        return MaterialPageRoute(builder: (context) => EditProfile());

      case EditAvatar.urlName:
        return MaterialPageRoute(builder: (context) => EditAvatar());

      case Matching.urlName:
        return MaterialPageRoute(builder: (context) => Matching(context));

      case ChatScreen.urlName:
        return MaterialPageRoute(builder: (context) => ChatScreen());

      default:
        return MaterialPageRoute(builder: (context) => errorWidget(context));
    }
  }

  AppRouter._internal() {
    // scaffoldKey = GlobalKey<ScaffoldState>();
  }
}

Widget errorWidget(BuildContext context) {
  return Scaffold(
      body: Container(
    child: Column(
      children: [
        Icon(
          Icons.error,
          size: 128,
        ),
        Text("Route Was Not Found!"),
        SizedBox(
          height: 50,
        ),
        ElevatedButton(
            child: SizedBox(
              child: Center(child: Text("Back")),
              width: 128,
            ),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop();
              }
            })
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    ),
    alignment: Alignment.center,
  ));
}
