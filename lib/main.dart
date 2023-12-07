
import 'package:flutter/material.dart';
import 'package:palm_app/provider_scope.dart';
import 'package:palm_app/src/chat/views/pages/chat_page.dart';

void main() {
  runApp( MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
    ),
    home: const ProviderScope(
      child: ChatPage(),
    ),
  ));
}
