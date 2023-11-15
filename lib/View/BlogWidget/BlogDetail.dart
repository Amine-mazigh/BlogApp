import 'package:flip_card/flip_card.dart';
import 'package:blogapp/Model/CommentModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controlleur/BlogControlleur.dart';

class BlogDetailPage extends StatelessWidget {
  final BlogController blogController = Get.find();
  final GlobalKey<FlipCardState> flipKey = GlobalKey<FlipCardState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(blogController.selectedPost.value.title)),
        backgroundColor: Color.fromARGB(255, 114, 112, 200),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: FlipCard(
          key: flipKey,
          direction: FlipDirection.HORIZONTAL,
          front: buildFrontCard(),
          back: buildBackCard(),
          speed: 2000,
        ),
      ),
    );
  }

  Widget buildFrontCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          blogController.selectedPost.value.title,
          style: TextStyle(fontSize: 16),
        ),
        Image.network(
          'https://via.placeholder.com/600/eb7e7f',
          fit: BoxFit.cover,
          height: 180,
        ),
        Text(
          'By User :   ${blogController.selectedPost.value.userId}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Obx(
                  () => IconButton(
                    icon: blogController.selectedPost.value.likes > 0
                        ? Icon(Icons.favorite, color: Colors.red)
                        : Icon(Icons.favorite_border),
                    onPressed: () {
                      blogController
                          .likePost(blogController.selectedPost.value);
                    },
                  ),
                ),
                SizedBox(width: 4),
                Obx(() => Text(
                      '${blogController.selectedPost.value.likes} Likes',
                      style: TextStyle(color: Colors.grey[600]),
                    )),
              ],
            ),
            ElevatedButton(
              onPressed: () => _addComment(),
              child: Text('Add a Comment'),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 114, 112, 200),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildBackCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          blogController.selectedPost.value.body,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 16),
        Text(
          'Comments',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Obx(() {
            final comments = blogController.selectedPost.value.comments;
            return ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  color: Colors.grey[100],
                  child: ListTile(
                    title: Text(
                      comment.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          comment.email,
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(comment.body),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  void _addComment() {
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController bodyController = TextEditingController();

    Get.defaultDialog(
      title: 'Add a Comment',
      content: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Name',
            ),
          ),
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: 'Email',
            ),
          ),
          TextField(
            controller: bodyController,
            decoration: InputDecoration(
              labelText: 'Content',
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            blogController.addComment(
              Comment(
                postId: blogController.selectedPost.value.id,
                name: nameController.text,
                email: emailController.text,
                body: bodyController.text,
              ),
            );
            flipKey.currentState!.toggleCard();
            Get.back();
          },
          child: Text('Add'),
          style: ElevatedButton.styleFrom(
            primary: Color.fromARGB(255, 114, 112, 200),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Get.back();
          },
          child: Text('Cancel'),
          style: ElevatedButton.styleFrom(
            primary: Colors.red,
          ),
        ),
      ],
    );
  }
}
