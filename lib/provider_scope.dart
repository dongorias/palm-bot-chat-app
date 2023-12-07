import 'package:flutter/material.dart';
import 'package:palm_app/src/chat/controller/chat_controller.dart';
import 'package:provider/provider.dart';

class ProviderScope extends StatelessWidget {
  const ProviderScope({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatController>(create: (_) => ChatController()),
      ],
      child: child,
    );
  }
}
