class ChatManager {
  static final List<Map<String, dynamic>> chats = [];

  static Map<String, dynamic> getOrCreateChat(Map<String, dynamic> property) {
    final int propertyId = property['id'] ?? 0;

    final existingIndex = chats.indexWhere(
      (chat) => chat['propertyId'] == propertyId,
    );

    if (existingIndex != -1) {
      final existingChat = chats.removeAt(existingIndex);
      chats.insert(0, existingChat);
      return existingChat;
    }

    final newChat = {
      'propertyId': propertyId,
      'landlord': property['postedBy'] ?? 'Landlord',
      'propertyTitle': property['title'] ?? 'Property',
      'propertyImage': property['image'] ?? '',
      'lastMessage': 'Hi, thanks for your interest in this property 😊',
      'lastTime': '10:00 AM',
      'messages': [
        {
          'isMe': false,
          'text': 'Hi, thanks for your interest in this property 😊',
          'imagePath': null,
          'time': '10:00 AM',
        },
      ],
    };

    chats.insert(0, newChat);
    return newChat;
  }

  static void sendMessage(Map<String, dynamic> chat, String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final List<Map<String, dynamic>> messages = List<Map<String, dynamic>>.from(
      chat['messages'] ?? [],
    );

    messages.add({
      'isMe': true,
      'text': trimmed,
      'imagePath': null,
      'time': _getCurrentTime(),
    });

    chat['messages'] = messages;
    chat['lastMessage'] = trimmed;
    chat['lastTime'] = _getCurrentTime();

    _moveChatToTop(chat);
  }

  static void sendImageMessage(Map<String, dynamic> chat, String imagePath) {
    if (imagePath.trim().isEmpty) return;

    final List<Map<String, dynamic>> messages = List<Map<String, dynamic>>.from(
      chat['messages'] ?? [],
    );

    messages.add({
      'isMe': true,
      'text': '',
      'imagePath': imagePath,
      'time': _getCurrentTime(),
    });

    chat['messages'] = messages;
    chat['lastMessage'] = '📷 Photo';
    chat['lastTime'] = _getCurrentTime();

    _moveChatToTop(chat);
  }

  static void sendAutoReply(Map<String, dynamic> chat, String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final List<Map<String, dynamic>> messages = List<Map<String, dynamic>>.from(
      chat['messages'] ?? [],
    );

    messages.add({
      'isMe': false,
      'text': trimmed,
      'imagePath': null,
      'time': _getCurrentTime(),
    });

    chat['messages'] = messages;
    chat['lastMessage'] = trimmed;
    chat['lastTime'] = _getCurrentTime();

    _moveChatToTop(chat);
  }

  static void _moveChatToTop(Map<String, dynamic> chat) {
    final int index = chats.indexWhere(
      (item) => item['propertyId'] == chat['propertyId'],
    );

    if (index != -1) {
      final updatedChat = chats.removeAt(index);
      chats.insert(0, updatedChat);
    }
  }

  static String _getCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour > 12
        ? now.hour - 12
        : now.hour == 0
        ? 12
        : now.hour;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}
