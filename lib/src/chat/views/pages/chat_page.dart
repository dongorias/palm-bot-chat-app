import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:palm_app/src/chat/model/data/chat_model.dart';
import 'package:provider/provider.dart';

import '../../controller/chat_controller.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late Stream<List<ChatModel>> chatStream;

  late ChatController chatController;

  @override
  void initState() {
    chatController = Provider.of<ChatController>(context, listen: false);
    chatController.chatRepository.watchAll().listen((event) {});
    chatStream = chatController.chatRepository.watchAll();
    chatController.chatRepository.refresh();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.white,
          centerTitle: true,
          title: const Text(
            "Palm Bot Chat",
            style: TextStyle(
                fontFamily: 'Munitosans',
                fontWeight: FontWeight.w700,
                fontSize: 30),
          ),
        ),
        body: Consumer<ChatController>(builder: (context, p, child) {
          return Column(
            children: [
              Expanded(
                child: StreamBuilder<List<ChatModel>>(
                  stream: chatStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 13.0),
                        child: ListView.builder(
                          reverse: true,
                          physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
                          dragStartBehavior: DragStartBehavior.down,
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          controller: ScrollController(),
                          itemBuilder: (context, i) {
                            ChatModel chat = snapshot.data![i];
                            return chat.isMe
                                ? Align(
                                    alignment: Alignment.topRight,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5,
                                      ).copyWith(right: 20),
                                      child: Container(
                                          decoration: const BoxDecoration(
                                              color: Color(0xFF10A37F),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(30),
                                                bottomLeft: Radius.circular(30),
                                                bottomRight:
                                                    Radius.circular(30),
                                              )),
                                          margin:
                                              const EdgeInsets.only(left: 50),
                                          padding: const EdgeInsets.all(15),
                                          child: Text(
                                            chat.prompt,
                                            style: const TextStyle(
                                                fontFamily: 'Munitosans',
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                                color: Colors.white),
                                          )),
                                    ))
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 5,
                                    ).copyWith(left: 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Stack(
                                          children: [
                                            Container(
                                                decoration: const BoxDecoration(
                                                    color: Color(0xffE3E8F1),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                30))),
                                                margin: const EdgeInsets.only(
                                                  right: 10,
                                                ),
                                                padding: const EdgeInsets.only(
                                                    left: 41,
                                                    top: 12,
                                                    right: 12,
                                                    bottom: 12),
                                                child: Markdown(
                                                  controller: ScrollController(
                                                      keepScrollOffset: false),
                                                  shrinkWrap: true,
                                                  selectable: true,
                                                  data: chat.prompt,
                                                )),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 12.0, left: 12),
                                              child: Image.asset(
                                                  "assets/icons/ic_bot.png"),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                                "assets/icons/ic_like.svg"),
                                            const SizedBox(
                                              width: 16,
                                            ),
                                            SvgPicture.asset(
                                                "assets/icons/ic_unlike.svg"),
                                            const SizedBox(
                                              width: 40,
                                            ),
                                            CopyText(text: chat.prompt,)
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                          },
                          itemCount: snapshot.data!.length,
                          shrinkWrap: true,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              Column(
                children: [
                  p.hasError
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              p.error,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8)
                        .copyWith(bottom: 61),
                    decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFC0C0C0)),
                        color: const Color(0xFFC0C0C0).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextFormField(
                            textInputAction: TextInputAction.send,
                            controller: p.promptController,
                            decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(left: 10, top: 15, right: 10),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                style: BorderStyle.none,
                              )),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(style: BorderStyle.none)),
                            ),
                            maxLines: 5,
                            minLines: 1,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            p.requestPrompt();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.all(8),
                            height: 36,
                            width: 36,
                            color: const Color(0xFF10A37F),
                            child: p.isSeaching
                                ? const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  )
                                : SvgPicture.asset("assets/icons/ic_send.svg"),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          );
        }));
  }
}

class CopyText extends StatelessWidget {
  const CopyText({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: text)).then(
          (_) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Copied to your clipboard !')));
          },
        );
      },
      child: Row(
        children: [
          SvgPicture.asset(
              "assets/icons/ic_copy.svg"),
          const SizedBox(
            width: 12,
          ),
          const Text("Copy"),
        ],
      ),
    );
  }
}
