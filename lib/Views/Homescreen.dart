import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:talk_gpt/Controller/HomeController.dart';
import 'package:talk_gpt/Controller/Utils.dart';
import 'package:talk_gpt/Models/messageModel.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatelessWidget {
  var messageController = TextEditingController();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var homeController = Get.put(HomeController());

    sendMessage(val) async {
      await homeController.post(val);

      MessageModel chatgpt = MessageModel(
          sender: "chatgpt",
          text: "${homeController.res}",
          messageid: messageController.text.toString());
      homeController.chat.add(chatgpt.toMap());
    }

    print(homeController.chat);
    homeController.update();

    recordVoice() {}
    return Scaffold(
      backgroundColor: backgroundColor,
      body: GetBuilder<HomeController>(builder: (_) {
        return Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
                child: ListView.builder(
                    reverse: true,
                    itemCount: _.chat.length,
                    itemBuilder: (context, index) {
                      MessageModel currentMessage = MessageModel.fromMap(
                          _.chat[index] as Map<String, dynamic>);

                      return Column(
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              "${currentMessage.messageid}",
                              style:
                                  TextStyle(fontSize: 23, color: Colors.white),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "${currentMessage.text}",
                              style:
                                  TextStyle(fontSize: 23, color: Colors.white),
                            ),
                          ),
                        ],
                      );
                    }),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Row(
                  children: [
                    Flexible(
                      child: TextFormField(
                        controller: messageController,
                        onChanged: (value) {
                          print(value.isNotEmpty);
                          if (value.isEmpty) {
                            _.isMicUser(false);
                          } else if (value.isNotEmpty) {
                            _.isMicUser(true);
                          }
                        },
                        maxLines: null,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Start Speaking or Typing"),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _.isMic == false
                            ? recordVoice()
                            : sendMessage(
                                messageController.text.trim().toString());
                      },
                      icon: Icon(
                        _.isMic == false ? Icons.mic : Icons.send,
                        color: senderMessageColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
