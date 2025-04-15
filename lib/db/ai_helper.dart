/*
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:my_symptom_checker_v2/secrets.dart';

class AIHelper {
  final String apiUrl = "https://api.openai.com/v1/chat/completions";
  late String apiKey;

  AIHelper() {
    try {
      apiKey = Secrets.openAiApiKey;
    } catch (e) {
      debugPrint("Error loading API Key from secrets.dart: $e");
      apiKey = "";
    }
  }

  Future<String> getAIDiagnosis(String symptoms) async {
    if (apiKey.isEmpty) {
      return "API Key is missing!";
    }

    try {
      debugPrint("AI Request: Sending symptoms -> $symptoms");

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "model": "gpt-4",
          "messages": [
            {
              "role": "system",
              "content": "Hello! I'm HealthMate, your AI doctor assistant.",
            },
            {
              "role": "user",
              "content":
                  "I have these symptoms: $symptoms. What could be the cause?",
            },
          ],
        }),
      );

      debugPrint("AI Response Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        return jsonResponse["choices"][0]["message"]["content"];
      } else {
        debugPrint("AI API Error: ${response.body}");
        return "AI Diagnosis Failed. API Error: ${response.statusCode} - ${response.body}";
      }
    } catch (e) {
      debugPrint("AI API Connection Error: $e");
      return "AI Diagnosis Failed. No internet connection or API blocked.";
    }
  }
}
*/