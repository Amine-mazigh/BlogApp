/* // This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:blogapp/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget( MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
 */
import 'package:blogapp/Controlleur/BlogControlleur.dart';
import 'package:blogapp/Model/BlogModel.dart';
import 'package:blogapp/Model/CommentModel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BlogController Tests', () {
    late BlogController blogController;

    setUp(() {
      blogController = BlogController();
    });

    test('Initial posts list should be empty', () {
      expect(blogController.posts, isEmpty);
    });

    test('Fetch posts should update posts list', () async {
      await blogController.fetchPosts();
      expect(blogController.posts, isNotEmpty);
    });

    test('Fetch comments for posts should update comments list', () async {
      await blogController.fetchCommentsForPosts();
      expect(blogController.posts.any((post) => post.comments.isNotEmpty), isFalse);
    });

    test('Update selected post should change the selected post', () {
      final initialPost = BlogPost(userId: 1, id: 1, title: 'Test Post', body: 'Test Body', comments: []);
      blogController.updateSelectedPost(initialPost);

      final newPost = BlogPost(userId: 2, id: 2, title: 'New Post', body: 'New Body', comments: []);
      blogController.updateSelectedPost(newPost);

      expect(blogController.selectedPost.value, equals(newPost));
    });

    test('Add comment should update the selected post comments list', () {
      final initialPost = BlogPost(userId: 1, id: 1, title: 'Test Post', body: 'Test Body', comments: []);
      blogController.updateSelectedPost(initialPost);

      final comment = Comment(postId: 1, name: 'Amine', email: 'Amine@example.com', body: 'Great post!');
      blogController.addComment(comment);

      expect(blogController.selectedPost.value.comments, contains(comment));
    });

   test('Like post should update the likes count', () {
  final post = BlogPost(userId: 1, id: 1, title: 'Test Post', body: 'Test Body', comments: []);
  blogController.posts.add(post);

  blogController.likePost(post);

  expect(post.likes.value, equals(1)); 
});

    test('Add new blog post should update posts and userPosts lists', () {
      final initialLength = blogController.posts.length;

      blogController.addNewBlogPost(title: 'New Post', body: 'New Body');

      expect(blogController.posts.length, equals(initialLength + 1));
      expect(blogController.userPosts.length, equals(initialLength + 1));
    });

    test('Delete blog post should update posts and userPosts lists', () {
      final postToDelete = BlogPost(userId: 1, id: 1, title: 'Post to Delete', body: 'Body to Delete', comments: []);
      blogController.posts.add(postToDelete);
      blogController.userPosts.add(postToDelete);

      final initialLength = blogController.posts.length;

      blogController.DeleteBlog(postToDelete);

      expect(blogController.posts.length, equals(initialLength - 1));
      expect(blogController.userPosts.length, equals(initialLength - 1));
    });

    test('Search posts should filter the posts list', () {
      blogController.posts.addAll([
        BlogPost(userId: 1, id: 1, title: 'Post 1', body: 'Body 1', comments: []),
        BlogPost(userId: 1, id: 2, title: 'Post 2', body: 'Body 2', comments: []),
        BlogPost(userId: 1, id: 3, title: 'Post 3', body: 'Body 3', comments: []),
      ]);

      blogController.searchPosts('Post 2');

      expect(blogController.filteredPosts.length, equals(1));
      expect(blogController.filteredPosts.first.title, equals('Post 2'));
    });
  });
}
