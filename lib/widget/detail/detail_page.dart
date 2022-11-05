import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tourism_todo_recommender/widget/upload/image_item.dart';
import '../../models/todo.dart';
import '../image/image_page.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({Key? key, required this.todo}) : super(key: key);

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        title: const Text('Todo details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                todo.shortDescription,
                style: const TextStyle(
                  fontSize: 50,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                todo.uploaderName,
                style: const TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
              child: Text(
                'Address: ${todo.address}',
                style: const TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
              child: Text(
                'Type: ${todo.nature}',
                style: const TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Description:',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
              child: Text(
                todo.detailedDescription,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Images:',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 8),
            _ImageList(todo: todo,),
          ],
        ),
      ),
    );
  }
}

class _ImageList extends StatelessWidget {
  const _ImageList({Key? key, required this.todo}) : super(key: key);

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    if (todo.imageReferences.isEmpty) {
      return const Center(
        child: Text(
          'No images',
          style: TextStyle(fontSize: 20),
        ),
      );
    }
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        // TODO: try crossAxisSpacing and mainAxisSpacing in practice
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
        crossAxisCount: 2,
      ),
      itemCount: todo.imageReferences.length,
      itemBuilder: (context, index) {
        final imageItem = NetworkImageItem(todo.imageReferences[index]);

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ImagePage(image: imageItem)),
            );
          },
          child: imageItem.createWidget()
        );
      },
    );
  }
}