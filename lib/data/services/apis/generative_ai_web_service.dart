import 'dart:developer';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:qubic_ai/core/utils/constants/env.dart';

class GenerativeAIWebService {
  final _model = GenerativeModel(
    model: EnvManager.model,
    apiKey: EnvManager.apiKey,
  );

  Future<String?> postData(String prompt) async {
    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      log("Data posted successfully!");

      return response.text?.trim();
    } on Exception catch (err) {
      log('Error in postData: ${err.toString()}');
      throw Exception('Error in postData: ${err.toString()}');
    }
  }

  Stream<String?> streamData(String prompt) async* {
    try {
      final content = [Content.text(prompt)];
      final response = _model.generateContentStream(content);

      await for (final chunk in response) {
        if (chunk.text != null) yield chunk.text;
      }
    } on GenerativeAIException catch (err) {
      log('API Error: ${err.message}');
      throw Exception('Error in streamData: ${err.toString()}');
    } on Exception catch (err) {
      log('General Error: ${err.toString()}');
      throw Exception('Error in streamData: ${err.toString()}');
    }
  }
}
