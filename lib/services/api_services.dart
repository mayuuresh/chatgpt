// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:chatgpt/constant/api_const.dart';
import 'package:chatgpt/models/chat_model.dart';
import 'package:chatgpt/models/models_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List<ModelsModel>> getModels() async {
    try {
      var response = await http.get(Uri.parse("$BaseUrl/models"), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $ApiKey'
      });
      Map jsonresponse = jsonDecode(response.body);
      if (jsonresponse['error'] != null) {
        print("JsonResponse['error']${jsonresponse['error']["message"]}");
        throw HttpException(jsonresponse['error']['message']);
      }

      print(jsonresponse);
      List temp = [];
      for (var i in jsonresponse['data']) {
        temp.add(i);
        print(i['id']);
      }
      print(temp);
      return ModelsModel.modelsFromSnapshot(temp);
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  //send message

  static Future<List<ChatModel>> sendMessage(
      {required String? message, required String? ModelId}) async {
    try {
      var response = await http.post(
        Uri.parse("$BaseUrl/completions"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $ApiKey'
        },
        body: jsonEncode(
          {"model": ModelId, "prompt": message, "max_tokens": 100},
        ),
      );
      Map jsonresponse = jsonDecode(response.body);
      if (jsonresponse['error'] != null) {
        print("JsonResponse['error']${jsonresponse['error']["message"]}");
        throw HttpException(jsonresponse['error']['message']);
      }
      List<ChatModel> chatList = [];
      if (jsonresponse['choices'] != null) {
        print(
            "JsonResponse['choices']text ${jsonresponse['choices'][0]['text']}");
        chatList = List.generate(
          jsonresponse['choices'].length,
            (index) {
            return ChatModel(
              chatIndex: 1,
              msg: jsonresponse['choices'][index]['text'],
            );
            }
        );
      }
      return chatList;
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }
}
