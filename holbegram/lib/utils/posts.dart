import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:holbegram/providers/user_provider.dart';
import 'package:holbegram/models/user.dart';
import 'package:holbegram/screens/pages/methods/post_storage.dart';

class Posts extends StatefulWidget {
  const Posts({super.key});

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  @override
  Widget build(BuildContext context) {
    final Users? user = Provider.of<UserProvider>(context).getUser;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .orderBy('datePublished', descending: true)
          .snapshots(),
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var data = snapshot.data!.docs[index].data();
            bool isLiked = user != null && data['likes'].contains(user.uid);

            return Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: (data['profImage'] != null &&
                              data['profImage'].isNotEmpty)
                          ? NetworkImage(data['profImage'])
                          : const AssetImage(
                                  'assets/images/Sample_User_Icon.png')
                              as ImageProvider,
                    ),
                    title: Text(data['username'] ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    trailing: user?.uid == data['uid']
                        ? IconButton(
                            icon: const Icon(Icons.more_horiz),
                            onPressed: () => PostStorage()
                                .deletePost(data['postId'], data['postUrl']),
                          )
                        : null,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(data['caption'] ?? ''),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (data['postUrl'] != null && data['postUrl'].isNotEmpty)
                    Image.network(
                      data['postUrl'],
                      height: 350,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 350,
                        color: Colors.grey[200],
                        child: const Icon(Icons.broken_image),
                      ),
                    ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : Colors.black,
                        ),
                        onPressed: () {
                          if (user != null) {
                            PostStorage().likePost(
                                data['postId'], user.uid, data['likes']);
                          }
                        },
                      ),
                      IconButton(
                          icon: const Icon(Icons.chat_bubble_outline),
                          onPressed: () {}),
                      IconButton(
                          icon: const Icon(Icons.send), onPressed: () {}),
                      const Spacer(),
                      IconButton(
                          icon: const Icon(Icons.bookmark_border),
                          onPressed: () {}),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, bottom: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${(data['likes'] as List).length} Liked",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
