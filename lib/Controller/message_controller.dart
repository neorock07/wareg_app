import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import '../Util/Ip.dart';
import '../services/message_service.dart';

class MessageController extends GetxController {
  var messages = <Map<String, dynamic>>[].obs;
  var conversations = [].obs;
  var isLoading = true.obs;
  var isLoading2 = true.obs;
  final MessageService _messageService = MessageService();
  final ipAdd = Ip();

  // Decode file path if it is a string
  void appendMessage(Map<String, dynamic> message) {
    // Convert isSentByMe from string to boolean
    if (message['isSentByMe'] is String) {
      message['isSentByMe'] = message['isSentByMe'] == 'true';
    }
    if (message['file'] != null) {
      message['file'] = message['file'].replaceFirst(
          'http://localhost:3000', '${ipAdd.getType()}://${ipAdd.getIp()}');
    }

    // Check if the message already exists in the list
    bool isDuplicate = messages
        .any((existingMessage) => existingMessage['id'] == message['id']);

    // If it's not a duplicate, add the message to the list
    if (!isDuplicate) {
      log(message['file']);
      messages.add(Map<String, dynamic>.from(message));
      messages.refresh(); // Ensure UI updates
    }
  }

  Future<void> fetchMessages(int userId) async {
    try {
      isLoading(true);
      var fetchedMessages = await _messageService.fetchMessages(userId);
      log('ini hasilnya tuan $fetchedMessages.toString()');
      if (fetchedMessages != null) {
        messages.value = fetchedMessages;
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> sendMessage(String message, int userId) async {
    await _messageService.sendMessage(message, userId);
  }

  Future<void> sendFile(String filePath, int userId) async {
    await _messageService.sendFile(filePath, userId);
  }

  Future<void> saveFcmToken(String? token) async {
    await _messageService.saveFcmToken(token);
  }
}
