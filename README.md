---

<h1 align="center"> 📚 StudyHub </h1>
<h3 align="center">Student Productivity & Academic Management Platform </h3>

<div align="center">
<img width="225" height="225" src="https://github.com/ysathyasai/StudyHub/raw/main/assets/icons/Logo.png" />
</div>
<br>
<div align="center">

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue?style=flat-square&logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Latest-orange?style=flat-square&logo=firebase)](https://firebase.google.com)
[![Google Generative AI](https://img.shields.io/badge/Google%20Gemini-API-yellow?style=flat-square&logo=google)](https://ai.google.dev)
[![License](https://img.shields.io/badge/License-GPL%20v3-red?style=flat-square)](LICENSE)
[![Dart](https://img.shields.io/badge/Dart-2.19+-0175C2?style=flat-square&logo=dart)](https://dart.dev)

[🚀 Android App](https://github.com/ysathyasai/StudyHub/releases/download/StudyHub/StudyHub.apk) • [📖 Documentation](https://raw.githubusercontent.com/ysathyasai/StudyHub/main/docs/Group%20Document.pdf) • [🤝 Contributing](https://github.com/ysathyasai/StudyHub?tab=readme-ov-file#-project-team) • [📄 LICENSE](LICENSE)

</div>

---

## 🎯 Overview

StudyHub is a comprehensive student productivity ecosystem designed to streamline academic workflows through a unified, intuitive interface. The platform brings together notes, tasks, timetables, performance tracking, study planning, AI-powered learning tools, and career resources—giving students everything they need in one place.

> *A privacy-centric, mobile-first academic companion for modern learners.*

**Key Philosophy:**
- 🔒 All data stays private and fully user-controlled
- ⚡ Lightning-fast, offline-first architecture
- 🎨 Intuitive, modern UI/UX design
- 🤖 AI-powered personalized learning experiences
- 📱 Native mobile app with cross-platform support

## ✨ Core Features

### 📖 **Notes Manager**
Organize subjects, chapters, and study materials with a structured, hierarchical interface. Create rich-text notes with formatting, images, and attachments.

### 🗓️ **Smart Timetable**
Create, visualize, and manage class schedules, exams, and weekly routines with calendar integration and smart reminders.

### 📊 **Performance Tracker**
- Semester-wise GPA/CGPA tracking
- Grade analytics and trends visualization
- Subject-wise performance analysis
- Academic insights dashboard

### 📌 **Tasks & Assignments**
Track deadlines, set priorities, mark completion status, and receive smart notifications for upcoming assignments.

### 🔥 **Habit Tracker**
Monitor study habits and build consistency with analytics-backed insights. Track daily study sessions, focus time, and productivity metrics.

### 📕 **Syllabus Progress**
Track completion percentage for each subject, monitor chapter progress, and stay exam-ready with coverage analytics.

### 🔢 **Formula & Reference Book**
Maintain formulas, shortcuts, legal definitions, concepts, and quick-reference materials for each subject.

### ⏱️ **Pomodoro Timer**
Boost focus using scientifically proven study cycles (25 min focus + 5 min break). Customizable intervals and session tracking.

### 📁 **Document Vault**
Store certificates, academic files, important documents, and digital records securely with cloud backup.

### 🎓 **Opportunities Hub**
Discover scholarships, internships, hackathons, competitions, and learning opportunities curated for students.

### 🤖 **AI-Powered Learning Tools** *(Powered by Google Gemini API)*
- **Auto-Generated Quizzes** – Intelligent quiz generation from notes
- **Smart Flashcards** – AI-powered spaced repetition learning
- **Practice Questions** – Targeted problem sets by topic
- **Personalized Study Plans** – AI-tailored learning roadmaps
- **Study Summaries** – Auto-generated chapter summaries and key points

### 💼 **Career Tools** *(Premium Features)*
- Resume builder and templates
- Portfolio showcase
- QR code generation for quick profile sharing
- Career opportunity tracking

---

## 🛠️ Tech Stack

### **Mobile Framework**
| Technology | Purpose | Version |
|---|---|---|
| **Flutter** | Cross-platform native UI framework | 3.0+ |
| **Dart** | Programming language | 2.19+ |

### **Backend & Services**
| Technology | Purpose |
|---|---|
| **Firebase Authentication** | Secure user authentication & Google Sign-In |
| **Cloud Firestore** | Real-time NoSQL database with offline support |
| **Firebase Storage** | Document and file storage |
| **Google Generative AI (Gemini)** | AI-powered learning features |
| **HTTP/Dio** | RESTful API communication |

### **UI & State Management**
| Technology | Purpose |
|---|---|
| **Material Design 3** | Modern, responsive UI components |
| **Google Fonts** | Typography and font management |
| **Provider** | State management & dependency injection |

### **Utilities & Plugins**
| Package | Purpose |
|---|---|
| `shared_preferences` | Local preference storage (auth tokens) |
| `uuid` | Unique ID generation |
| `qr_flutter` | QR code generation |
| `url_launcher` | External link handling |
| `file_picker` | File selection from device |
| `image_picker` | Camera and gallery access |
| `path_provider` | Device file system paths |
| `permission_handler` | Runtime permissions management |
| `open_filex` | File opening (PDFs, docs, etc.) |
| `intl` | Internationalization & date formatting |

### **Architecture Highlights**
- ✅ Clean separation of concerns (Models, Services, UI)
- ✅ Privacy-first design with Firestore security rules
- ✅ Offline-first with local caching
- ✅ Type-safe Dart implementation
- ✅ Modular component structure

---

## 📁 Project Structure

```
StudyHub/
│
├── lib/
│   ├── main.dart                          # Application entry point
│   ├── theme.dart                         # Material Design 3 theme configuration
│   ├── firebase_options.dart              # Firebase initialization
│   │
│   ├── models/                            # Data models
│   │   ├── calendar_event_model.dart
│   │   ├── certification_model.dart
│   │   ├── flashcard_model.dart
│   │   ├── formula_model.dart
│   │   ├── internship_model.dart
│   │   ├── note_model.dart
│   │   ├── portfolio_model.dart
│   │   ├── qr_code_model.dart
│   │   ├── resume_model.dart
│   │   ├── scholarship_model.dart
│   │   ├── semester_result_model.dart
│   │   ├── study_session_model.dart
│   │   ├── task_model.dart
│   │   ├── timetable_model.dart
│   │   └── user_model.dart
│   │
│   ├── screens/                           # UI Screens
│   │   ├── ai_tools
│   │   │   ├── ai_tools_screen.dart
│   │   │   ├── quiz_generator_screen.dart
│   │   │   └── summarizer_screen.dart
│   │   ├── auth_screen.dart
│   │   ├── auth_wrapper.dart
│   │   ├── calendar
│   │   │   └── calendar_screen.dart
│   │   ├── career
│   │   │   ├── career_screen.dart
│   │   │   ├── certifications_screen.dart
│   │   │   ├── internships_screen.dart
│   │   │   ├── portfolio_screen.dart
│   │   │   └── scholarships_screen.dart
│   │   ├── code_compiler
│   │   │   └── code_compiler_screen.dart
│   │   ├── dashboard_screen.dart
│   │   ├── flashcards
│   │   │   ├── flashcard_study_screen.dart
│   │   │   ├── flashcards_screen.dart
│   │   │   └── generate_flashcards_screen.dart
│   │   ├── focus_mode
│   │   │   └── focus_mode_screen.dart
│   │   ├── formula_library
│   │   │   └── formula_library_screen.dart
│   │   ├── home
│   │   │   └── home_screen.dart
│   │   ├── main_screen.dart
│   │   ├── more
│   │   │   ├── more_screen.dart
│   │   │   ├── profile_screen.dart
│   │   │   └── settings_screen.dart
│   │   ├── notes
│   │   │   ├── note_editor_screen.dart
│   │   │   └── notes_screen.dart
│   │   ├── qr_tools
│   │   │   └── qr_tools_screen.dart
│   │   ├── resume
│   │   │   └── resume_builder_screen.dart
│   │   ├── schedule
│   │   │   └── schedule_screen.dart
│   │   ├── semester_overview
│   │   │   ├── add_semester_result_screen.dart
│   │   │   └── semester_overview_screen.dart
│   │   ├── splash_screen.dart
│   │   ├── study
│   │   │   └── study_screen.dart
│   │   ├── study_timer
│   │   │   └── study_timer_screen.dart
│   │   ├── tasks
│   │   │   └── tasks_screen.dart
│   │   └── timetable
│   │       ├── add_timetable_entry_screen.dart
│   │       └── timetable_screen.dart
│   │
│   ├── services/                          # Business logic & API integration
│   │   ├── api_service.dart
│   │   ├── auth_service.dart
│   │   ├── calendar_service.dart
│   │   ├── certification_service.dart
│   │   ├── flashcard_service.dart
│   │   ├── formula_service.dart
│   │   ├── gemini_service.dart
│   │   ├── internship_service.dart
│   │   ├── note_service.dart
│   │   ├── portfolio_service.dart
│   │   ├── qr_code_service.dart
│   │   ├── resume_service.dart
│   │   ├── scholarship_service.dart
│   │   ├── semester_service.dart
│   │   ├── storage_service.dart
│   │   ├── task_service.dart
│   │   ├── theme_provider.dart
│   │   ├── timetable_service.dart
│   │   └── user_service.dart
│   │
│   └── widgets/                           # Reusable UI components
│       ├── app_bar.dart
│       ├── bottom_nav_bar.dart
│       ├── custom_button.dart
│       ├── task_card.dart
│       └── ... (other widgets)
│
├── android/                               # Android native code & configuration
│   ├── app
│   │   ├── build.gradle
│   │   ├── google-services.json
│   │   └── src
│   │       ├── debug
│   │       │   └── AndroidManifest.xml
│   │       ├── main
│   │       │   ├── AndroidManifest.xml
│   │       │   ├── java
│   │       │   │   └── io
│   │       │   │       └── flutter
│   │       │   │           └── plugins
│   │       │   │               └── GeneratedPluginRegistrant.java
│   │       │   ├── kotlin
│   │       │   │   └── com
│   │       │   │       └── studyhub
│   │       │   │           └── app
│   │       │   │               └── MainActivity.kt
│   │       │   └── res
│   │       │       ├── drawable
│   │       │       │   └── launch_background.xml
│   │       │       ├── drawable-hdpi
│   │       │       │   └── ic_launcher_foreground.png
│   │       │       ├── drawable-mdpi
│   │       │       │   └── ic_launcher_foreground.png
│   │       │       ├── drawable-v21
│   │       │       │   └── launch_background.xml
│   │       │       ├── drawable-xhdpi
│   │       │       │   └── ic_launcher_foreground.png
│   │       │       ├── drawable-xxhdpi
│   │       │       │   └── ic_launcher_foreground.png
│   │       │       ├── drawable-xxxhdpi
│   │       │       │   └── ic_launcher_foreground.png
│   │       │       ├── mipmap-anydpi-v26
│   │       │       │   └── ic_launcher.xml
│   │       │       ├── mipmap-hdpi
│   │       │       │   └── ic_launcher.png
│   │       │       ├── mipmap-mdpi
│   │       │       │   └── ic_launcher.png
│   │       │       ├── mipmap-xhdpi
│   │       │       │   └── ic_launcher.png
│   │       │       ├── mipmap-xxhdpi
│   │       │       │   └── ic_launcher.png
│   │       │       ├── mipmap-xxxhdpi
│   │       │       │   └── ic_launcher.png
│   │       │       ├── values
│   │       │       │   ├── colors.xml
│   │       │       │   └── styles.xml
│   │       │       └── values-night
│   │       │           └── styles.xml
│   │       └── profile
│   │           └── AndroidManifest.xml
│   ├── build.gradle
│   ├── gradle
│   │   └── wrapper
│   │       ├── gradle-wrapper.jar
│   │       └── gradle-wrapper.properties
│   ├── gradle.properties
│   ├── gradlew
│   ├── gradlew.bat
│   ├── local.properties
│   └── settings.gradle
├── ios/                                   # iOS native code & configuration (Under development)
├── web/                                   # Web platform support(Under Development)
├── windows/                               # Windows desktop support (Under Development)
│
├── assets/
│   └── icons/                             # App icons & assets
│
├── pubspec.yaml                           # Flutter dependencies & configuration
├── pubspec.lock                           # Locked dependency versions
├── firebase.json                          # Firebase configuration
├── firestore.indexes.json                 # Firestore composite indexes
├── firestore.rules                        # Firestore security rules
├── analysis_options.yaml                  # Dart linting rules
│
├── pubspec.lock
├── pubspec.yaml
├── studyhub.iml
├── analysis_options.yaml
├── firebase.json
├── firestore.indexes.json
├── firestore.rules
├── docs
│   ├── 23054-AI-051.pdf
│   ├── Group Document.pdf
│   └── Logo.png
├── LICENSE                                # GNU GPL v3 License
└── README.md                              # This file

```

### **Key Directory Descriptions**

- **`lib/models/`** – Defines all data structures for notes, tasks, users, timetables, etc.
- **`lib/screens/`** – Contains all UI pages and screens
- **`lib/services/`** – Handles Firebase operations, API calls, authentication, and business logic
- **`lib/widgets/`** – Reusable, custom UI components
- **`firestore.rules`** – Security rules ensuring user data privacy and access control

## 🔐 Data Privacy & Security

### Firestore Security Model
StudyHub implements strict privacy controls:

```firestore
// Only authenticated users can access their own data
match /users/{userId} {
  allow read, write: if request.auth.uid == userId;
}

// All collections follow user-specific access patterns
match /notes/{noteId} {
  allow read, write: if resource.data.userId == request.auth.uid;
}
```

**Privacy Guarantees:**
- ✅ End-to-end user isolation via Firestore security rules
- ✅ No data sharing between users
- ✅ All personal data encrypted in transit and at rest
- ✅ No unnecessary data collection
- ✅ Compliant with academic privacy requirements

---

## Documentation

You can check out the [Group Document](https://raw.githubusercontent.com/ysathyasai/StudyHub/main/docs/Group%20Document.pdf) and [My Document](https://raw.githubusercontent.com/ysathyasai/StudyHub/main/docs/23054-AI-051.pdf).

---

## 📦 Installation & Setup

### **Prerequisites**
- Flutter SDK (3.0+) – [Install Flutter](https://flutter.dev/docs/get-started/install)
- Dart SDK (2.19+) – Included with Flutter
- Android Studio / Xcode (for mobile development)
- Firebase account (for backend services)
- Google Gemini API key (for AI features)

### **Step 1: Clone the Repository**

```bash
git clone https://github.com/ysathyasai/StudyHub.git
cd StudyHub
```

### **Step 2: Install Dependencies**

```bash
flutter pub get
```

### **Step 3: Configure Firebase**

1. Create a Firebase project at [firebase.google.com](https://firebase.google.com)
2. Add Android and Web apps to your project
3. Download `google-services.json` (Android) and place in `android/app/`
4. Also configure the `firebase_options` and `firebase.json` files with the appropriate ID's.
5. The Firebase Dart configuration will be auto-generated via:

```bash
flutterfire configure
```

### **Step 4: Set Up Environment Variables**

Create a `.env` file in the root directory:

```env
GEMINI_API_KEY=your_google_gemini_api_key
FIREBASE_PROJECT_ID=studyhub-ebbfc
```

### **Step 5: Build & Run**

#### **Run on Android Emulator/Device**
```bash
flutter run
```

#### **Run on iOS Simulator/Device**
```bash
flutter run -d macos
# or for physical device
flutter run -d ios
```

#### **Build for Release**

**Android:**
```bash
flutter build apk --release
# or for Play Store (AAB format)
flutter build appbundle --release
```

---

## 🚀 Usage Guide

### **Authentication**
1. Launch the app and tap **"Sign Up"** or **"Sign In"**
2. Use email/password or **Google Sign-In** for quick authentication
3. Complete your profile setup

### **Creating Notes**
1. Navigate to **📖 Notes** tab
2. Tap **"+"** to create a new note
3. Select subject and chapter
4. Add title, content, and media (images, attachments)
5. Save automatically or manually via the save button

### **Managing Tasks**
1. Go to **📌 Tasks** tab
2. Tap **"New Task"** to add an assignment
3. Set title, due date, priority, and subject
4. Receive notifications before deadline
5. Mark as complete when done

### **Viewing Timetable**
1. Open **🗓️ Timetable** tab
2. Add classes, exams, or events
3. View week/month view
4. Set reminders for classes

### **Tracking Performance**
1. Enter **📊 Performance Tracker**
2. Add semester results and grades
3. View GPA/CGPA trends
4. See subject-wise analytics

### **Using AI Tools**
1. Go to **🤖 AI Learning** tab
2. **Generate Quiz** – Select notes to create auto-quizzes
3. **Create Flashcards** – AI generates spaced-repetition cards
4. **Get Study Plan** – Receive personalized learning roadmap
5. **Summarize Content** – Auto-generate summaries from notes

### **Document Vault**
1. Tap **📁 Document Vault**
2. Upload certificates, PDFs, or academic documents
3. Organize by category
4. Retrieve anytime offline

### **Explore Opportunities**
1. Visit **🎓 Opportunities Hub**
2. Browse scholarships, internships, hackathons
3. Save to favorites
4. Set reminders for application deadlines

---

## 📊 API & Integration Details

### **Google Gemini API Integration** (`lib/services/gemini_service.dart`)

```dart
// Example: Generate quiz from notes
Future<List<Question>> generateQuiz(String noteContent) async {
  final response = await geminiModel.generateContent([
    Content.text('Generate 5 multiple choice questions from: $noteContent'),
  ]);
  // Parse and return questions
}

// Example: Create flashcards
Future<List<Flashcard>> createFlashcards(String topic) async {
  // AI generates question-answer pairs
}

// Example: Personalized study plan
Future<StudyPlan> generateStudyPlan(List<Subject> subjects) async {
  // AI creates optimized learning schedule
}
```

### **Firebase Collections Schema**

| Collection | Fields | Purpose |
|---|---|---|
| `users` | `uid`, `email`, `name`, `createdAt` | User profiles |
| `notes` | `userId`, `subject`, `chapter`, `content`, `timestamp` | Study notes |
| `tasks` | `userId`, `title`, `dueDate`, `priority`, `completed` | Assignments |
| `timetables` | `userId`, `className`, `dayOfWeek`, `time`, `location` | Schedule |
| `semester_results` | `userId`, `semester`, `subjects`, `grades`, `gpa` | Academic records |
| `flashcards` | `userId`, `question`, `answer`, `difficulty`, `reviews` | Learning cards |
| `calendar_events` | `userId`, `title`, `date`, `type`, `reminder` | Calendar events |
| `qr_codes` | `userId`, `profileData`, `generatedAt` | QR profiles |
| `resumes` | `userId`, `content`, `template`, `updatedAt` | Resume data |
| `portfolio` | `userId`, `projects`, `links`, `descriptions` | Portfolio items |

---

## 🔧 Customization & Configuration

### **Theme Customization** (`lib/theme.dart`)

```dart
// Modify Material Design 3 colors
final lightColorScheme = ColorScheme.fromSeed(
  seedColor: Colors.blue,  // Change primary color
  brightness: Brightness.light,
);

final darkColorScheme = ColorScheme.fromSeed(
  seedColor: Colors.blue,
  brightness: Brightness.dark,
);
```

### **Supported Platforms**

| Platform | Status | Notes |
|---|---|---|
| Android | ✅ Full Support | API 24+ |
| iOS | ✅ Full Support | iOS 12+ |
| Web | ✅ Available | Limited features |
| Windows | ✅ Available | Desktop client |
| macOS | ✅ Available | Desktop client |

---

## 📚 Development Best Practices

### **Code Style**
- Follow [Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable names
- Add dartdoc comments to public APIs
- Keep functions focused and small

### **State Management**
- Use `Provider` for app-wide state
- Keep business logic in services
- Separate UI from business logic

### **Performance Tips**
- Use `const` constructors where possible
- Implement lazy loading for large lists
- Cache API responses appropriately
- Use `ChangeNotifier` sparingly (prefer ValueNotifier)

### **Testing**
```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/
```

### **Firebase Best Practices**
- Index frequently queried fields in Firestore
- Use security rules to prevent unauthorized access
- Monitor Cloud Firestore usage and costs
- Implement offline persistence strategies

---

## 🤝 Contribution Guidelines

We welcome contributions from developers, designers, and students! Whether you're fixing bugs, adding features, or improving documentation, your help is valuable.

### **Before You Start**
1. Check [existing issues](https://github.com/ysathyasai/StudyHub/issues) and [PRs](https://github.com/ysathyasai/StudyHub/pulls)
3. Set up the development environment

### **Contribution Workflow**

1. **Fork the Repository**
   ```bash
   # Fork on GitHub, then clone your fork
   git clone https://github.com/YOUR_USERNAME/StudyHub.git
   cd StudyHub
   ```

2. **Create a Feature Branch**
   ```bash
   git checkout -b feature/add-new-feature
   # or
   git checkout -b bugfix/fix-issue-name
   ```

3. **Make Your Changes**
   - Write clean, well-documented code
   - Test your changes thoroughly
   - Follow the code style guide

4. **Commit Your Changes**
   ```bash
   git add .
   git commit -m "feat: Add new feature description"
   # Use conventional commits: feat:, fix:, docs:, style:, refactor:, test:
   ```

5. **Push to Your Fork**
   ```bash
   git push origin feature/add-new-feature
   ```

6. **Open a Pull Request**
   - Go to the original repository
   - Click **"New Pull Request"**
   - Select your branch and provide a clear description
   - Link any related issues

### **PR Guidelines**
- ✅ One feature/fix per PR
- ✅ Clear, descriptive title and description
- ✅ Tests for new functionality
- ✅ Updated documentation
- ✅ No breaking changes without discussion

### **Code Review Process**
- Maintainers will review your PR within 48 hours
- Address feedback and make requested changes
- Once approved, your PR will be merged

### **Areas for Contribution**
- 🐛 **Bug Fixes** – Report and fix issues
- ✨ **New Features** – Add AI tools, study features
- 📖 **Documentation** – Improve README, add tutorials
- 🎨 **UI/UX** – Design improvements
- 🧪 **Testing** – Add unit and integration tests
- 🌍 **Localization** – Add new languages

---

## 👥 Project Team

| Name | Roll Number | Role |
|---|---|---|
| **[Yejju Sathya Sai](https://github.com/ysathyasai/)** | 23054-AI-051 | Project Developer and Documentation |
| **[Mantol Saketh](https://github.com/saketh-nandu/)** | 23054-AI-027 | Core Developmer |
| **[Ventrapragada Purna Vikas](https://github.com/Purnavikas08/)** | 23054-AI-025 | UI/UX Design & Frontend and Documentation |
| **[Nanduri Eknadha Adithya Srivatsa](https://github.com/adithyasrivatsa/)** | 23054-AI-033 | 🎯 Project Lead & Full-Stack Developer |
| **[Katta Tejeshwar](https://github.com/KattaTejeshwar/)** | 23054-AI-053 | Documentation & DevOps |
| **[Guttapalli Surya Prakash](https://github.com/SuryaGuttapalli/)** | 23054-AI-059 | Mobile Optimization |
| **[Koganti Sai Charan](https://github.com/KOGANTISAICHARAN)** | 23054-AI-062 | API Integration & Backend |
| **[Kara Karthikeya](https://github.com/karakarthikeya26-beep/)** | 23054-AI-023 | App Testing |
| **[Vankodvath Yekeshwar Naik](https://github.com/yekeshwar-naik/)** | 23054-AI-028 | Database & Security |
| **[Neerati Sri Krishna Teja](https://github.com/srikrishnateja55/)** | 23054-AI-055 | Feature Development |

### **Institution**

🏫 **Government Institute of Electronics, Secunderabad**
- Department of Artificial Intelligence & Machine Learning
- Developed as a capstone academic project

---

## 🗓️ Project Roadmap

### **Phase 1: Foundation** ✅ (Completed)
- ✅ Core note-taking system
- ✅ Task management
- ✅ Timetable scheduling
- ✅ Firebase integration
- ✅ Google authentication

### **Phase 2: Intelligence** 🚀 (In Progress)
- 🔄 AI-powered quiz generation
- 🔄 Smart flashcard creation
- 🔄 Personalized study plans
- 🔄 Performance analytics

### **Phase 3: Community** 📅 (Planned)
- 📌 Study group collaboration
- 📌 Peer note sharing
- 📌 Discussion forums
- 📌 Mentorship matching

### **Phase 4: Expansion** 📌 (Future)
- 📌 Mobile offline-first caching
- 📌 Advanced performance analytics
- 📌 Career opportunity integration
- 📌 Multi-language support
- 📌 Dark mode refinements
- 📌 Social features (friend connections, sharing)
- 📌 Subscription-based premium features

## License

This project is licensed under the GNU GPL v3 License - see the [LICENSE](LICENSE) file for details.

If you found any bugs, please creat a [**GitHub Issue**](https://github.com/ysathyasai/StudyHub/issues/)

---

<div align="center">

**Made to help the students productivity**

[![GitHub stars](https://img.shields.io/github/stars/ysathyasai/StudyHub?style=social)](https://github.com/ysathyasai/StudyHub/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/ysathyasai/StudyHub?style=social)](https://github.com/ysathyasai/StudyHub/network)
[![GitHub watchers](https://img.shields.io/github/watchers/ysathyasai/StudyHub?style=social)](https://github.com/ysathyasai/StudyHub/watchers)

</div>

---
