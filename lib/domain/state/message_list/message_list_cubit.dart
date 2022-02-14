import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:everyone_know_app/domain/model/message_list_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

part 'message_list_state.dart';

class MessageListCubit extends Cubit<MessageListState> {
  MessageListCubit() : super(MessageListInitial());

  Future<void> fetch() async {
    try {
      emit(MessageListLoading());

      final result = await _fetchMessages();

      emit(MessageListFetched(messages: result));
    } catch (e) {
      emit(MessageListAlert(message: e.toString()));
    }
  }

  Future<List<MessageListModel>> _fetchMessages() async {
    try {
      const endpoint = 'https://hamitanisin.digital/api/chat/messageslist/';
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      debugPrint(token);

      final result = await http.get(
        Uri.parse(endpoint),
        headers: {
          'Authorization': 'Token $token',
        },
      );

      return List<MessageListModel>.from(json.decode(result.body).map((x) => MessageListModel.fromJson(x)));
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }
}
