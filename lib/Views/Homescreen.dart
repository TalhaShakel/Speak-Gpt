import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talk_gpt/Controller/HomeController.dart';
import 'package:talk_gpt/Controller/Utils.dart';
import 'package:talk_gpt/Models/messageModel.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  var _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    var homeController = Get.put(HomeController());

    sendMessage(val) async {
      await homeController.post(val);

      MessageModel chatgpt = MessageModel(
          sender: "chatgpt",
          text: "${homeController.res}",
          messageid: homeController.messageController.text.toString());
      homeController.chat.add(chatgpt.toMap());
    }

    print(homeController.chat);
    homeController.update();

    recordVoice() {}
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: chatgptcolor,
        leading: Padding(
          padding: const EdgeInsets.all(3.5),
          child: CircleAvatar(
            backgroundColor: senderMessageColor,
            child: Image.asset(
              "assets/Icon/chatgpticon.png",
              scale: 9,
              color: iconcolor,
            ),
          ),
        ),
        title: Text(
          "Speech to Gpt".toUpperCase(),
          style: TextStyle(color: titlecolor),
        ),
      ),
      body: GetBuilder<HomeController>(builder: (_) {
        return Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    controller: _scrollController,
                    // reverse: true,
                    shrinkWrap: true,
                    itemCount: _.chat.length,
                    itemBuilder: (context, index) {
                      MessageModel currentMessage = MessageModel.fromMap(
                          _.chat[index] as Map<String, dynamic>);

                      return Column(
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 38.0),
                              child: Card(
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "${currentMessage.messageid}",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 38.0),
                              child: Card(
                                elevation: 1,
                                color: chatgptcolor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  child: Text(
                                    "${currentMessage.text.toString().trim()}",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
              ),
            ),
            Container(
              child: Row(
                children: [
                  Flexible(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Container(
                        color: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: Row(
                          children: [
                            Flexible(
                              child: TextFormField(
                                controller: _.messageController,
                                onChanged: (value) {
                                  print(!value.isNotEmpty);
                                  // if (value == "") {
                                  //   _.isMic = false;
                                  //   _.update();
                                  // }
                                  // else
                                  // if (value.isNotEmpty) {
                                  //   _.isMic = true;
                                  //   _.update();
                                  // }
                                },
                                maxLines: null,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText:
                                        "Hold mic and Start Speaking or \nTyping..."),
                              ),
                            ),
                            // GestureDetector(
                            // onTapDown: (details) {
                            //   _.startRec();
                            // },
                            // onTapUp: (details) {
                            //   _.stopRec();
                            // },
                            //   child: Icon(
                            //     _.isMic ? Icons.mic : Icons.mic_none,
                            //     color: senderMessageColor,
                            //   ),
                            // ),

                            GestureDetector(
                              onTap: () {
                                sendMessage(_.messageController.text)
                                    .whenComplete(() {
                                  _scrollController.jumpTo(_scrollController
                                      .position.maxScrollExtent);
                                });
                              },
                              child: Icon(
                                Icons.send,
                                color: senderMessageColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 8,
                      right: 2,
                      left: 2,
                    ),
                    child: CircleAvatar(
                      backgroundColor: chatgptcolor,
                      radius: 25,
                      child: GestureDetector(
                        onTapDown: (details) {
                          _.startRec();
                        },
                        onTapUp: (details) {
                          _.stopRec();
                        },
                        child: Icon(
                          _.isMic ? Icons.mic : Icons.mic_none,
                          color: senderMessageColor,
                        ),
                        // onTap: sendTextMessage,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
