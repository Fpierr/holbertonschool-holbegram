import 'package:flutter/material.dart';
import 'package:holbegram/utils/posts.dart';

class Feed extends StatelessWidget {
  const Feed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text(
              'Holbegram',
              style: TextStyle(fontFamily: 'Billabong', fontSize: 35),
            ),
            const SizedBox(width: 5),
            Image.asset('assets/images/logo.png', height: 30),
          ],
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.add_box_outlined), onPressed: () {}),
          IconButton(
              icon: const Icon(Icons.chat_bubble_outline), onPressed: () {}),
        ],
      ),
      body: const Posts(),
    );
  }
}
