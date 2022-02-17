import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:messageapp/models/user.dart';
import 'package:messageapp/common/common.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:messageapp/widgets/snackbars.dart';
import 'package:messageapp/screens/profile/profile.dart';
import 'package:messageapp/providers/profile_provider.dart';

import '../providers/providers.dart';
import '../widgets/widgets.dart';
import '../server/server.dart';

enum _Pages { SplashScreen, LoadingPage, LoginPage, SignUpPage }

class LoginScreen extends StatefulWidget {
  static const urlName = "login";
  static _LoginScreenState? of(BuildContext context) =>
      context.findRootAncestorStateOfType<_LoginScreenState>();

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Router Variables
  AppRouter appRouter = AppRouter();
  bool loginLoading = false;
  _Pages displayedPage = _Pages.SplashScreen;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // UI Variables
  TextEditingController passwordController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  String loadingDisplayText = 'LOADING...';
  bool agreeToTerms = false;
  String errorMessage = '';
  bool exceptionallyNavigated = false;

  final RegExp email = RegExp(
      r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$");

  Future connectToSocket() async {
    Server.onServerRouteMessageCall(onServerRoute);
    Server.onServerConnectedCall(onServerEvent);
    Server.onServerDisconnectedCall(snackbarHandeler);
    await Server.initializeServer("18.192.134.62", 4455);
    await Server.connect();
  }

  @override
  void initState() {
    appRouter.scaffoldKey = scaffoldKey;
    connectToSocket();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    Server.removeServerRouteMessageCall(onServerRoute);
  }

  @override
  Widget build(BuildContext context) {
    Widget renderedWidget;
    switch (displayedPage) {
      case _Pages.SplashScreen:
        renderedWidget = _buildSplashScreenPage(context);
        break;
      case _Pages.LoadingPage:
        renderedWidget = _buildLoadingPage(context);
        break;
      case _Pages.LoginPage:
        renderedWidget = _buildLoginPage(context);
        break;
      default:
        renderedWidget = _buildSignUpPage(context);
    }

    return Scaffold(
      key: scaffoldKey,
      body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          // REAL ACTION IS HERE
          child: renderedWidget),
    );
  }

