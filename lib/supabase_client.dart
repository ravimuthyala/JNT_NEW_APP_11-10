import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://nydwxtcpwsbbmgmfdsla.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im55ZHd4dGNwd3NiYm1nbWZkc2xhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM0OTIyNjAsImV4cCI6MjA3OTA2ODI2MH0.qJ62HQyqI1kwudMooMM89XMMJ8HDi79VGgtvH1rjPsQ';

  static Future<void> init() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}