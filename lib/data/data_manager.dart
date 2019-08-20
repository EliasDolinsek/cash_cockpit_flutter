import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

void uploadFile(File file, String fileName, onUploaded(downloadURL)) {
  final StorageReference storageReference = FirebaseStorage.instance
      .ref()
      .child(fileName);
  final StorageUploadTask storageUploadTask = storageReference.putFile(file);

  storageUploadTask.onComplete.then((StorageTaskSnapshot s) async {
    final url = await s.ref.getDownloadURL();
    onUploaded(url);
  });
}

void uploadFileRandomNamed(File file, onUploaded(downloadURL)) => uploadFile(file, Uuid().v1(), onUploaded);

void deleteFile(String fileName, Function onDeleted){
  FirebaseStorage.instance.ref().child(fileName).delete().whenComplete(onDeleted);
}
