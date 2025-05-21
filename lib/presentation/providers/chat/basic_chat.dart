import 'package:flutter_chat_types/flutter_chat_types.dart'
    show Message, PartialText, TextMessage, User;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../config/gemini/gemini_impl.dart';
import '../users/user_provider.dart';


part 'basic_chat.g.dart';

@riverpod
class BasicChat extends _$BasicChat {
  // ignore: avoid_public_notifier_properties
 final gemini = GeminiImpl();

  // ignore: avoid_public_notifier_properties
  late User geminiUser;

  @override
  List<Message> build() {
     geminiUser = ref.read(geminiUserProvider);
    return [];
  }

  void addMessage({required PartialText partialText, required User user}) {
    // TODO: add geminiUser

    _addTextMessage(partialText, user);
  }

  void _addTextMessage(PartialText partialText, User author) {
    _createTextMessage(partialText.text, author);
    //_geminiTextResponse(partialText.text);
    _geminiTextResponseStream(partialText.text);
  }

  // void _geminiTextResponse(String prompt) async {
  //   _setGeminiWritingStatus(true);
  //
  //   final textResponse = await gemini.getResponse(prompt);
  //   _setGeminiWritingStatus(false);
  //
  //   _createTextMessage(textResponse, geminiUser);
  // }

  // Helper methods

  void _geminiTextResponseStream(String prompt) async {
    _createTextMessage('Gemeni está pensando...', geminiUser);

    gemini.getResponseStream(prompt).listen((responseChunk) {
      if (responseChunk.isEmpty) return;

      final updateMessages = [...state];
      final updateMessage = (updateMessages.first as TextMessage).copyWith(
        text: responseChunk,
      );

      updateMessages[0] = updateMessage;
      state = updateMessages;
    });

    //_createTextMessage(textResponse, geminiUser);
  }

  void _createTextMessage(String text, User author) {
    final message = TextMessage(
      id: Uuid().v4(),
      author: author,
      text: text,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    state = [message, ...state];
  }

  // void _setGeminiWritingStatus(bool isWriting) {
  //   final isGeminiWriting = ref.read(isGeminiWritingProvider.notifier);
  //   isWriting
  //       ? isGeminiWriting.setIsWriting()
  //       : isGeminiWriting.setIsNotWriting();
  // }
}
