import 'package:flutter/material.dart';



class Post extends StatefulWidget{

const Post ({super.key});

@override
  State<Post> createState() => PostState();

}


class PostState extends State<Post> {
  final List<String> _posts = [];

  void _addPost() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController controller = TextEditingController();
        return AlertDialog(
          title: const Text('Add a Post'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter your post...'),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  setState(() {
                    _posts.insert(0, controller.text.trim());
                  });
                }
                Navigator.of(context).pop();
              },
              child: const Text('Post'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _posts.isEmpty
          ? const Center(child: Text('No posts yet. Tap + to add one!'))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(_posts[index]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPost,
        backgroundColor: Colors.pinkAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
