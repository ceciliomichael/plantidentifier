import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/plant.dart';

class GeminiService {
  final String apiKey;
  final String model;
  
  GeminiService({
    String? apiKey,
    String? model,
  }) : 
    apiKey = apiKey ?? dotenv.env['GEMINI_API_KEY'] ?? '',
    model = model ?? dotenv.env['GEMINI_MODEL'] ?? 'gemini-2.5-flash-preview-04-17';

  Future<Plant> identifyPlant(Uint8List imageBytes) async {
    try {
      // Convert image to base64
      String base64Image = base64Encode(imageBytes);
      
      // Make sure the base64 string doesn't contain any newlines
      base64Image = base64Image.replaceAll('\n', '');
      
      // Prepare the request to Gemini API
      final url = 'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey';
      
      // Improved prompt with clearer instructions and format
      final prompt = '''
      Identify this plant and provide the following information in a clear, structured format:
      
      Name: [Provide the common name of the plant. This is required, do not leave this as unknown if you can identify the plant]
      Scientific Name: [Provide the full scientific name]
      Plant Family: [Provide the family name]
      Native Region: [Provide regions where this plant is native]
      Description: [Provide a brief but detailed description of the plant's appearance, features, and characteristics]
      Care Instructions:
        - Water: [Detailed watering requirements]
        - Light: [Light and sun exposure needs]
        - Soil: [Soil preferences and requirements]
        - Temperature: [Temperature tolerance and preferences]
      Additional Information: [Any other notable facts, uses, or special characteristics]
      
      Make sure to fill in all sections with accurate information. If you recognize the plant but are not 100% certain, provide your best assessment and note your confidence level.
      ''';
      
      // Check if the image data is valid
      if (base64Image.isEmpty) {
        throw Exception('Image data is empty');
      }
      
      // Prepare the request body
      final requestBody = {
        "contents": [
          {
            "parts": [
              {
                "text": prompt
              },
              {
                "inline_data": {
                  "mime_type": "image/jpeg",
                  "data": base64Image
                }
              }
            ]
          }
        ]
      };
      
      // Send the request
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );
      
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        
        // Extract the text response from Gemini
        final String textResponse = jsonResponse['candidates'][0]['content']['parts'][0]['text'] ?? '';
        
        print('API Response: $textResponse'); // Log response for debugging
        
        // Parse the text response into a Plant object
        return Plant.fromGeminiResponse(textResponse);
      } else {
        // Handle error responses with more detailed information
        final errorBody = response.body;
        print('API Error: ${response.statusCode} - $errorBody');
        throw Exception('Failed to identify plant: ${response.statusCode} - $errorBody');
      }
    } catch (e) {
      print('Error in identifyPlant: $e');
      throw Exception('Error identifying plant: $e');
    }
  }
} 