import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:messageapp/models/bubble_item.dart';
import 'package:messageapp/models/user.dart';
import 'package:messageapp/providers/profile_provider.dart';
import 'package:provider/provider.dart';

import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/widgets.dart';
import '../models/models.dart';
import '../server/server.dart';

class ChatScreen extends StatefulWidget {
  static const urlName = "chat";
  ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late User receiver;
  late int senderId;
  late String senderSvg;
  bool userLeft = false;
  bool isChatActive = true;
  List<BubbleItem> messages = [];
  String _appBarTitle = "Online";

  ScrollController _scrollController = ScrollController();
  TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    senderId =
        Provider.of<ProfileProvider>(context, listen: false).user.serverId;
    senderSvg =
        Provider.of<ProfileProvider>(context, listen: false).user.avatar;
    isChatActive = true;
    typingSignalBoradcasterLoop();
    Server.onServerRouteMessageCall(onServerRoute);
    messages.add(BubbleItem(
        type: "info", payload: "This is the beginning of the conversation."));
    Server.sendRequest("Chat/info", "");
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Scrolling to the bottom
    if (messages.isNotEmpty)
      WidgetsBinding.instance?.addPostFrameCallback((_) => {
            _scrollController.jumpTo(_scrollController.position.maxScrollExtent)
          });

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: SvgPicture.asset(
              'assets/logos/Logo.svg',
              height: 50,
            ),
            // Image.asset(
            //   "assets/logos/HAYAT_Transparent.png",
            //   fit: BoxFit.fitHeight,
            //   alignment: Alignment.center,
            //   cacheHeight: 50,
            // ),
            actions: [
              IconButton(
                  icon: Icon(Icons.report, color: Colors.red),
                  onPressed: _reportChat)
            ],
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  userLeft = true;
                  _exitChat();
                }),
          ),
          body: GestureDetector(
            onTap: FocusScope.of(context).unfocus,
            child: SafeArea(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: messages.length == 0
                        ? SizedBox()
                        : ListView.builder(
                            controller: _scrollController,
                            itemCount: messages.length,
                            itemBuilder: (context, index) =>
                                _messageBuilder(context, index),
                          ),
                  ),
                ),
                isChatActive
                    ? Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomInput(
                              controller: _textController,
                              onChanged: (_) => {},
                            ),
                            IconButton(
                                padding: EdgeInsets.all(4.0),
                                icon: Icon(
                                  Icons.send,
                                  color: Theme.of(context).primaryColorDark,
                                  size: 30,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _sendRequest(_textController.text);
                                    _textController.text = '';
                                  });
                                })
                          ],
                        ),
                      )
                    : Container(),

                // input part
              ],
            )),
          )),
    );
  }

  Widget _messageBuilder(context, index) {
    var msg = messages[index];

    switch (msg.type.toLowerCase()) {
      case "sent":
        return MessageBubble(
          showNip: true,
          svg: senderSvg,
          text: msg.payload,
          received: false,
        );
      case "received":
        return MessageBubble(
          showNip: true,
          svg: receiver.avatar,
          text: msg.payload,
          received: true,
        );

      // case "info":
      //   return InfoBubble(text: msg.payload);

      case "devider":
        return SizedBox(height: 24.0);

      default:
        return SizedBox(height: 8.0);
    }
  }

  void _exitChat() {
    Server.sendRequest("Chat/Leave", {});
    Navigator.of(context).pop();
  }

  void _reportChat() {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = ElevatedButton(
      child: Text("Report"),
      style: ElevatedButton.styleFrom(primary: Colors.red),
      onPressed: () {
        userLeft = true;
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Server.sendRequest("Chat/Report", {});
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      titlePadding: EdgeInsets.all(0),
      title: Container(
        padding: EdgeInsets.all(14),
        color: Colors.blue,
        child: Text("Report Chat", style: TextStyle(color: Colors.white)),
      ),
      content: Text(
        "Are you sure you want to report this stranger?",
        style: TextStyle(fontFamily: "OpenSans"),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

    FocusScope.of(context).requestFocus(FocusNode());
  }

  void _sendRequest(String msg) {
    if (msg.length > 0) {
      Server.sendRequest(
          "Chat/Message",
          jsonEncode({
            "message": msg,
            "type": "message",
            "senderId": senderId.toString(),
          }));
    }
  }

  void _onParseMessage(MessageRequest message) {
    switch (message.type.toLowerCase()) {
      case "message":
        _appBarTitle = "Online";
        if (messages.length > 0) {
          if (message.senderId != senderId.toString())
            messages.add(BubbleItem(
              type: "received",
              id: message.senderId,
              payload: message.message,
            ));
          else
            messages.add(BubbleItem(
              type: "sent",
              id: message.senderId,
              payload: message.message,
            ));
        }
        print(message.message);
        setState(() {});
        break;

      case "online":
        _appBarTitle = "Online";
        messages.add(BubbleItem(
          type: "info",
          payload: message.message,
        ));
        break;

      case "offline":
        _appBarTitle = "Offline";
        messages.add(BubbleItem(
          type: "info",
          payload: message.message,
        ));
        break;

      case "typing":
        if (message.senderId != receiver.serverId.toString()) {
          _appBarTitle = "typing...";
        }
        break;

      case "report":
        messages.add(BubbleItem(
          type: "info",
          payload: message.message,
        ));
        break;
    }
  }

  void onServerRoute(String route, String payload) {
    switch (route.toLowerCase()) {
      case "chat/info":
        receiver = User.fromJson((json.decode(payload) as Map)['stranger']);
        break;
      case "chat/infomessage":
        var json = jsonDecode(payload);
        _onParseMessage(MessageRequest.fromJson(json));
        break;

      case "chat/report":
        isChatActive = false;
        _appBarTitle = "Disconnected";
        var json = jsonDecode(payload);
        _onParseMessage(MessageRequest.fromJson(json));
        break;

      case "chat/chatmessage":
        _appBarTitle = "Online";
        var json = jsonDecode(payload);
        _onParseMessage(MessageRequest.fromJson(json));
        break;

      case "chat/leave":
        isChatActive = false;
        _appBarTitle = "Disconnected";
        messages.add(BubbleItem(
          type: "info",
          payload: "Stranger Left!",
        ));
        if (!userLeft)
          showDialog(
            context: context,
            builder: (BuildContext ctx) => AlertDialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              titlePadding: EdgeInsets.all(0),
              title: Container(
                padding: EdgeInsets.symmetric(vertical: 24, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Text(
                  "${receiver.username} has left the room",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "OpenSans", fontWeight: FontWeight.bold),
                ),
              ),
              contentPadding: EdgeInsets.all(0),
              content: GestureDetector(
                  onTap: () {
                    _exitChat();
                    Navigator.of(context).pop();
                  },
                  child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      child: Text(
                        "Leave Chat",
                        textAlign: TextAlign.center,
                      ))),
            ),
          );
        break;
    }
    setState(() {});
  }

  void typingSignalBoradcasterLoop() async {
    while (true) {
      if (_textController.text.length > 0) {
        Server.sendRequest(
            "Chat/InfoMessage",
            MessageRequest(
                type: "typing",
                senderId: senderId.toString(),
                message: "Info"));
        await Future.delayed(Duration(seconds: 3));
      }
      await Future.delayed(Duration(seconds: 1));
    }
  }
}
