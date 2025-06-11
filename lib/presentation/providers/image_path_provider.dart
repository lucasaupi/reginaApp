import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:regina_app/presentation/providers/storage_provider.dart';

final imagePathProvider = FutureProvider.family<String, (String folder, String fileName)>((ref, params) {
  final storage = ref.read(storageProvider);
  return storage.getImagePath(folder: params.$1, fileName: params.$2);
});
