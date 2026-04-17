class ChatManager {
  static final List<Map<String, dynamic>> chats = [];

  static Map<String, dynamic> getOrCreateChat(Map<String, dynamic> property) {
    final int propertyId = property['id'] ?? 0;

    final existingIndex = chats.indexWhere(
      (chat) => chat['propertyId'] == propertyId,
    );

    if (existingIndex != -1) {
      return chats[existingIndex];
    }

    final newChat = {
      'propertyId': propertyId,
      'landlord': property['postedBy'] ?? 'Landlord',
      'propertyTitle': property['title'] ?? 'Property',
      'propertyImage': property['image'] ?? '',
      'lastMessage': 'Hi, is this property still available?',
      'lastTime': 'Now',
      'messages': [
        {
          'isMe': false,
          'text': 'Hi, thanks for your interest in this property 😊',
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

    final List messages = chat['messages'] as List;
    messages.add({'isMe': true, 'text': trimmed, 'time': 'Now'});

    chat['lastMessage'] = trimmed;
    chat['lastTime'] = 'Now';

    final int index = chats.indexWhere(
      (item) => item['propertyId'] == chat['propertyId'],
    );

    if (index != -1) {
      final updatedChat = chats.removeAt(index);
      chats.insert(0, updatedChat);
    }
  }
}
