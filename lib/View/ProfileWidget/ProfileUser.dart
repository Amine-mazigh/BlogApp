import 'package:blogapp/Controlleur/BlogControlleur.dart';
import 'package:blogapp/Model/BlogModel.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserProfilePage extends StatelessWidget {
  final BlogController blogController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Section of profil image
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
                'https://cdn-icons-png.flaticon.com/512/219/219984.png'),
          ),
          SizedBox(height: 16),
          // Section of user stat
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStat('Posts', blogController.userPosts.length.toString()),
              _buildStat('Followers', '100K'),
              _buildStat('Following', '500'),
            ],
          ),
          SizedBox(height: 16),

          SizedBox(height: 16),
          // Section of user posts
          Obx(
            () => Expanded(
              child: ListView.builder(
                itemCount: blogController.userPosts.length,
                itemBuilder: (context, index) {
                  final post = blogController.userPosts[index];
                  return _buildPostTile(post, context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Text(label),
      ],
    );
  }

  Widget _buildPostTile(BlogPost post, BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: FlipCard(
        // Wrap your content with FlipCard widget
        direction:
            FlipDirection.HORIZONTAL, // You can change the direction as needed
        flipOnTouch: true,
        front: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              'https://vivoka.com/app/uploads/2021/02/VIVOKA_NOIR.png',
              fit: BoxFit.cover,
              height: 200,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                post.title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        back: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            post.body,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
