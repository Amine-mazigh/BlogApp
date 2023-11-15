import 'package:blogapp/Model/BlogModel.dart';
import 'package:blogapp/Model/CommentModel.dart';
import 'package:blogapp/View/BlogWidget/CreateBlogPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controlleur/BlogControlleur.dart';
import 'BlogDetail.dart';
import '../ProfileWidget/ProfileUser.dart';

class BlogListPage extends StatefulWidget {
  @override
  _BlogListPageState createState() => _BlogListPageState();
}

class _BlogListPageState extends State<BlogListPage> {
  final BlogController blogController = Get.put(BlogController());
  final TextEditingController searchController = TextEditingController();
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Blog App"),
        backgroundColor: Color.fromARGB(255, 114, 112, 200),
        automaticallyImplyLeading: false,
        actions: [
          if (_currentIndex == 0) // Only show search bar if in the BlogListPage
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    // Implement search functionality on text change
                    blogController.searchPosts(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          if (_currentIndex ==
              0) // Only show search button if in the BlogListPage
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Implement search functionality
                blogController.searchPosts(searchController.text);
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _currentIndex == 0
                ? Obx(
                    () => ListView.builder(
                      itemCount: blogController.filteredPosts.length,
                      itemBuilder: (context, index) {
                        final post = blogController.filteredPosts[index];
                        return BlogTile(
                            post: post, blogController: blogController);
                      },
                    ),
                  )
                : UserProfilePage(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Call the function to create a new post
          Get.to(() => CreateBlogPage(), transition: Transition.downToUp);
        },
        child: Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 114, 112, 200),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          // Update the current index when a bottom navigation item is clicked
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class BlogTile extends StatelessWidget {
  final BlogPost post;
  final BlogController blogController;

  const BlogTile({required this.post, required this.blogController});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  // this  the user's profile picture
                  child: Image.asset('assets/user.jpg'),
                  backgroundColor: Colors.grey,
                  radius: 20,
                ),
                Text(
                  'User ${post.userId}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outlined),
                  onPressed: () => _DeleteBlog(context),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              blogController.updateSelectedPost(post);
              Get.to(() => BlogDetailPage(), transition: Transition.downToUp);
            },
            child: Image.network(
              // the URL of the post's image
              'https://via.placeholder.com/600/eb7e7f',
              fit: BoxFit.cover,
              height: 200,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Obx(
                      () => IconButton(
                        icon: post.likes > 0
                            ? Icon(Icons.favorite, color: Colors.red)
                            : Icon(Icons.favorite_border),
                        onPressed: () {
                          blogController.likePost(post);
                        },
                      ),
                    ),
                    SizedBox(width: 4),
                    Obx(() => Text('${post.likes} Likes')),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.comment),
                  onPressed: () {
                    // comment functionality 
                    _addComment(context);
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _DeleteBlog(BuildContext context) {
    // Show a dialog to Alert delete
    Get.defaultDialog(
      title: 'Alert ',
      content: Column(
        children: [],
      ),
      actions: [
        ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red)),
          onPressed: () {
            // Delete the selected post
            blogController.DeleteBlog(post);
            Get.back();
          },
          child: Text('Delete'),
        ),
        ElevatedButton(
          onPressed: () {
            Get.back();
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }

  void _addComment(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController bodyController = TextEditingController();

    // Show a dialog to add comments
    Get.defaultDialog(
      title: 'Ajouter un commentaire',
      content: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Nom'),
          ),
          TextField(
            controller: emailController,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: bodyController,
            decoration: InputDecoration(labelText: 'Contenu'),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            // Add the comment to the selected post
            blogController.addComment(
              Comment(
                postId: blogController.selectedPost.value.id,
                name: nameController.text,
                email: emailController.text,
                body: bodyController.text,
              ),
            );
            Get.back();
          },
          child: Text('Ajouter'),
        ),
        ElevatedButton(
          onPressed: () {
            Get.back();
          },
          child: Text('Annuler'),
        ),
      ],
    );
  }
}
