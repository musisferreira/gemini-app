import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/chat/basic_chat.dart';
import '../../providers/chat/is_gemini_writing.dart';
import '../../providers/users/user_provider.dart';

class BasicPromptScreen extends ConsumerWidget {
  const BasicPromptScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final geminiUser = ref.watch(geminiUserProvider);
    final user = ref.watch(userProvider);
    final isGeminiWriting = ref.watch(isGeminiWritingProvider);
    final chatMessages = ref.watch(basicChatProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Basic Prompt'), centerTitle: true),
      body: Chat(
        messages: chatMessages,
        // On Send Message
        onSendPressed: (types.PartialText partialText) {
          final basicChatNotifier = ref.read(basicChatProvider.notifier);
          basicChatNotifier.addMessage(partialText: partialText, user: user);

          print('mensagem: $partialText');
        },
        user: user,
        theme: DarkChatTheme(),
        showUserNames: true,

        showUserAvatars: true,
        typingIndicatorOptions: TypingIndicatorOptions(
          typingUsers: isGeminiWriting ? [geminiUser] : [],
          // TODO: add geminiUser
          customTypingWidget: Center(
            child: const Text('Gemini está pensando...'),
          ),
        ),
      ),
    );
  }
}
