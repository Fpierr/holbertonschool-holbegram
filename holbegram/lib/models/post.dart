import 'package:cloud_firestore/cloud_firestore.dart';

class Posts {
  final String caption;
  final String uid;
  final String username;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profImage;
  final dynamic likes;

  Posts({
    required this.caption,
    required this.uid,
    required this.username,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        "caption": caption,
        "uid": uid,
        "username": username,
        "postId": postId,
        "datePublished": datePublished,
        "postUrl": postUrl,
        "profImage": profImage,
        "likes": likes,
      };

  static Posts fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Posts(
      caption: snapshot['caption'] ?? '',
      uid: snapshot['uid'] ?? '',
      username: snapshot['username'] ?? '',
      postId: snapshot['postId'] ?? '',
      datePublished: (snapshot['datePublished'] as Timestamp).toDate(),
      postUrl: snapshot['postUrl'] ?? '',
      profImage: snapshot['profImage'] ?? '',
      likes: snapshot['likes'] ?? [],
    );
  }
}
