
# Track My Things

Stay on top of your product warranties with Track My Things, a cutting-edge Flutter app that utilizes AI capabilities to make tracking and managing warranties a breeze. This innovative app not only reminds you of upcoming warranty expirations but also simplifies the process of adding new products with its intelligent AI-powered features


## Screenshots

<img src="https://github.com/user-attachments/assets/7502e3a5-a9ee-44f4-98c1-bbcca82f6ce7" width="200" height="400" >
<img src="https://github.com/user-attachments/assets/6005f3a6-1a61-41d3-8b06-95a6644ff30b" width="200" height="400" >
<img src="https://github.com/user-attachments/assets/efbedd0e-2f11-4006-b5e8-c16043d26810" width="200" height="400" >
<img src="https://github.com/user-attachments/assets/7502e3a5-a9ee-44f4-98c1-bbcca82f6ce7" width="200" height="400" >

## Tech Stack

**Client:** Flutter, Dart

**Server:** Firebase

**AI Integration:** Gemini API


## Features

### AI-Driven Product Addition
Adding new products to your warranty tracker is a breeze. Simply click a picture of the product bill, and our AI-powered technology takes care of the rest. Our app will extracts all details such as product name, model number, purchase date, warranty duration, and more, and automatically fills them in for you. You can then cross-verify the information and make any necessary corrections. This innovative feature saves you time and effort, making it easy to stay organized and keep track of your warranties.

### Multi-Language Support
With support for both Hindi and English languages, this Flutter app caters to a diverse user base, ensuring that everyone can benefit from its features. Whether you're in India or abroad, Track My Things is designed to be accessible and user-friendly, regardless of your language preferences.

### Intuitive User Interface
Built with Flutter's fast development capabilities, Track My Things boasts a lightning-fast and highly responsive user interface. With features like filter, sort, and search functionality, you can effortlessly manage your warranties and stay organized. Plus, with a UI that's designed for ease of use, you'll be able to navigate the app with ease, even on the go.

### Dynamic Theme Change

Take control of your app experience with Track My Things' dynamic theme change feature. Easily switch between light and dark themes to suit your mood, environment, or personal preference. With just a tap, you can transform the app's UI to suit your needs, making it even more enjoyable to use.


## Installation

### Step 1 : Clone the Project

Open a terminal or command prompt and navigate to the directory where you want to clone the project. Run the following command to clone the project from GitHub:

```bash
git clone https://github.com/minesh2908/TMT-TrackMyThings.git
```

### Step 2 : Navigate to the project directory
Navigate to the cloned project directory:

```bash
cd [repository_name]
```

### Step 3 : Get Flutter Dependencies
Run the following command to get all the Flutter dependencies:

```bash
flutter pub get
```
This command will download and install all the required dependencies for the project.

### Step 4 : Create API Key File
Create a new file named api_key.dart inside the constants folder.

Open the api_key.dart file in a text editor and add the following code:

```bash
const String geminiApiKey = 'YOUR_GEMINI_API_KEY_HERE';
```

Replace YOUR_GEMINI_API_KEY_HERE with your actual Gemini API key obtained from the Google DeepMind website.

### Step 5 : Run the App

Navigate back to the project root directory:
```bash
cd..
```
Run the following command to start the app:
```bash
flutter run
```

This command will compile and run the app on an emulator or a connected device.
