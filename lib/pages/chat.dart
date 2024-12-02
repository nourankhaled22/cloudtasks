import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:notify/models/message.dart';
import 'package:notify/services/chat.dart';

class ChatPage extends StatefulWidget {
  final String channelId;

  const ChatPage({Key? key, required this.channelId}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final MessageService _messageService = MessageService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ScrollController _scrollController = ScrollController();
  String? _channelTitle;

  @override
  void initState() {
    super.initState();
    _fetchChannelTitle();
  }

  Future<void> _fetchChannelTitle() async {
    try {
      final querySnapshot = await _firestore
          .collection('Channels')
          .where('id', isEqualTo: widget.channelId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final channelData = querySnapshot.docs.first.data();
        setState(() {
          _channelTitle = channelData['title'];
        });
      }
    } catch (e) {
      debugPrint("Error fetching channel title: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(child: _buildMessageList()),
                _buildMessageInput(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFE6EFF9),
            Color(0xFFAFD6FF),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE6EFF9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Color(0xFF1A1F71),
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            _channelTitle ?? 'Chat',
            style: GoogleFonts.raleway(
              textStyle: const TextStyle(
                color: Color(0xFF1A1F71),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder<List<MessageModel>>(
      stream: _messageService.getMessagesStreamByChannelId(widget.channelId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final messages = snapshot.data ?? [];
        if (messages.isEmpty) {
          return Center(
            child: Text(
              'No messages yet.',
              style: GoogleFonts.raleway(
                textStyle: const TextStyle(
                  color: Color(0xFF1A1F71),
                  fontSize: 16,
                ),
              ),
            ),
          );
        }

        return ListView.builder(
          controller: _scrollController,
          reverse: true,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            return _buildMessageBubble(messages[index]);
          },
        );
      },
    );
  }

  Widget _buildMessageBubble(MessageModel message) {
    final isCurrentUser = message.userId == FirebaseAuth.instance.currentUser?.uid;
    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isCurrentUser ? const Color(0xFF1A1F71) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isCurrentUser)
              Text(
                message.username ?? 'Unknown User',
                style: GoogleFonts.raleway(
                  textStyle: TextStyle(
                    color: isCurrentUser ? Colors.white70 : const Color(0xFF1A1F71),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            Text(
              message.text ?? "",
              style: GoogleFonts.raleway(
                textStyle: TextStyle(
                  color: isCurrentUser ? Colors.white : const Color(0xFF1A1F71),
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              DateFormat('HH:mm').format(message.dateTime),
              style: GoogleFonts.raleway(
                textStyle: TextStyle(
                  color: isCurrentUser ? Colors.white70 : Colors.black54,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: GoogleFonts.raleway(
                  textStyle: TextStyle(
                    color: const Color(0xFF1A1F71).withOpacity(0.5),
                    fontSize: 14,
                  ),
                ),
                filled: true,
                fillColor: const Color(0xFFE6EFF9),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(20),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1F71),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.send,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final querySnapshot = await _firestore
            .collection('Users')
            .where('email', isEqualTo: user.email)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final userDoc = querySnapshot.docs.first.data();
          final message = MessageModel(
            username: userDoc['username'],
            userId: user.uid,
            userEmail: user.email,
            text: _messageController.text.trim(),
            dateTime: DateTime.now(),
          );

          await _messageService.addMessage(widget.channelId, message);
          _messageController.clear();
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      } catch (e) {
        debugPrint("Error sending message: $e");
        _showErrorSnackBar("Failed to send message.");
      }
    } else {
      _showErrorSnackBar("User not authenticated.");
    }
  }

  void _showErrorSnackBar(String message) {
    Get.snackbar(
      "Error",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent.withOpacity(0.8),
      colorText: Colors.white,
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
