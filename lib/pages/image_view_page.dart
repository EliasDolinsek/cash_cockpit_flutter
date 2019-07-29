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
          "Image",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Delete this image"),
                  content: Text("Do you really want to delete this image"),
                  actions: <Widget>[
                    MaterialButton(
                      child: Text("CANCEL"),
                      onPressed: () => Navigator.pop(context),
                    ),
                    MaterialButton(
                      child: Text("DELETE"),
                      onPressed: () {
                        Navigator.pop(context);
                        onDelete();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
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
