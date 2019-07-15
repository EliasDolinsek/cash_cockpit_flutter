import 'package:flutter/material.dart';

class ImageViewPage extends StatelessWidget {
  final ImageProvider image;
  final Function onDelete;

  const ImageViewPage({this.image, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bill image",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              Navigator.pop(context);
              onDelete();
            },
          )
        ],
      ),
      body: Center(
        child: Image(image: image),
      ),
    );
  }
}
