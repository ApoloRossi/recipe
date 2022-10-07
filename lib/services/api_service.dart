import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class ApiService {

  static const _baseURL = "https://api.openai.com/v1/completions";
  static const _token = "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";
  static const _header = "application/json";
  static const _model = "text-davinci-002";
  static const _temperature = 0.3;
  static const _maxTokens = 120;
  static const _topP = 1;
  static const _frequencyPenalty = 0.0;
  static const _presencePenalty = 0.0;

  Future<http.Response> generateRecipe(List<String> ingredients) async {
    return http
        .post(
          Uri.parse(_baseURL),
          headers: {
            HttpHeaders.authorizationHeader:
                "Bearer $_token",
            HttpHeaders.acceptHeader: _header,
            HttpHeaders.contentTypeHeader: _header,
          },
          body: jsonEncode({
            "model": _model,
            "prompt":
                "Write a recipe based on these ingredients and instructions:\n\n${ingredients.toString().replaceAll(",", "").replaceAll("[", "").replaceAll("]", "").replaceAll(" ", "")}\n\nInstructions:",
            "temperature": _temperature,
            "max_tokens": _maxTokens,
            "top_p": _topP,
            "frequency_penalty": _frequencyPenalty,
            "presence_penalty": _presencePenalty
          }),
        )
        .timeout(const Duration(seconds: 20));
  }
}
