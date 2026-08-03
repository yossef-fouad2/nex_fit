import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  AppConfig._();
  static SupabaseClient? _supabase;

  static bool get isSupabaseConfigured => _supabase != null;

  static SupabaseClient get supabase {
    if (_supabase == null) {
      throw StateError('Supabase is not configured with valid credentials.');
    }
    return _supabase!;
  }

  static String get baseUrl => _getBaseUrl();

  static Future<void> init() async {
    final url = dotenv.get('SUPABASE_URL', fallback: '');
    final key = dotenv.get('SUPABASE_ANON_KEY', fallback: '');

    if (url.isEmpty || url.contains('YOUR-PROJECT') || key.contains('YOUR-ANON-KEY')) {
      // Placeholder credentials — skip network initialization
      return;
    }

    try {
      await Supabase.initialize(
        url: url,
        publishableKey: key,
      ).timeout(const Duration(seconds: 3));
      _supabase = Supabase.instance.client;
    } catch (_) {}
  }

  static String _getBaseUrl() {
    return dotenv.get('API_BASE_URL', fallback: 'https://api.example.com');
  }
}
