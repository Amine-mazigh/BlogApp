import 'package:blogapp/Controlleur/BlogControlleur.dart';
import 'package:blogapp/View/BlogWidget/Bloglist.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateBlogPage extends StatelessWidget {
  final BlogController blogController = Get.find();

  // TextEditingController for capturing input
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Create a New Blog Post',
          ),
          backgroundColor: Color.fromARGB(255, 114, 112, 200),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: titleController,
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (titleController.text == null ||
                        titleController.text.isEmpty) {
                      return 'Requiered field';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      labelText: 'Title *',
                      // This is the normal border
                      border: OutlineInputBorder(),
                      // This is the error border
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 5))),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  // The validator receives the text that the user has entered.
                  controller: bodyController,
                  validator: (value) {
                    if (bodyController.text == null ||
                        bodyController.text.isEmpty) {
                      return 'Requiered field';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      labelText: 'Body *',
                      // This is the normal border
                      border: OutlineInputBorder(),
                      // This is the error border
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 5))),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Color.fromARGB(255, 114, 112, 200))),
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          blogController.addNewBlogPost(
                            title: titleController.text,
                            body: bodyController.text,
                          );
                          Get.to(() => BlogListPage(),
                              transition: Transition.downToUp);
                        }
                      },
                      child: const Text('Create Post'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
