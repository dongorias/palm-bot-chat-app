import 'dart:async';

import '../../../core/models/data_sources/data_source.dart';
import '../../../core/models/repositories/repository.dart';
import '../data/chat_model.dart';
import '../data_sources/chat_local_data_source.dart';

class ChatRepository implements Repository<ChatModel> {

  final _streamController = StreamController<List<ChatModel>>.broadcast(sync: true);
  final DataSource<ChatModel> _local = ChatLocalDataSource();

  @override
  Future<void> create(data) async{
    try {
      await _local.create(data);
      _streamController.add(await _local.readAll());
    } on Exception catch (e) {
    throw Exception(
    'Unable to create chat model  $data, $e');
    }
  }

  @override
  Future<void> delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  Future<ChatModel> read(int id) {
    // TODO: implement read
    throw UnimplementedError();
  }

  @override
  Future<List<ChatModel>> readAll() async {
    try {
      final models = await _local.readAll();
      return models;
    } on Exception catch (e) {
      throw Exception('Unable to read chat model, $e');
    }
  }

  @override
  Future<void> refresh() async{
    try {
      _streamController.add(await _local.readAll());
    } on Exception catch (e) {
    throw Exception('Unable to refresh chat, $e');
    }
  }

  @override
  Future<void> update(data) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Stream<ChatModel> watch(int id) {
    // TODO: implement watch
    throw UnimplementedError();
  }

  @override
  Stream<List<ChatModel>> watchAll() {
    return _streamController.stream;
  }

}