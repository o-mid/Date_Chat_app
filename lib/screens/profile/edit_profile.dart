import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:messageapp/common/style.dart';
import 'package:messageapp/models/user.dart';
import 'package:messageapp/providers/profile_provider.dart';
import 'package:messageapp/screens/profile/components/purpose.dart';
import 'package:messageapp/screens/screens.dart';
import 'package:messageapp/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:messageapp/screens/profile/components/pick_topics.dart';
import 'package:messageapp/utils/list_extensions.dart';

class EditProfile extends StatefulWidget {
  static const urlName = "edit-profile";
  EditProfile({Key? key}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<EditProfile> {
  late User user;
  late ProfileProvider profileProvider;
  String dropdownvalue = "For Help";
  List<String> pickedTopics = ["", "", ""];
  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  //----------------------------------
  void fetchUserData() async {
    user = Provider.of<ProfileProvider>(context, listen: false).user;
    nameController.text = user.username;
    bioController.text = user.biography;
    pickedTopics = user.personalIssues;
  }

  void sendData() {
    user.username = nameController.text;
    user.biography = bioController.text;
    user.personalIssues = pickedTopics;
    user.heretohelp = dropdownvalue == "For Help" ? false : true;
    Provider.of<ProfileProvider>(context, listen: false).updateProfile(user);
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    bioController.dispose();
  }

  //------------------------
  Widget build(BuildContext context) {
    MediaQueryData _mediaQueryData = MediaQuery.of(context);
    double screenHeight = _mediaQueryData.size.height;
    double screenWidth = _mediaQueryData.size.width;
    return WillPopScope(
      onWillPop: () async {
        sendData();
        return true;
      },
      child: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Container(
          decoration: BoxDecoration(
            gradient: kSacffoldBackgroundGradient,
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,

              // actions: [
              //   IconButton(
              //     color: Colors.white,
              //     onPressed: sendData,
              //     icon: Icon(Icons.save),
              //   )
              // ],
            ),
            body: ListView(
              padding: const EdgeInsets.only(bottom: 18, left: 32, right: 32),
              physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    fit: StackFit.loose,
                    children: [
                      ConstrainedBox(
                        constraints:
                            BoxConstraints(maxHeight: screenHeight * 0.2),
                        child: FluttermojiCircleAvatar(
                          radius: screenHeight * 0.11,
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                      // SvgPicture.string(
                      //   FluttermojiFunctions()
                      //       .decodeFluttermojifromString(user.avatar),
                      //   height: screenHeight * 0.2,
                      // ),
                      TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: Size(24, 24),
                          backgroundColor: Colors.white,
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(4),
                        ),
                        child: Icon(
                          Icons.edit,
                          size: 16,
                          color: Colors.blue,
                        ),
                        onPressed: () =>
                            Navigator.of(context).pushNamed(EditAvatar.urlName),
                      )
                    ],
                  ),
                ),
                //-------------------------------------------
                InputFieldWithIconAndHeader(
                  icon: Icon(Icons.record_voice_over, color: Colors.white),
                  header: "Name",
                  hintText: "Enter your name",
                  controller: nameController,
                ),
                //-------------------------------------------
                SizedBox(height: 8),
                //-------------------------------------------
                ExpandedInputFieldWithIconAndHeader(
                    maxLength: 80,
                    icon: Icon(Icons.subject, color: Colors.white),
                    header: "Biography",
                    hintText: "Enter your biography",
                    controller: bioController,
                    obscureText: false),
                //-------------------------------------------
                SizedBox(height: 16),
                Divider(
                  indent: screenWidth * 0.1,
                  endIndent: screenWidth * 0.1,
                  color: Colors.white,
                ),
                //-------------------------------------------
                Purpose(
                  dropdownValue: dropdownvalue,
                  updateValue: (newValue) {
                    setState(() {
                      dropdownvalue = newValue;
                    });
                  },
                ),
                //-------------------------------------------
                SizedBox(height: 8),
                //-------------------------------------------
                PickTopics(pickedTopics, (String topic, int index) {
                  topic.forceInsertAt(pickedTopics, index);
                }),
                // Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
