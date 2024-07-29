import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants{
  static String baseUrl = 'https://skillrader-backend.onrender.com/api';
  static String geminiAPIKey = dotenv.env['GEMINI_API_KEY']!;
}