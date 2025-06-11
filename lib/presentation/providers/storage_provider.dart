import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:regina_app/services/storage_provider.dart';

final storageProvider = Provider<Storage>((ref) {
  return Storage();
});
