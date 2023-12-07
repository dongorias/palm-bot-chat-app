import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:palm_app/src/chat/model/data/chat_model.dart';

import '../../../config.dart';
import '../../core/models/repositories/repository.dart';
import '../../network/dio/dio_base.dart';
import '../model/repositories/chat_repository.dart';

class ChatController extends ChangeNotifier with WidgetsBindingObserver {
  Repository<ChatModel> chatRepository = ChatRepository();
  BaseDio baseDio = BaseDio.instance;

  final promptController = TextEditingController();
  late String prompt = '';

  List<ChatModel> oldChatList = [];
  late Stream<List<ChatModel>> chatStream;

  String _output = '';
  String get output => _output;

  bool _hasError = false;
  bool get hasError => _hasError;

  String _error = '';
  String get error => _error;

  bool _isSeaching = false;
  bool get isSeaching => _isSeaching;

  setIsSeaching(bool value){
    _isSeaching  = value;
    notifyListeners();
  }

  setHasError({required bool value, required String error}){
    _hasError  = value;
    _error  = error;
    notifyListeners();
  }

  requestPrompt() async {
    if (promptController.text.isNotEmpty || _isSeaching) {
      prompt = promptController.text;
      setHasError(value:false, error: '');
      promptController.clear();
      await chatRepository.create(ChatModel(prompt: prompt,  isMe: true));
      await chatRepository.refresh();
      try{
        setIsSeaching(true);
        var response = await baseDio.post('v1beta3/models/text-bison-001:generateText?key=${Config.palmApiKey}',
            body: {
          "prompt": { "text": prompt},
           "temperature": 1.0,
        });
        promptController.text='';
        if(response.statusCode==200){
          _output = response.data['candidates'][0]['output']??'';
          await chatRepository.create(ChatModel(prompt: _output,  isMe: false,));
          await chatRepository.refresh();
        }
        setIsSeaching(false);
      }on DioException catch (e){
        setIsSeaching(false);
        setHasError(value:true, error: '${e.response?.data['error']['message']}');
      }
    } else {
      return null;
    }
  }


  @override
  void dispose() {
    chatRepository.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
  }
}
