import 'dart:convert';
import 'package:dio/dio.dart';

class OllamaService {
  static const String _baseUrl = 'http://localhost:11434';
  static const String _model = 'llama3.2';

  static final _dio = Dio(BaseOptions(
    baseUrl: _baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 60),
  ));

  /// Sends [phrase] to Ollama and returns a list of Material icon names.
  /// Returns an empty list on error or unparseable response.
  static Future<List<String>> getIconsForPhrase(String phrase) async {
    const systemPrompt =
        'You are a Flutter Material Icons mapper. '
        'Given a phrase in any language, return ONLY a valid JSON array of 5 to 8 '
        'icon names in snake_case from the Material Icons library. '
        'No explanation, no markdown, no extra text. '
        'Naming patterns: '
        'places use "local_" prefix → local_hospital, local_cafe, local_pizza, local_taxi, local_bar, local_police, local_fire_department, local_grocery_store; '
        'transport uses "directions_" prefix → directions_car, directions_bike, directions_bus, directions_boat, directions_walk; '
        'sports use "sports_" prefix → sports_soccer, sports_basketball, sports_tennis, sports_golf, sports_esports; '
        'weather/light ONLY use "wb_" prefix → wb_sunny, wb_cloudy, wb_twilight (do NOT use wb_ for anything else). '
        'Other icons (no prefix, use as-is): beach_access, park, home, school, work, person, group, '
        'favorite, star, celebration, music_note, movie, book, camera, phone, email, '
        'restaurant, flight, sailing, hiking, terrain, palette, medical_services, healing, '
        'child_care, shopping_cart, attach_money, pool, ac_unit, umbrella, nightlife, '
        'fitness_center, self_improvement, elderly, vaccines, emergency. '
        'Example for "hospital doctor": ["local_hospital","medical_services","healing","emergency","vaccines"]';

    final prompt = '$systemPrompt\nPhrase: "$phrase"';

    try {
      final response = await _dio.post('/api/generate', data: {
        'model': _model,
        'prompt': prompt,
        'stream': false,
      });

      final raw = response.data['response'] as String? ?? '';
      return _parseIconNames(raw);
    } on DioException catch (e) {
      throw Exception('Ollama no disponible: ${e.message}');
    }
  }

  static List<String> _parseIconNames(String raw) {
    final match = RegExp(r'\[.*?\]', dotAll: true).firstMatch(raw);
    if (match == null) return [];

    try {
      final decoded = jsonDecode(match.group(0)!) as List<dynamic>;
      return decoded
          .whereType<String>()
          .map((s) => s.trim().toLowerCase().replaceAll('-', '_'))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
