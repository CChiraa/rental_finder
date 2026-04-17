class ChatManager {
  static final List<Map<String, dynamic>> chats = [];

  static Map<String, dynamic> getOrCreateChat(Map property) {
    final existing = chats.firstWhere(
      (chat) => chat['propertyId'] == property['id'],
      orElse: () => {},
    );

    if (existing.isNotEmpty) return existing;

    final newChat = {
      'propertyId': property['id'],
      'landlord': property['postedBy'] ?? 'Landlord',
      'propertyTitle': property['title'],
      'propertyImage': property['image'],
      'messages': [
        {'isMe': false, 'text': 'Hi, this property is available 😊'},
      ],
    };

    chats.add(newChat);
    return newChat;
  }
}
