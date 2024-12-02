import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notify/models/channel.dart';
import 'package:notify/pages/chat.dart';
import 'package:notify/services/channels.dart';

class ChannelsPage extends StatefulWidget {
  const ChannelsPage({Key? key}) : super(key: key);

  @override
  _ChannelsPageState createState() => _ChannelsPageState();
}

class _ChannelsPageState extends State<ChannelsPage> {
  final ChannelService service = ChannelService();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? userId;
  List<String> subscribedChannelIds = [];

  @override
  void initState() {
    super.initState();
    _fetchUserId();
  }

  Future<void> _fetchUserId() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final email = user?.email;

      if (email == null) {
        throw Exception("User is not authenticated");
      }

      final querySnapshot = await firestore
          .collection('Users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first;
        setState(() {
          userId = userDoc.id;
          subscribedChannelIds =
          List<String>.from(userDoc.data()['subscribedChannelIds'] ?? []);
        });
      } else {
        throw Exception("No user found with the email $email");
      }
    } catch (error) {
      Get.snackbar(
        "Error",
        "Unable to load user ID: $error",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }

  void _showAddChannelDialog(BuildContext context) {
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _descriptionController = TextEditingController();
    final TextEditingController _subscribersController = TextEditingController();
    String _selectedImage = 'default.jpg';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Add Channel',
                          style: GoogleFonts.raleway(
                            textStyle: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1F71),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          height: 120,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6EFF9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(
                                    'Select Channel Image',
                                    style: GoogleFonts.raleway(
                                      textStyle: const TextStyle(
                                        color: Color(0xFF1A1F71),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        'img.png',
                                        'img1.png',
                                        'img2.png',
                                        'img4.png',
                                        'sky.jepg',
                                      ].map((image) => ListTile(
                                        title: Text(image),
                                        leading: Image.asset(
                                          'assets/images/$image',
                                          width: 40,
                                          height: 40,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              width: 40,
                                              height: 40,
                                              color: const Color(0xFFE6EFF9),
                                              child: const Icon(
                                                Icons.image,
                                                color: Color(0xFF1A1F71),
                                              ),
                                            );
                                          },
                                        ),
                                        onTap: () {
                                          setState(() {
                                            _selectedImage = image;
                                          });
                                          Navigator.pop(context);
                                        },
                                      )).toList(),
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/$_selectedImage',
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.add_photo_alternate,
                                      size: 40,
                                      color: Color(0xFF1A1F71),
                                    );
                                  },
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Select Channel Image',
                                  style: GoogleFonts.raleway(
                                    textStyle: const TextStyle(
                                      color: Color(0xFF1A1F71),
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            labelText: 'Title',
                            labelStyle: TextStyle(color: const Color(0xFF1A1F71).withOpacity(0.7)),
                            filled: true,
                            fillColor: const Color(0xFFE6EFF9),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _descriptionController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: 'Description',
                            labelStyle: TextStyle(color: const Color(0xFF1A1F71).withOpacity(0.7)),
                            filled: true,
                            fillColor: const Color(0xFFE6EFF9),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _subscribersController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Subscribers',
                            labelStyle: TextStyle(color: const Color(0xFF1A1F71).withOpacity(0.7)),
                            filled: true,
                            fillColor: const Color(0xFFE6EFF9),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.raleway(
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF1A1F71),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: () async {
                                if (_titleController.text.trim().isEmpty) {
                                  Get.snackbar(
                                    "Error",
                                    "Please enter a title",
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.redAccent.withOpacity(0.1),
                                    colorText: Colors.red,
                                  );
                                  return;
                                }

                                final newChannel = ChannelModel(
                                  title: _titleController.text.trim(),
                                  description: _descriptionController.text.trim(),
                                  subscribers: int.tryParse(_subscribersController.text.trim()) ?? 0,
                                  imagePath: _selectedImage,
                                );
                                await service.addChannel(newChannel);
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1A1F71),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              ),
                              child: Text(
                                'Add',
                                style: GoogleFonts.raleway(
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildChannelActions(ChannelModel channel, bool isSubscribed) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.spaceBetween,
      children: [
        TextButton.icon(
          onPressed: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(
                  'Delete Channel',
                  style: GoogleFonts.raleway(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1F71),
                    ),
                  ),
                ),
                content: Text(
                  'Are you sure you want to delete "${channel.title}"?',
                  style: GoogleFonts.raleway(),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            );

            if (confirm == true) {
              await service.deleteChannel(channel.id!);
            }
          },
          icon: const Icon(Icons.delete, color: Colors.red),
          label: Text(
            'Delete',
            style: GoogleFonts.raleway(
              textStyle: const TextStyle(color: Colors.red),
            ),
          ),
        ),
        TextButton.icon(
          onPressed: () async {
            if (userId != null) {
              if (isSubscribed) {
                await service.unsubscribeFromChannel(userId!, channel.id!);
                setState(() {
                  subscribedChannelIds.remove(channel.id);
                });
              } else {
                await service.subscribeToChannel(userId!, channel.id!);
                setState(() {
                  subscribedChannelIds.add(channel.id!);
                });
              }
            }
          },
          icon: Icon(
            isSubscribed ? Icons.unsubscribe : Icons.subscriptions,
            color: isSubscribed ? Colors.orange : const Color(0xFF1A1F71),
          ),
          label: Text(
            isSubscribed ? 'Unsubscribe' : 'Subscribe',
            style: GoogleFonts.raleway(
              textStyle: TextStyle(
                color: isSubscribed ? Colors.orange : const Color(0xFF1A1F71),
              ),
            ),
          ),
        ),
        TextButton.icon(
          onPressed: () => Get.to(() => ChatPage(channelId: channel.id!)),
          icon: const Icon(
            Icons.chat,
            color: Color(0xFF1A1F71),
          ),
          label: Text(
            'Chat',
            style: GoogleFonts.raleway(
              textStyle: const TextStyle(
                color: Color(0xFF1A1F71),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChannelItem(ChannelModel channel, bool isSubscribed) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              'assets/images/${channel.imagePath}',
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 120,
                  color: const Color(0xFFE6EFF9),
                  child: Center(
                    child: Icon(
                      Icons.image,
                      size: 48,
                      color: const Color(0xFF1A1F71).withOpacity(0.5),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  channel.title ?? 'No Title',
                  style: GoogleFonts.raleway(
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1F71),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  channel.description ?? 'No Description',
                  style: GoogleFonts.raleway(
                    textStyle: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF1A1F71).withOpacity(0.7),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildChannelActions(channel, isSubscribed),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
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
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
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
                        'Channels',
                        style: GoogleFonts.raleway(
                          textStyle: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1F71),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: userId == null
                      ? const Center(child: CircularProgressIndicator())
                      : StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('Channels').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text(
                            'No channels found.',
                            style: GoogleFonts.raleway(
                              textStyle: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF1A1F71),
                              ),
                            ),
                          ),
                        );
                      }

                      final channels = snapshot.data!.docs.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        return ChannelModel(
                          id: doc.id,
                          title: data['title'],
                          description: data['description'],
                          subscribers: data['subscribers'],
                          imagePath: data['imagePath'] ?? 'default.jpg',
                        );
                      }).toList();

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: channels.length,
                        itemBuilder: (context, index) {
                          final channel = channels[index];
                          final isSubscribed = subscribedChannelIds.contains(channel.id);
                          return _buildChannelItem(channel, isSubscribed);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1A1F71),
        onPressed: () => _showAddChannelDialog(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

