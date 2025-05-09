import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:plantidentifier1/screens/home_screen.dart';
import 'package:plantidentifier1/utils/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: '.env');
  
  runApp(const PlantIdentifierApp());
}

class PlantIdentifierApp extends StatelessWidget {
  const PlantIdentifierApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plant Identifier',
      theme: AppTheme.themeData,
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
