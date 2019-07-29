import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';

import '../pages/image_view_page.dart';
import '../core/bill.dart';
import '../data/data_manager.dart' as dataManager;

class ImagesList extends StatefulWidget {
  final Bill bill;

  const ImagesList(this.bill);

  @override
  _ImagesListState createState() => _ImagesListState();
}

class _ImagesListState extends State<ImagesList> {
  bool _uploading = false;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: widget.bill.imageURLs.length + 1,
      separatorBuilder: (context, index) => SizedBox(width: 8.0),
      itemBuilder: (context, index) {
        if (index == widget.bill.imageURLs.length) {
          return _buildContainer(_buildUploadingWidget());
        } else {
          return _buildImageWidget(widget.bill.imageURLs.elementAt(index));
        }
      },
    );
  }

  void _showImageSourceSelection(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Image source"),
        content: Text(
            "Do you want to choose a file from your gallery or shoot a new one?"),
        actions: <Widget>[
          MaterialButton(
            child: Text("GALLERY"),
            onPressed: () {
              Navigator.of(context).pop(ImageSource.gallery);
            },
          ),
          MaterialButton(
            child: Text("CAMERA"),
            onPressed: () {
              Navigator.of(context).pop(ImageSource.camera);
            },
          )
        ],
      ),
    ).then((value) async {
      if (value != null && value is ImageSource) addImage(value, context);
    });
  }

  void addImage(imageSource, BuildContext context) async {
    final image = await ImagePicker.pickImage(source: imageSource);
    setState(() => _uploading = true);
    dataManager.uploadFileRandomNamed(image, (downloadURL) {
      setState(() {
        widget.bill.imageURLs.add(downloadURL);
        _uploading = false;
      });
    });
  }

  Widget _buildUploadingWidget() {
    if (_uploading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Center(
        child: IconButton(
          icon: Icon(Icons.add_photo_alternate),
          onPressed: () => _showImageSourceSelection(context),
        ),
      );
    }
  }

  Widget _buildImageWidget(String url) {
    return _buildContainer(
      CachedNetworkImage(
        imageUrl: url,
        placeholder: (context, string) =>
            Center(child: CircularProgressIndicator()),
        fit: BoxFit.contain,
        imageBuilder: (context, ImageProvider image) {
          return InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ImageViewPage(
                      image: image,
                      onDelete: () {
                        setState(() => widget.bill.imageURLs.remove(url));
                      },
                    ),
                  ),
                );
              },
              child: Image(image: image));
        },
      ),
    );
  }

  Widget _buildContainer(Widget child) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxWidth: 100, maxHeight: 100, minWidth: 100, minHeight: 100),
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        elevation: 3,
        child: child,
      ),
    );
  }
}
