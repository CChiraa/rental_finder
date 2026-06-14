import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage({
    required String folderName,
    required String filePath,
  }) async {
    final file = File(filePath);

    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${file.uri.pathSegments.last}';

    final ref = _storage.ref().child(folderName).child(fileName);

    final uploadTask = ref.putFile(file);

    final snapshot = await uploadTask;

    return await snapshot.ref.getDownloadURL();
  }

  Future<List<String>> uploadMultipleImages({
    required String folderName,
    required List<String> filePaths,
  }) async {
    List<String> urls = [];

    for (String path in filePaths) {
      final url = await uploadImage(folderName: folderName, filePath: path);

      urls.add(url);
    }

    return urls;
  }
}