  void onServerEvent(String event) {
    switch (event.toLowerCase()) {
      case "connected":
        loadingDisplayText = "SERVER CONNECTED";
        break;

      case "disconnected":
        loadingDisplayText = "SERVER DISCONNECTED";
        break;
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onServerRoute(String route, String payload) {
    // ScaffoldMessenger.of(context)
    //     .showSnackBar(SnackBar(content: Text(route + '\n' + payload)));
    // print(payload);
    switch (route.toLowerCase()) {
      case "client/login":
        Map<String, dynamic> jsonResponse = json.decode(payload);
        if (jsonResponse['success'] != false) {
          if (emailController.text != "")
            Provider.of<ProfileProvider>(context, listen: false).cacheCreds(
                emailController.text.trim(), passwordController.text);
          User user = User.fromJson(jsonResponse);
          Provider.of<ProfileProvider>(context, listen: false)
              .initializeProfile(user);
          Navigator.of(context).pushReplacementNamed(Profile.urlName);
        } else {
          setState(() {
            loginLoading = false;
          });
          loadingDisplayText = "YOUR ACCOUNT IS BANNED!";
          errorMessage = jsonResponse['error'];
          // Server.disconnect();
        }
        break;
      case "client/signup":
        Map<String, dynamic> jsonResponse = json.decode(payload);
        if (jsonResponse['success'] != false) {
          Provider.of<ProfileProvider>(context, listen: false)
              .cacheCreds(emailController.text.trim(), passwordController.text);
          User user = User.fromJson(jsonResponse);
          Provider.of<ProfileProvider>(context, listen: false)
              .initializeProfile(user);
          Navigator.of(context).pushReplacementNamed(Profile.urlName);
        } else {
          errorMessage = jsonResponse['error'];
          displayedPage = _Pages.SignUpPage;
        }
        break;
      default:
    }

    if (mounted) {
      setState(() {});
    }
  }

  void displayErrorForDuration(String message) async {
    if (mounted) {
      setState(() {
        errorMessage = message;
      });
    }

    await new Future.delayed(const Duration(seconds: 5));

    if (mounted) {
      setState(() {
        errorMessage = '';
      });
    }
  }

  void onLoginEmailBtnClick() {
    if (emailController.text == "" || passwordController.text == "") {
      displayErrorForDuration("Please Enter Email and Password");
      setState(() {
        loginLoading = false;
      });
      return;
    } else if (!email.hasMatch(emailController.text.trim().toLowerCase())) {
      displayErrorForDuration("Please Enter a valid Email");
      setState(() {
        loginLoading = false;
      });
      return;
    } else {
      Server.sendRequest('Client/Login', {
        'email': emailController.text.trim(),
        'password': passwordController.text
      });
      if (mounted) {
        Future.delayed(Duration(seconds: 5), () {
          if (loginLoading && mounted) {
            setState(() {
              loginLoading = false;
            });
            displayErrorForDuration(
                "Check your internet connection and try again");
          }
        });
      }
    }
  }

  void onLoginAnonBtnClick() {
    Server.sendRequest('Client/Login', {
      'email': emailController.text.trim(),
      "password": passwordController.text
    });
    // setState(() {
    //   loadingDisplayText = "ATTEMPING TO LOGIN..";
    //   displayedPage = _Pages.LoadingPage;
    // });
  }

  void onSignUpBtnClick() {
    if (emailController.text == "" || passwordController.text == "") {
      displayErrorForDuration("Please Enter Email and Password");
      return;
    } else if (!email.hasMatch(emailController.text)) {
      displayErrorForDuration("Please Enter a valid Email");
      return;
    } else if (!agreeToTerms) {
      displayErrorForDuration("Do you agree to our Terms of Service?");
      return;
    }

    // setState(() {
    //   loadingDisplayText = "ATTEMPING TO SIGNUP..";
    //   displayedPage = _Pages.LoadingPage;
    // });

    Server.sendRequest('Client/Signup',
        {"email": emailController.text, "password": passwordController.text});
  }

  void switchToPage(_Pages page) {
    setState(() {
      displayedPage = page;
    });
  }

  Widget _buildLoginPage(BuildContext context) {
    // SharedPreferences.getInstance().then(
    //   (val) => ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text(
    //         val.getKeys().toString(),
    //       ),
    //     ),
    //   ),
    // );

    return Container(
      height: double.infinity,
      decoration: BoxDecoration(gradient: kSacffoldBackgroundGradient),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 40.0,
          vertical: 60.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset(
              "assets/logos/HAYAT_Transparent.png",
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            SizedBox(height: 16),
            Text(
              'Sign In',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24.0),
            _widgetEmailTF(),
            _widgetPasswordTF(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0),
              child: _widgetRedText(errorMessage),
            ),
            loginLoading
                ? CircularProgressIndicator()
                : Buttons.rounded(
                    text: "LOGIN",
                    width: double.infinity,
                    onPressed: () {
                      setState(() {
                        loginLoading = true;
                      });
                      onLoginEmailBtnClick();
                    },
                  ),
            SizedBox(height: 18.0),
            Divider(
              color: Colors.white,
              indent: 8,
              endIndent: 8,
            ),
            SizedBox(height: 8.0),
            _widgetGoToSignUpBtn(),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpPage(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: kSacffoldBackgroundGradient),
      child: Container(
        height: double.infinity,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: 40.0,
            vertical: 60.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/logos/HAYAT_Transparent.png",
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              SizedBox(height: 16),
              Text('Sign Up',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(height: 8.0),
              _widgetEmailTF(),
              SizedBox(height: 8.0),
              _widgetPasswordTF(),
              SizedBox(height: 4.0),
              _widgetRedText(errorMessage),
              SizedBox(height: 8.0),
              _widgetTermsAndConditions(),
              SizedBox(height: 18.0),
              _widgetSignUpBtn(),
              SizedBox(height: 18.0),
              Divider(
                color: Colors.white,
                indent: 8,
                endIndent: 8,
              ),
              SizedBox(height: 8.0),
              _widgetGoToLoginBtn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingPage(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: kSacffoldBackgroundGradient),
      child: Column(
        children: <Widget>[
          SizedBox(height: 80.0),
          _howAreYouFeelingLogo(),
          SizedBox(height: 100.0),
          _widgetWhiteText(loadingDisplayText),
          Container(
            padding: EdgeInsets.all(6.0),
            width: 180.0,
            child: LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          _widgetWhiteText("- We never collect or sell your Data -"),
          _widgetWhiteText("- You're 100% anonymous to others -"),
          SizedBox(height: 30.0)
        ],
      ),
    );
  }

  Widget _buildSplashScreenPage(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      if (mounted)
        Provider.of<ProfileProvider>(context, listen: false)
            .loginWithCache()
            .then((cachedLogin) {
          if (cachedLogin != true) switchToPage(_Pages.LoginPage);
        });
    });

    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: kSacffoldBackgroundGradient,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 25),
          Text(
            "Loading...",
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(color: Colors.white),
          )
        ],
      ),
    );
  }

  Widget _widgetEmailTF() {
    return InputFieldWithIconAndHeader(
      maxLength: 60,
      keyboardType: TextInputType.emailAddress,
      icon: Icon(
        Icons.mail,
        color: Colors.white,
      ),
      header: "Email",
      hintText: "Enter your Email",
      controller: emailController,
      obscureText: false,
    );
  }

  Widget _widgetPasswordTF() {
    return InputFieldWithIconAndHeader(
      maxLength: 20,
      icon: Icon(
        Icons.lock,
        color: Colors.white,
      ),
      header: "Password",
      hintText: "Enter your Password",
      controller: passwordController,
      obscureText: true,
    );
  }

  Widget _widgetSignUpBtn() {
    return Buttons.rounded(
      text: "SIGN UP",
      width: double.infinity,
      onPressed: () => onSignUpBtnClick(),
    );
  }

  Widget _widgetRedText(text) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontFamily: "OpenSans",
          color: Colors.redAccent[700],
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _widgetTermsAndConditions() {
    TextStyle defaultStyle = TextStyle(color: Colors.white);
    TextStyle linkStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.underline,
    );

    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: agreeToTerms,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  agreeToTerms = value ?? false;
                });
              },
            ),
          ),
          RichText(
            text: TextSpan(
              style: defaultStyle,
              children: <TextSpan>[
                TextSpan(text: 'I Agree to '),
                TextSpan(
                    text: 'Terms of Service',
                    style: linkStyle,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        if (await canLaunch(
                            "https://docs.google.com/document/d/1HRlGDdw6s2IOe0FVHNnkap3cBqb5IuinqmFLcaSM_4k")) {
                          await launch(
                              "https://docs.google.com/document/d/1HRlGDdw6s2IOe0FVHNnkap3cBqb5IuinqmFLcaSM_4k");
                        }
                      })
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _widgetWhiteText(text) {
    return Text(
      text,
      style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
          fontFamily: "OpenSans"),
    );
  }

  Widget _widgetGoToSignUpBtn() {
    return Buttons.textline(
        text: "Don't have an account? Sign Up",
        onPressed: () => switchToPage(_Pages.SignUpPage));
  }

  Widget _widgetGoToLoginBtn() {
    return Buttons.textline(
        text: "Already have an account? Login",
        onPressed: () => switchToPage(_Pages.LoginPage));
  }

  Widget _howAreYouFeelingLogo() {
    return RichText(
      text: TextSpan(
        // style: GoogleFonts.berkshireSwash(z`
        //   height: 0.9,
        //   fontSize: 40.0,
        //   color: Colors.white,
        //   fontWeight: FontWeight.bold,
        // ),
        children: <TextSpan>[
          TextSpan(text: 'How are you       '),
          TextSpan(text: '\n         feeling today?'),
          TextSpan(
            text: '\n-Mental Health Initiative-',
            // style: GoogleFonts.raleway(
            //   height: 1.5,
            //   fontSize: 18.0,
            //   letterSpacing: 4,
            //   color: Colors.white,
            //   fontWeight: FontWeight.normal,
            // ),
          )
        ],
      ),
    );
  }
}
