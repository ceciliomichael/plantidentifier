class Plant {
  final String name;
  final String scientificName;
  final String description;
  final List<String> careInstructions;
  final List<String> additionalInfo;
  final String family;
  final String nativeRegion;

  Plant({
    required this.name,
    required this.scientificName,
    this.description = '',
    this.careInstructions = const [],
    this.additionalInfo = const [],
    this.family = '',
    this.nativeRegion = '',
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      name: json['name'] ?? 'Unknown Plant',
      scientificName: json['scientificName'] ?? 'Unknown',
      description: json['description'] ?? '',
      careInstructions: List<String>.from(json['careInstructions'] ?? []),
      additionalInfo: List<String>.from(json['additionalInfo'] ?? []),
      family: json['family'] ?? '',
      nativeRegion: json['nativeRegion'] ?? '',
    );
  }

  // For parsing the Gemini API response which comes as text
  factory Plant.fromGeminiResponse(String responseText) {
    // Default values
    String name = 'Unknown Plant';
    String scientificName = 'Unknown';
    String description = '';
    String family = '';
    String nativeRegion = '';
    List<String> careInstructions = [];
    List<String> additionalInfo = [];

    // Parse the response text to extract plant information
    final lines = responseText.split('\n');
    
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      
      // Extract name (with high priority)
      if (line.startsWith('Name:')) {
        final nameValue = line.substring('Name:'.length).trim();
        // Only use if it's not empty or "unknown"
        if (nameValue.isNotEmpty && 
            !nameValue.toLowerCase().contains('unknown') &&
            !nameValue.contains('[')) {
          name = nameValue;
        }
      } 
      // Detect if Moringa or another plant is mentioned in care instructions
      else if (line.toLowerCase().contains('moringa') && name == 'Unknown Plant') {
        name = 'Moringa';
      }
      // Extract scientific name
      else if (line.startsWith('Scientific Name:')) {
        final value = line.substring('Scientific Name:'.length).trim();
        if (value.isNotEmpty && !value.contains('[')) {
          scientificName = value;
        }
      }
      // Extract family
      else if (line.startsWith('Plant Family:') || line.startsWith('Family:')) {
        final value = line.substring(line.indexOf(':') + 1).trim();
        if (value.isNotEmpty && !value.contains('[')) {
          family = value;
        }
      }
      // Extract native region
      else if (line.startsWith('Native Region:')) {
        final value = line.substring('Native Region:'.length).trim();
        if (value.isNotEmpty && !value.contains('[')) {
          nativeRegion = value;
        }
      }
      // Extract description
      else if (line.startsWith('Description:')) {
        // Collect description until the next section
        int j = i + 1;
        List<String> descLines = [];
        while (j < lines.length && 
               !lines[j].contains(':') &&
               !lines[j].contains('Care Instructions')) {
          if (lines[j].trim().isNotEmpty) {
            descLines.add(lines[j].trim());
          }
          j++;
        }
        description = descLines.join('\n');
        i = j - 1;
      } 
      // Extract care instructions
      else if (line.contains('Care Instructions:')) {
        i++; // Move to the line after "Care Instructions:"
        while (i < lines.length && 
              !lines[i].contains('Additional Information:')) {
          final instruction = lines[i].trim();
          if (instruction.isNotEmpty && 
              instruction.contains(':') && 
              !instruction.endsWith(':')) {
            careInstructions.add(instruction);
          } else if (instruction.startsWith('-') || instruction.startsWith('*')) {
            careInstructions.add(instruction);
          }
          i++;
        }
        i--; // Adjust index since we'll increment in the loop
      } 
      // Extract water information as care instruction
      else if (line.contains('Water:')) {
        final instruction = line.trim();
        if (!careInstructions.contains(instruction)) {
          careInstructions.add(instruction);
        }
      } 
      // Extract light information as care instruction
      else if (line.contains('Light:')) {
        final instruction = line.trim();
        if (!careInstructions.contains(instruction)) {
          careInstructions.add(instruction);
        }
      } 
      // Extract soil information as care instruction
      else if (line.contains('Soil:')) {
        final instruction = line.trim();
        if (!careInstructions.contains(instruction)) {
          careInstructions.add(instruction);
        }
      } 
      // Extract temperature information as care instruction
      else if (line.contains('Temperature:')) {
        final instruction = line.trim();
        if (!careInstructions.contains(instruction)) {
          careInstructions.add(instruction);
        }
      } 
      // Extract additional information
      else if (line.contains('Additional Information:')) {
        // Collect additional information until the end
        int j = i + 1;
        while (j < lines.length) {
          final info = lines[j].trim();
          if (info.isNotEmpty && !info.endsWith(':')) {
            additionalInfo.add(info);
          }
          j++;
        }
        i = j - 1;
      }
    }

    return Plant(
      name: name,
      scientificName: scientificName,
      description: description,
      careInstructions: careInstructions,
      additionalInfo: additionalInfo,
      family: family,
      nativeRegion: nativeRegion,
    );
  }
} 