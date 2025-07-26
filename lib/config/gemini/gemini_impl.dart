import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';

sealed class Gemini {
  Future<String> getResponse(String prompt);

  Stream<String> getResponseStream(String prompt);
}

class GeminiImpl extends Gemini {
  final _http = Dio(BaseOptions(baseUrl: dotenv.env['ENDPOINT_API'] ?? ''));

  @override
  Future<String> getResponse(String prompt) async {
    try {
      final body = jsonEncode({'prompt': prompt});

      final response = await _http.post('/basic-prompt', data: body);

      return response.data;
    } catch (e) {

      throw Exception('Falha ao obter resposta.');
    }
  }

  // Stream

  @override
  Stream<String> getResponseStream(
    String prompt, {
    List<XFile> files = const [],
  }) async* {
    final formData = FormData();
    formData.fields.add(MapEntry('prompt', prompt));

    if (files.isNotEmpty) {
      for (final file in files) {
        formData.files.add(
          MapEntry(
            'files',
            await MultipartFile.fromFile(file.path, filename: file.name),
          ),
        );
      }
    }

    //final body = jsonEncode({'prompt': prompt});
    final response = await _http.post(
      '/basic-prompt-stream',
      data: formData,
      options: Options(responseType: ResponseType.stream),
    );
    final stream = response.data.stream as Stream<List<int>>;
    String buffer = '';
    await for (final chunk in stream) {
      final chunkString = utf8.decode(chunk, allowMalformed: true);
      buffer += chunkString;
      yield buffer;
    }
  }

  Stream<String> getChatStream(
    String prompt,
    String chatId, {
    List<XFile> files = const [],
  }) async* {
    final formData = FormData();
    formData.fields.add(MapEntry('prompt', prompt));
    formData.fields.add(MapEntry('chatId', chatId));

    if (files.isNotEmpty) {
      for (final file in files) {
        formData.files.add(
          MapEntry(
            'files',
            await MultipartFile.fromFile(file.path, filename: file.name),
          ),
        );
      }
    }

    //final body = jsonEncode({'prompt': prompt});
    final response = await _http.post(
      '/chat-stream',
      data: formData,
      options: Options(responseType: ResponseType.stream),
    );
    final stream = response.data.stream as Stream<List<int>>;
    String buffer = '';
    await for (final chunk in stream) {
      final chunkString = utf8.decode(chunk, allowMalformed: true);
      buffer += chunkString;
      yield buffer;
    }
  }
}
