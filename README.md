# Plant Identifier

A cross-platform Flutter application that uses Google's Gemini AI to identify plants from photos, providing detailed information about the plant's characteristics, care instructions, and more.

## Features

- Take photos directly within the app
- Upload images from your device gallery
- Get detailed plant identification with:
  - Common and scientific names
  - Plant descriptions
  - Care instructions
  - Additional interesting facts
- Clean, modern UI design
- Cross-platform functionality (Android, iOS, web)

## Setup

### Prerequisites

- Flutter SDK (minimum version 3.7.2)
- Dart SDK
- A Google Gemini API key

### Installation

1. Clone the repository:
```
git clone https://github.com/yourusername/plant-identifier.git
```

2. Navigate to the project directory:
```
cd plant-identifier
```

3. Create a `.env` file in the root directory with your Gemini API key:
```
GEMINI_API_KEY=your_api_key_here
GEMINI_MODEL=gemini-2.5-flash-preview-04-17
```

4. Install dependencies:
```
flutter pub get
```

5. Run the app:
```
flutter run
```

## Technical Details

This app uses the following technologies and packages:

- **Flutter**: Cross-platform UI framework
- **Google Gemini API**: Advanced AI model for plant identification
- **Image Picker**: For capturing and selecting images
- **Camera**: Native camera integration
- **HTTP**: For API communication
- **Flutter dotenv**: For secure API key management

## Usage

1. Open the app and choose either "Take a Photo" or "Upload from Gallery"
2. Capture a clear image of the plant you want to identify
3. Wait for the AI to process the image
4. View the detailed identification results

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Google Gemini AI for powering the plant identification
- Flutter team for the amazing framework
- All contributors to the open source packages used in this project
