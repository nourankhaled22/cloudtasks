import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/user.dart';
import '../services/users.dart';

class UsersPage extends StatelessWidget {
  final service = UserService();
  UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(context),
                Expanded(
                  child: _buildUserList(),
                ),
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

  Widget _buildAppBar(BuildContext context) {
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
            'Users',
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

  Widget _buildUserList() {
    return FutureBuilder<List<UserModel>>(
      future: service.getUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: GoogleFonts.raleway(
                textStyle: const TextStyle(
                  color: Color(0xFF1A1F71),
                  fontSize: 16,
                ),
              ),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'No users found.',
              style: GoogleFonts.raleway(
                textStyle: const TextStyle(
                  color: Color(0xFF1A1F71),
                  fontSize: 16,
                ),
              ),
            ),
          );
        }

        final users = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return _buildUserTile(user);
          },
        );
      },
    );
  }

  Widget _buildUserTile(UserModel user) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF1A1F71).withOpacity(0.1),
          child: Text(
            user.username?[0].toUpperCase() ?? '?',
            style: GoogleFonts.raleway(
              textStyle: const TextStyle(
                color: Color(0xFF1A1F71),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: Text(
          user.username ?? 'No Name',
          style: GoogleFonts.raleway(
            textStyle: const TextStyle(
              color: Color(0xFF1A1F71),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        subtitle: Text(
          user.email ?? 'No Email',
          style: GoogleFonts.raleway(
            textStyle: const TextStyle(
              color: Colors.black54,
              fontSize: 12,
            ),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () async {
            // Uncomment when delete logic is implemented
            // await service.deleteUser(user);
            Get.snackbar(
              "Deleted",
              "${user.username} deleted!",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.redAccent.withOpacity(0.1),
              colorText: Colors.red,
            );
          },
        ),
      ),
    );
  }
}
