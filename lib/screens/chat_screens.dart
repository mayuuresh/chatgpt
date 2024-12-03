// ignore_for_file: avoid_print

import 'package:chatgpt/constant/constants.dart';
import 'package:chatgpt/models/chat_model.dart';
import 'package:chatgpt/providers/models_provider.dart';
import 'package:chatgpt/services/api_services.dart';
import 'package:chatgpt/services/assetsManager.dart';
import 'package:chatgpt/services/services.dart';
import 'package:chatgpt/widgets/chat_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _CHatScreenState();
}

class _CHatScreenState extends State<ChatScreen> {
  bool _isTyping = false;
  late TextEditingController textEditingController;
  late ScrollController scrollController;
  late FocusNode focusNode;
  @override
  void initState() {
    textEditingController = TextEditingController();
    scrollController = ScrollController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    scrollController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  List<ChatModel> chatList = [];
  @override
  Widget build(BuildContext context) {
    final modelProvider = Provider.of<ModelsProvider>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          elevation: 2,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(Assetsmanager.openaiLogo),
          ),
          title: const Text("ChatGPT", style: TextStyle(color: Colors.white)),
          actions: [
            IconButton(
                onPressed: () async {
                  await Services.showModelSheet(context: context);
                },
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: Colors.white,
                ))
          ],
        ),
        body: Column(
          children: [
            Flexible(
              child: ListView.builder(
                controller: scrollController,
                itemCount: chatList.length,
                itemBuilder: (context, index) {
                  return ChatWidget(
                    msg: chatMessages[index]['msg'].toString(),
                    chatIndex: chatMessages[index]['chatIndex'] as int,
                  );
                },
              ),
            ),
            if (_isTyping) ...[
              const SpinKitThreeBounce(color: Colors.white, size: 18),
              const SizedBox(
                height: 15,
              )
            ],
            Material(
              color: cardcolor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: focusNode,
                        style: const TextStyle(color: Colors.white),
                        controller: textEditingController,
                        onSubmitted: (value) async {
                          await sendMessageFCT(modelProvider: modelProvider);
                        },
                        decoration: const InputDecoration.collapsed(
                            hintText: 'How can I help you?',
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await sendMessageFCT(modelProvider: modelProvider);
                      },
                      icon: const Icon(Icons.send),
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
void scrollList() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 3),
      curve: Curves.easeOut,
    );
  }
  Future<void> sendMessageFCT({required ModelsProvider modelProvider}) async {
    try {
      setState(() {
        _isTyping = true;
        chatList.add(
          ChatModel(
            chatIndex: 0,
            msg: textEditingController.text,
          ),
        );
        textEditingController.clear();
        focusNode.unfocus();
      });
      print(" request sent");
      chatList.addAll(await ApiService.sendMessage(
        message: textEditingController.text,
        ModelId: modelProvider.getcurrentModel,
      ));
      setState(() {});
    } catch (e) {
      print(e);
    } finally {
      scrollList();
      setState(() {
        _isTyping = false;
      });
    }
  }
}
