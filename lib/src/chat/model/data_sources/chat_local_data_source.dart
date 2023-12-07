import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/models/data_sources/data_source.dart';
import '../data/chat_model.dart';

class ChatLocalDataSource implements DataSource<ChatModel> {
  static const _chatKey = '_chatKey';

  @override
  Future<void> create(ChatModel data) async {
    await readAll().then((value) async => {
          value.add(ChatModel(prompt: data.prompt, isMe: data.isMe, index: value.length + 1)),
          await createAll(value),
        });
  }

  @override
  Future<void> createAll(List<ChatModel> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonObj = data.map((p) => p.toJson()).toList();
      final jsonStr = json.encode(jsonObj);
      await prefs.setString(_chatKey, jsonStr);
    } on Exception catch (e) {
      debugPrint('Failed to encode json, ${e.toString()}');
      throw Exception('Failed to encode json, ${e.toString()}');
    }
  }

  @override
  Future<void> delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<ChatModel?> read(int id) {
    // TODO: implement read
    throw UnimplementedError();
  }

  @override
  Future<List<ChatModel>> readAll() async {
    final prefs = await SharedPreferences.getInstance();
    //prefs.clear();
    final jsonStr = prefs.getString(_chatKey) ?? '[]';
    try {
      final jsonObj = json.decode(jsonStr) as List<dynamic>;
      final decoded = jsonObj.map((j) => ChatModel.fromJson(j)).toList();
      decoded.sort((a, b) => a.index!.compareTo(b.index!));
      return decoded.reversed.toList();
    } on Exception catch (e) {
      debugPrint('Failed to decode json, ${e.toString()}');
      throw Exception('Failed to decode json, ${e.toString()}');
    }
  }

  @override
  Future<void> update(ChatModel data) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
