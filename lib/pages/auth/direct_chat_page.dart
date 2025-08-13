// ------------------- direct_chat_page.dart -------------------
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatapp_firebase/service/direct_chat_service.dart';

class DirectChatPage extends StatefulWidget {
  final String chatId;
  final String peerId;
  final String userId;

  const DirectChatPage({
    Key? key,
    required this.chatId,
    required this.peerId,
    required this.userId,
  }) : super(key: key);

  @override
  State<DirectChatPage> createState() => _DirectChatPageState();
}

class _DirectChatPageState extends State<DirectChatPage> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late DirectChatService directChatService;

  String displayName = "";
  String displayAvatar = "";
  bool isLoadingPeer = true;

  @override
  void initState() {
    super.initState();
    directChatService = DirectChatService(userId: widget.userId);

    // Fetch peer info
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.peerId)
        .get()
        .then((doc) {
      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          displayName = data['fullName'] ?? "Unknown";
          displayAvatar = data['profilePic'] ?? "";
          isLoadingPeer = false;
        });
      } else {
        setState(() {
          displayName = "Unknown";
          displayAvatar = "";
          isLoadingPeer = false;
        });
      }
    });

    // Mark last message as seen
    directChatService.markLastMessageSeen(widget.chatId);
  }

  void sendMessage() async {
    final msg = messageController.text.trim();
    if (msg.isNotEmpty) {
      await directChatService.sendMessage(
        chatId: widget.chatId,
        senderId: widget.userId,
        message: msg,
      );
      messageController.clear();
      directChatService.markLastMessageSeen(widget.chatId);

      // Scroll to bottom
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final messageText = data['message'] ?? '';
    bool isMe = data['senderId'] == widget.userId;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(10),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue[300] : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          messageText,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isLoadingPeer
            ? const Text("Loading...")
            : Row(
                children: [
                  CircleAvatar(
                    backgroundImage: displayAvatar.isNotEmpty
                        ? NetworkImage(displayAvatar)
                        : null,
                    child: displayAvatar.isEmpty && displayName.isNotEmpty
                        ? Text(displayName[0].toUpperCase())
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Text(displayName),
                ],
              ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: directChatService.getMessages(widget.chatId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final msgDocs = snapshot.data!.docs;
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    reverse: true, // newest messages at bottom
                    itemCount: msgDocs.length,
                    itemBuilder: (context, index) {
                      return _buildMessageItem(msgDocs[index]);
                    },
                  );
                }
                if (snapshot.hasError) {
                  return const Center(child: Text("Error fetching messages"));
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: InputBorder.none,
                    ),
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: sendMessage,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
