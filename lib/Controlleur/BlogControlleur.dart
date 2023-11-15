import 'dart:convert';
import 'package:blogapp/Model/BlogModel.dart';
import 'package:blogapp/Model/CommentModel.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class BlogController extends GetxController {
  final RxList<BlogPost> posts = <BlogPost>[].obs;
  final Rx<BlogPost> selectedPost = BlogPost(
    userId: 0,
    id: 0,
    title: "",
    body: "",
    comments: [],
  ).obs;
  final RxList<BlogPost> userPosts = <BlogPost>[].obs;
  final RxList<BlogPost> filteredPosts = <BlogPost>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    final postsResponse =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    if (postsResponse.statusCode == 200) {
      final List<dynamic> postData = json.decode(postsResponse.body);
      posts.assignAll(postData.map((json) => BlogPost.fromJson(json)).toList());
      filteredPosts.addAll(posts);
      // Fetch comments for each post
      await fetchCommentsForPosts();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<void> fetchCommentsForPosts() async {
    final commentsResponse = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/comments'));

    if (commentsResponse.statusCode == 200) {
      final List<dynamic> commentData = json.decode(commentsResponse.body);

      // Map comments to posts based on post ID
      final Map<int, List<Comment>> postComments = {};
      commentData.forEach((commentJson) {
        final Comment comment = Comment.fromJson(commentJson);
        final int postId = comment.postId;

        postComments.putIfAbsent(postId, () => []);
        postComments[postId]!.add(comment);
      });

      // Assign comments to respective posts
      posts.forEach((post) {
        final List<Comment>? comments = postComments[post.id];
        post.comments.assignAll(comments ?? []);
      });
    } else {
      throw Exception('Failed to load comments');
    }
  }

  void updateSelectedPost(BlogPost post) {
    selectedPost.value = post;
  }

  void addComment(Comment comment) {
    selectedPost.update((post) {
      post!.comments.add(comment);
    });
  }

  void likePost(BlogPost post) {
    final index = posts.indexWhere((p) => p.id == post.id);
    if (index != -1) {
      if (posts[index].likes == 1) {
        // If nombre of likes = 1,  "dislike"
        posts[index].likes--;
      } else {
        // Else, "like"
        posts[index].likes++;
      }
      update();
    }
  }

  void addNewBlogPost({required String title, required String body}) {
    final newPost = BlogPost(
      userId: 1, // You may use the actual user ID here
      id: posts.length + 1, // Generate a unique ID for the new post
      title: title,
      body: body,
      comments: [],
    );
    // Add the new post to the beginning of the list
    posts.insert(0, newPost);
    filteredPosts.insert(0, newPost);
    // Add the new post to the user-specific list
    userPosts.insert(0, newPost);
    update();
  }

  void DeleteBlog(BlogPost post) {
    posts.remove(post);
    filteredPosts.remove(post);
    userPosts.remove(post);
    update();
  }

  void searchPosts(String searchText) {
    if (searchText.isEmpty) {
      // If searchText is empty, fetch all posts
      filteredPosts.assignAll(posts);
    } else {
      // Filtred postes that has qearchText
      filteredPosts.assignAll(posts.where((post) =>
          post.title.toLowerCase().contains(searchText.toLowerCase())));
    }
    update();
  }
}
