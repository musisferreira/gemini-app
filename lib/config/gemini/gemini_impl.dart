import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
      print(e);

      throw Exception('Falha ao obter resposta.');
    }
  }

  // Stream

  @override
  Stream<String> getResponseStream(String prompt) async* {
    final body = jsonEncode({'prompt': prompt});
    final response = await _http.post(
      '/basic-prompt-stream',
      data: body,
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

