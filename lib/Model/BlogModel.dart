import 'package:blogapp/Model/CommentModel.dart';
import 'package:get/get.dart';

class BlogPost {
  final int userId;
  final int id;
  final String title;
  final String body;
  final List<Comment> comments;
  RxInt likes = RxInt(0);
  // New property for likes

  BlogPost({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
    required this.comments,
    // Default likes to 0
  });

  factory BlogPost.fromJson(Map<String, dynamic> json) {
    return BlogPost(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
      comments: [],
      // Default likes to 0
    );
  }
}