import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:messageapp/models/user.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:messageapp/server/server.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider extends ChangeNotifier {
  late User user;

  void cacheCreds(String email, String password) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.setString("email", email);
    _pref.setString("password", password);
    // _pref.commit();
  }

  Future<bool> loginWithCache() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.reload();
    String email = _pref.getString("email") ?? "";
    String password = _pref.getString("password") ?? "";
    if (email == "" || password == "") {
      return false;
    } else {
      cacheCreds(email, password);
      await Server.sendRequest(
          'Client/Login', {'email': email, 'password': password});
      return true;
    }
  }

  ProfileProvider() {
    startListeningToChanges();
  }

  void logout() async {
    FluttermojiController().dispose();
    Get.delete<FluttermojiController>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void serverMessageHandler(String route, String payload) async {
    switch (route.toLowerCase()) {
      case "Client/Profile":
        User _user = User.fromJson(jsonDecode(payload));
        user = _user;
        SharedPreferences pref = await SharedPreferences.getInstance();
        FluttermojiController().getFluttermojiOptions();
        FluttermojiController().update();
        pref.setString("fluttermojiSelectedOptions", user.avatar);
        FluttermojiController().update();
        notifyListeners();
        break;
    }
  }

  void getProfile() {
    Server.sendRequest("Client/Profile", {});
  }

  void initializeProfile(User initUserData) async {
    user = initUserData;
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("fluttermojiSelectedOptions", user.avatar);
    FluttermojiController().init();
    notifyListeners();
  }

  void updateProfile(User newUserData) async {
    user = newUserData;
    SharedPreferences pref = await SharedPreferences.getInstance();
    user.avatar = pref.getString('fluttermojiSelectedOptions') ?? "";
    Server.sendRequest("Client/Update", json.encode(user));
    notifyListeners();
  }

  startListeningToChanges() {
    Server.onServerRouteMessageCall(serverMessageHandler);
  }

  stopListeningToChanges() {
    Server.removeServerRouteMessageCall(serverMessageHandler);
  }
}
