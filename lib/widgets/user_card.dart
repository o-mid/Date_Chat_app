import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttermoji/fluttermojiFunctions.dart';
import 'package:fluttermoji/fluttermoji_assets/fluttermojimodel.dart';
import 'package:messageapp/models/user.dart';
import 'package:messageapp/providers/profile_provider.dart';
import 'package:messageapp/server/server.dart';
import 'package:provider/provider.dart';

class UserCard extends StatefulWidget {
  UserCard(this.index, this.invitee, this.removeCard);
  final int index;
  final User invitee;
  final Function removeCard;
  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    User invitee = this.widget.invitee;
    String svg = invitee.avatar == ''
        ? FluttermojiFunctions()
            .decodeFluttermojifromString(jsonEncode(defaultFluttermojiOptions))
        : FluttermojiFunctions().decodeFluttermojifromString(invitee.avatar);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Draggable(
      onDragEnd: (drag) {
        if (drag.offset.dx.abs() > 100) {
          if (drag.offset.direction < 1) {
            // Perform some action
            User inviter =
                Provider.of<ProfileProvider>(context, listen: false).user;
            Server.sendRequest('Chat/invitation', {
              "inviteeServerId": invitee.serverId,
              "inviterServerId": inviter.serverId,
              "inviterAvatar": inviter.avatar,
              "inviterUsername": inviter.username,
              "inviterBiography": inviter.biography
            });
          }
          // Ignore
          this.widget.removeCard();
        }
      },
      childWhenDragging: Container(
          // height: 2,
          // width: 2,
          ),
      feedback: DraggableUserCard(
        width: width,
        svg: svg,
        height: height,
        invitee: invitee,
        widget: widget,
      ),
      child: DraggableUserCard(
        width: width,
        svg: svg,
        height: height,
        invitee: invitee,
        widget: widget,
      ),
    );
  }
}

class DraggableUserCard extends StatelessWidget {
  const DraggableUserCard({
    Key? key,
    required this.width,
    required this.svg,
    required this.height,
    required this.invitee,
    required this.widget,
  }) : super(key: key);

  final double width;
  final String svg;
  final double height;
  final User invitee;
  final UserCard widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.80,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 1.1,
          )
        ],
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      width: width * 0.9,
      padding: EdgeInsets.only(top: 8),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    flex: 2,
                    child: SvgPicture.string(
                      svg,
                      height: height * 0.22,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Text(
                    invitee.username,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        color: Colors.black,
                        fontFamily: "OpenSans",
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    invitee.biography,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    // strutStyle: StrutStyle(),
                    maxLines: 3,
                    softWrap: true,
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        fontFamily: "OpenSans",
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    invitee.heretohelp == true
                        ? "I am here to help"
                        : "I am here for help",
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        color: invitee.heretohelp == true
                            ? Colors.green
                            : Colors.red,
                        fontFamily: "OpenSans",
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                  Flexible(
                    flex: 2,
                    child: invitee.personalIssues.length > 0
                        ? Wrap(
                            runAlignment: WrapAlignment.start,
                            alignment: WrapAlignment.center,
                            runSpacing: 8,
                            children: invitee.personalIssues
                                .map(
                                  (e) => Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade400,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    margin: EdgeInsets.only(right: 4),
                                    child: Text(
                                      e,
                                      style: TextStyle(
                                          decoration: TextDecoration.none,
                                          color: Colors.white,
                                          fontFamily: "OpenSans",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                  ),
                                )
                                .toList())
                        : Center(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade400,
                                  borderRadius: BorderRadius.circular(20)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              margin: EdgeInsets.only(right: 4),
                              child: Text(
                                "Nothing Specific",
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    color: Colors.white,
                                    fontFamily: "OpenSans",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => this.widget.removeCard(),
                  style: ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                    padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.only(bottomLeft: Radius.circular(20)),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.remove),
                      SizedBox(width: 8),
                      Text(
                        'Ignore',
                        style: TextStyle(
                            fontFamily: "OpenSans",
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    User inviter =
                        Provider.of<ProfileProvider>(context, listen: false)
                            .user;
                    Server.sendRequest('Chat/invitation', {
                      "inviteeServerId": invitee.serverId,
                      "inviterServerId": inviter.serverId,
                      "inviterAvatar": inviter.avatar,
                      "inviterUsername": inviter.username,
                      "inviterBiography": inviter.biography
                    });
                    this.widget.removeCard();
                  },
                  style: ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    backgroundColor:
                        MaterialStateProperty.all(Colors.green.shade400),
                    padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.send),
                      SizedBox(width: 8),
                      Text(
                        'Invite',
                        style: TextStyle(
                            fontFamily: "OpenSans",
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
