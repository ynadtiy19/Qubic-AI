import 'dart:developer';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:qubic_ai/core/utils/constants/env.dart';

import '../../../core/utils/helper/network_status.dart';

class GenerativeAIWebService {
  final _model = GenerativeModel(
    model: EnvManager.model,
    apiKey: EnvManager.apiKey,
  );

  Future<String?> postData(String prompt) async {
    try {
      if (!await NetworkHelper.isConnected()) {
        return "No internet connection";
      }

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      log("Data posted successfully!");

      return response.text?.trim();
    } on Exception catch (err) {
      log('Error in postData: ${err.toString()}');
      return "There was an error, please try again later!";
    }
  }

  Stream<String?> streamData(String prompt) async* {
    try {
      if (!await NetworkHelper.isConnected()) {
        log("No internet connection");
        yield "No internet connection";
        return;
      }

      final content = [Content.text(prompt)];
      final response = _model.generateContentStream(content);

      await for (final chunk in response) {
        if (chunk.text != null) yield chunk.text;
      }
    } on GenerativeAIException catch (e) {
      log('API Error: ${e.message}');
      yield "There was an error, please try again later!";
      return;
    } on Exception catch (e) {
      log('General Error: ${e.toString()}');
      yield "There was an error, please try again later!";
      return;
    }
  }
}
