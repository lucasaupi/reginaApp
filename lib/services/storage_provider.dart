import 'package:firebase_storage/firebase_storage.dart';

class Storage {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> getImagePath({
    required String folder,
    required String fileName,
  }) async {
    final ref = _storage.ref().child('$folder/$fileName');
    return await ref.getDownloadURL();
  }
}
