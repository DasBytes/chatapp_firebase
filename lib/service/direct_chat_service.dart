import 'package:cloud_firestore/cloud_firestore.dart';

class DirectChatService {
  final String userId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DirectChatService({required this.userId});

  String getChatId(String userA, String userB) {
    var ids = [userA, userB];
    ids.sort();
    return ids.join('_');
  }

  Future<String> createOrGetDirectChat(String peerId) async {
    final chatId = getChatId(userId, peerId);
    final chatDoc =
        await _firestore.collection('directChats').doc(chatId).get();

    if (!chatDoc.exists) {
      await _firestore.collection('directChats').doc(chatId).set({
        'users': [userId, peerId],
        'createdAt': FieldValue.serverTimestamp(),
        'lastMessage': '',
        'lastMessageSentAt': FieldValue.serverTimestamp(),
        'seenBy': [userId],
      });
    }
    return chatId;
  }

  Stream<QuerySnapshot> getDirectChats() {
    try {
      return _firestore
          .collection('directChats')
          .where('users', arrayContains: userId)
          .orderBy('lastMessageSentAt', descending: true)
          .snapshots();
    } on FirebaseException catch (e) {
      if (e.code == 'failed-precondition' && e.message!.contains('index')) {
        // Print Firestore index creation link for debugging
        print('🔥 Firestore requires an index for this query.');
        print('ℹ️ Check console logs for the direct link to create it.');
      }
      // Fallback: no ordering if index missing
      return _firestore
          .collection('directChats')
          .where('users', arrayContains: userId)
          .snapshots();
    }
  }

  Stream<QuerySnapshot> getMessages(String chatId) {
    return _firestore
        .collection('directChats')
        .doc(chatId)
        .collection('messages')
        .orderBy('sentAt', descending: false)
        .snapshots();
  }

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String message,
  }) async {
    final messageDoc = _firestore
        .collection('directChats')
        .doc(chatId)
        .collection('messages')
        .doc();

    await messageDoc.set({
      'senderId': senderId,
      'message': message,
      'sentAt': FieldValue.serverTimestamp(),
    });

    await _firestore.collection('directChats').doc(chatId).update({
      'lastMessage': message,
      'lastMessageSentAt': FieldValue.serverTimestamp(),
      'seenBy': [senderId], // reset read receipt to only sender
    });
  }

  Future<void> markLastMessageSeen(String chatId) async {
    final chatRef = _firestore.collection('directChats').doc(chatId);
    final chatSnap = await chatRef.get();

    if (!chatSnap.exists) return;

    List seenBy = chatSnap.data()?['seenBy'] ?? [];

    if (!seenBy.contains(userId)) {
      seenBy.add(userId);
      await chatRef.update({'seenBy': seenBy});
    }
  }
}
