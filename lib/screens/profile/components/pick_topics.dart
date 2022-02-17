import 'package:flutter/material.dart';
import 'package:messageapp/data/topics.dart';
import 'package:messageapp/screens/profile/widgets/topic_button.dart';

class PickTopics extends StatefulWidget {
  final List<String>? pickedTopics;
  final Function updateTopics;
  PickTopics(this.pickedTopics, this.updateTopics);

  @override
  _PickTopicsState createState() => _PickTopicsState();
}

class _PickTopicsState extends State<PickTopics> {
  late List<String> _topics;
  late List<String>? _pickedTopics;
  @override
  void initState() {
    super.initState();
    _topics = topics;
    _pickedTopics = this.widget.pickedTopics ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "My Main 3 topics are:",
            style: TextStyle(
              fontSize: 16,
              fontFamily: "OpenSans",
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 4),
        ...buildTopicsButtons()
        // ElevatedButton(
        //   onPressed: () => showPickTopic(0),
        //   style: ElevatedButton.styleFrom(
        //     fixedSize: Size(screenWidth, 40),
        //     elevation: 0.5,
        //     primary: Theme.of(context).primaryColor.withOpacity(0.4),
        //     shape:
        //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        //   ),
        //   child: Text(_pickedTopics[0] == null
        //       ? "Pick the first topic"
        //       : _pickedTopics[0]),
        // ),
        // ElevatedButton(
        //   onPressed: () => showPickTopic(1),
        //   style: ElevatedButton.styleFrom(
        //     fixedSize: Size(screenWidth, 40),
        //     elevation: 0.5,
        //     primary: Theme.of(context).primaryColor.withOpacity(0.4),
        //     shape:
        //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        //   ),
        //   child: Text(_pickedTopics[1] == null
        //       ? "Pick the second topic"
        //       : _pickedTopics[1]),
        // ),
        // ElevatedButton(
        //     onPressed: () => showPickTopic(2),
        //     style: ElevatedButton.styleFrom(
        //       fixedSize: Size(screenWidth, 40),
        //       elevation: 0.5,
        //       primary: Theme.of(context).primaryColor.withOpacity(0.4),
        //       shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(8)),
        //     ),
        //     child: Text(_pickedTopics[2] == null
        //         ? "Pick the third topic"
        //         : _pickedTopics[2]))
      ],
    );
  }

  Future<String?> showPickTopic(index) async {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titlePadding: EdgeInsets.all(0),
        title: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: Colors.white,
            ),
            child: Text("Topics", style: TextStyle(fontFamily: "OpenSans"))),
        contentPadding: EdgeInsets.all(0),
        content: Container(
          height: screenHeight * 0.7,
          width: screenWidth * 0.8,
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20)),
            color: Colors.white,
          ),
          child: ListView.builder(
              itemCount: _topics.length,
              // shrinkWrap: true,
              itemBuilder: (context, topicIndex) {
                if (_pickedTopics!.contains(_topics[topicIndex]))
                  return SizedBox();
                else
                  return Container(
                    child: ElevatedButton(
                      onPressed: () {
                        // Update Current Widget
                        String pickedTopic = _topics[topicIndex];
                        // Update Parent Widget
                        this.widget.updateTopics(pickedTopic, index);
                        setState(() {
                          try {
                            _pickedTopics![index] = pickedTopic;
                          } catch (e) {
                            _pickedTopics!.add(pickedTopic);
                          }
                        });
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        _topics[topicIndex],
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: "OpenSans"),
                      ),
                    ),
                  );
              }),
        ),
      ),
    );
  }

  List<Widget> buildTopicsButtons() {
    List<Widget> pickTopicButtons = [];
    for (int i = 0; i <= 2; i++) {
      try {
        pickTopicButtons.add(PickATopicBtn(
          showPickTopic,
          i,
          title: _pickedTopics![i],
        ));
      } catch (_) {
        pickTopicButtons.add(PickATopicBtn(
          showPickTopic,
          i,
        ));
      }
    }
    return pickTopicButtons;
  }
}
