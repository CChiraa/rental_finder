import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String generateChatId({
    required String tenantId,
    required String landlordId,
    required String propertyId,
  }) {
    return '${tenantId}_${landlordId}_$propertyId';
  }

  Future<String> createOrGetChat({
    required String tenantId,
    required String tenantName,
    required String landlordId,
    required String landlordName,
    required String propertyId,
    required String propertyTitle,
    String propertyImage = '',
  }) async {
    final chatId = generateChatId(
      tenantId: tenantId,
      landlordId: landlordId,
      propertyId: propertyId,
    );

    final chatRef = _firestore.collection('chats').doc(chatId);
    final chatDoc = await chatRef.get();

    if (!chatDoc.exists) {
      await chatRef.set({
        'chatId': chatId,
        'tenantId': tenantId,
        'tenantName': tenantName,
        'landlordId': landlordId,
        'landlordName': landlordName,
        'propertyId': propertyId,
        'propertyTitle': propertyTitle,
        'propertyImage': propertyImage,
        'lastMessage': 'Chat started',
        'lastSenderId': tenantId,
        'updatedAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      await sendMessage(
        chatId: chatId,
        senderId: landlordId,
        senderName: landlordName,
        text: 'Hi, thanks for your interest in this property 😊',
      );
    }

    return chatId;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getTenantChats(String tenantId) {
    return _firestore
        .collection('chats')
        .where('tenantId', isEqualTo: tenantId)
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getLandlordChats(
    String landlordId,
  ) {
    return _firestore
        .collection('chats')
        .where('landlordId', isEqualTo: landlordId)
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt')
        .snapshots();
  }

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String senderName,
    required String text,
    String imageUrl = '',
  }) async {
    final messageText = text.trim();

    if (messageText.isEmpty && imageUrl.isEmpty) return;

    final chatRef = _firestore.collection('chats').doc(chatId);

    await chatRef.collection('messages').add({
      'senderId': senderId,
      'senderName': senderName,
      'text': messageText,
      'imageUrl': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await chatRef.update({
      'lastMessage': imageUrl.isNotEmpty ? '📷 Photo' : messageText,
      'lastSenderId': senderId,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
