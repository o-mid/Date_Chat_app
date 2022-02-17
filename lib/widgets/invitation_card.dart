import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:messageapp/server/server.dart';
import 'package:fluttermoji/fluttermojiFunctions.dart';

class InvitationCard extends StatelessWidget {
  final String payload;
  InvitationCard({Key? key, required this.payload}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map response = json.decode(payload);
    List topicsList = response['inviterPersonalIssues'] == null
        ? []
        : json.decode(response['inviterPersonalIssues']);
    String svgPicture = FluttermojiFunctions()
        .decodeFluttermojifromString(response['inviterAvatar']);
    String name = response['inviterUsername'] ?? "Anonymous";
    String biography = response['inviterBiography'] ?? "I am new here.";
    bool hereToHelp = response['heretohelp'] ?? false;

    return AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      titlePadding: EdgeInsets.all(0),
      contentPadding: EdgeInsets.all(0),
      title: Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Center(
          child: Text("Invitation"),
        ),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      content: Container(
        padding: EdgeInsets.all(0),
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.65,
              color: Colors.white,
              child: Column(
                children: [
                  Flexible(
                    flex: 2,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SvgPicture.string(
                          svgPicture,
                          width: MediaQuery.of(context).size.width * 0.4,
                        ),
                        SizedBox(width: 8),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Name:",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                            fontFamily: "OpenSans")),
                                    Text(name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "OpenSans")),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Description:",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                            fontFamily: "OpenSans")),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                      child: Text(biography,
                                          style: TextStyle(
                                              fontFamily: "OpenSans")),
                                    ),
                                  ],
                                ),
                                Text(
                                    hereToHelp == true
                                        ? "I am here to help"
                                        : "I am here for help",
                                    style: TextStyle(
                                        fontFamily: "OpenSans",
                                        fontSize: 16,
                                        color: response['heretohelp'] == true
                                            ? Colors.green
                                            : Colors.red)),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.end,
                      spacing: 8,
                      children: [
                        ...topicsList
                            .map(
                              (e) => Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade400,
                                    borderRadius: BorderRadius.circular(20)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                margin: EdgeInsets.only(bottom: 4),
                                child: Text(
                                  e,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "OpenSans",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ),
                            )
                            .toList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Server.sendRequest('Chat/invitationsnooze', payload);
                        Navigator.of(context).pop();
                      },
                      style: ButtonStyle(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black),
                        padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.block),
                          SizedBox(width: 8),
                          Text(
                            'Block',
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
                    child: GestureDetector(
                      onTap: Navigator.of(context).pop,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(0))),
                        child: Text(
                          "Ignore",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Server.sendRequest('Chat/Invitationaccepted', payload);
                        Navigator.of(context).pop();
                        // Navigator.of(context)
                        //     .pushReplacementNamed(ChatScreen.urlName);
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(16))),
                        child: Text(
                          "Accept",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
