import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

@riverpod
User geminiUser(Ref ref) {
  return User(
    id: 'geminiUser-id',
    firstName: 'Gemini',

    imageUrl: 'https://i.pravatar.cc/150?img=1',
  );
}

@riverpod
User user(Ref ref) {
  return User(
    id: 'message-id-abc',
    firstName: 'Musis',
    lastName: 'Ferreira',
    imageUrl: 'https://i.pravatar.cc/150?img=1',
  );
}
