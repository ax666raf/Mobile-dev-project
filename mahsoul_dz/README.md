# 🌾 Mahsoul DZ - Direct Farm-to-Customer Marketplace

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.9.2-blue)
![Dart](https://img.shields.io/badge/Dart-3.0+-blue)
![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Android-green)
![License](https://img.shields.io/badge/License-Private-red)

**Connecting Algerian Farmers Directly with Customers**

[Features](#-features) • [Project Status](#-project-status) • [Documentation](#-documentation) • [Installation](#-installation) • [Architecture](#-architecture)

</div>

---

## 📖 About Mahsoul

**Mahsoul** (محصول - meaning "harvest" in Arabic) is a mobile marketplace that eliminates middlemen, allowing farmers to sell directly to customers. The app features two distinct user experiences:

### 👨‍🌾 For Farmers
- Create farm profiles
- List and manage products
- Track orders and inventory
- View dashboard statistics
- Process customer orders

### 🛒 For Customers
- Browse local farm products
- Search and filter by category
- Add items to cart
- Place orders directly
- Track order status
- Save favorite farms

---

## 🚨 PROJECT STATUS

### Current State: **⚠️ FRONTEND COMPLETE | BACKEND CRITICAL**

| Component | Status | Score |
|-----------|--------|-------|
| **UI/UX Screens** | ✅ Complete | 100% |
| **Navigation** | ✅ Complete | 100% |
| **State Management** | ❌ Provider (needs Bloc/Cubit) | 0% |
| **Database** | ❌ Not Implemented | 0% |
| **Localization** | ❌ Not Implemented | 0% |
| **Backend Logic** | ⚠️ Dummy Data Only | 20% |

**MVP Compliance Score: 35/100** ❌

### Critical Issues:
1. 🔴 **Using Provider instead of required Bloc/Cubit**
2. 🔴 **No database implementation (local or remote)**
3. 🔴 **No localization support (Arabic required)**

**➡️ See [EXECUTIVE_SUMMARY.md](EXECUTIVE_SUMMARY.md) for detailed analysis**

---

## 📋 Features

### ✅ Implemented (UI Complete)
- [x] Onboarding/intro screen
- [x] User role selection (farmer/customer)
- [x] Authentication screens (login/signup)
- [x] Customer marketplace with categories
- [x] Product detail views
- [x] Shopping cart
- [x] Order management
- [x] User profiles (customer & farmer)
- [x] Farmer dashboard with statistics
- [x] Product management for farmers
- [x] Bottom navigation
- [x] Form validation

### ❌ Missing (Backend Critical)
- [ ] Bloc/Cubit state management
- [ ] Local database (SQLite/Drift)
- [ ] Data persistence
- [ ] Real authentication
- [ ] Multi-language support (Arabic/English/French)
- [ ] Offline functionality
- [ ] Backend integration

---

## 📚 Documentation

**START HERE:** 👉 [EXECUTIVE_SUMMARY.md](EXECUTIVE_SUMMARY.md)

### Complete Guides Available:

1. **[EXECUTIVE_SUMMARY.md](EXECUTIVE_SUMMARY.md)**
   - Project overview and status
   - Critical findings
   - Risk assessment
   - Immediate next steps

2. **[docs/QUICK_REFERENCE_GUIDE.md](docs/QUICK_REFERENCE_GUIDE.md)**
   - Top 3 critical fixes
   - Quick code snippets
   - Progress tracker
   - Common mistakes

3. **[docs/PROJECT_AUDIT_AND_IMPLEMENTATION_GUIDE.md](docs/PROJECT_AUDIT_AND_IMPLEMENTATION_GUIDE.md)**
   - Comprehensive project audit
   - Phase-by-phase implementation
   - Complete code templates
   - Database schema
   - 3-week roadmap

4. **[docs/ARCHITECTURE_MIGRATION_GUIDE.md](docs/ARCHITECTURE_MIGRATION_GUIDE.md)**
   - Current vs. target architecture
   - Step-by-step migration
   - Conversion examples
   - Detailed checklist

5. **[docs/DATABASE_SCHEMA.md](docs/DATABASE_SCHEMA.md)**
   - Complete database design
   - Table definitions
   - Relationships
   - Indexes and constraints

6. **[docs/BACKEND_ARCHITECTURE.md](docs/BACKEND_ARCHITECTURE.md)**
   - API design
   - REST endpoints
   - Authentication flow
   - Service architecture

---

## 🚀 Quick Start

### Prerequisites
- Flutter SDK 3.9.2 or higher
- Dart 3.0+
- Android Studio / VS Code
- iOS Simulator / Android Emulator

### Installation

```bash
# Clone the repository
git clone <repository-url>
cd mahsoul_dz

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### ⚠️ Note: App Currently Has Limited Functionality
The app runs with dummy data only. To make it functional, follow the implementation guides.

---

## 🏗️ Architecture

### Current Structure (Needs Migration)
```
lib/
├── assets/           # Images, icons, assets
├── logic/            # ❌ Provider controllers (needs → Cubits)
├── views/
│   ├── models/       # ⚠️ Needs serialization
│   ├── screens/      # ✅ All screens
│   └── widgets/      # ✅ Reusable components
├── utils/            # ✅ Utilities
└── main.dart         # ⚠️ Needs BlocProvider
```

### Target Structure (Required)
```
lib/
├── core/             # Constants, errors, utils
├── data/             # Database, models, repositories
├── domain/           # Entities, repository interfaces
├── presentation/     # Cubits, screens, widgets
├── l10n/             # Localization files
└── main.dart
```

**See [ARCHITECTURE_MIGRATION_GUIDE.md](docs/ARCHITECTURE_MIGRATION_GUIDE.md) for details**

---

## 🛠️ Technology Stack

### Current
- **Framework:** Flutter 3.9.2
- **State Management:** Provider ❌ (must change to Bloc)
- **UI Components:** Custom widgets
- **Fonts:** Google Fonts
- **Icons:** Material Icons + Custom SVG
- **Charts:** FL Chart

### Required (Missing)
- **State Management:** flutter_bloc ❌
- **Database:** Drift (SQLite) ❌
- **Localization:** flutter_localizations ❌
- **Storage:** shared_preferences, flutter_secure_storage ❌

---

## 📦 Dependencies to Add

Copy to `pubspec.yaml`:

```yaml
dependencies:
  # State Management (REQUIRED)
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5
  
  # Database (REQUIRED)
  drift: ^2.14.0
  sqlite3_flutter_libs: ^0.5.18
  path_provider: ^2.1.1
  
  # Localization (REQUIRED)
  flutter_localizations:
    sdk: flutter
  intl: ^0.18.1
  
  # Storage (REQUIRED)
  shared_preferences: ^2.2.2
  flutter_secure_storage: ^9.0.0

dev_dependencies:
  build_runner: ^2.4.7
  drift_dev: ^2.14.0
```

---

## 📱 Screenshots

### Customer Side
- Market browsing with categories
- Product details with reviews
- Shopping cart
- Order tracking

### Farmer Side
- Dashboard with statistics
- Product management
- Order management
- Profile settings

*(Screenshots to be added)*

---

## 🎯 Implementation Roadmap

### Week 1: State Management (Critical)
- [ ] Add flutter_bloc dependency
- [ ] Create Cubit architecture
- [ ] Convert all controllers to Cubits
- [ ] Update UI to use BlocBuilder

### Week 2: Database (Critical)
- [ ] Add Drift dependency
- [ ] Define database schema
- [ ] Create repositories
- [ ] Connect Cubits to database

### Week 3: Localization & Polish
- [ ] Setup flutter_localizations
- [ ] Create ARB files (Arabic, English, French)
- [ ] Extract all strings
- [ ] Testing and bug fixes

**Total Timeline: 3 weeks to MVP**

---

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run with coverage
flutter test --coverage

# Analyze code
flutter analyze
```

---

## 📖 Course Requirements Checklist

- [ ] **State Management:** Bloc/Cubit (currently Provider ❌)
- [ ] **Database:** Local relational DB (not implemented ❌)
- [ ] **Localization:** Multi-language support (not implemented ❌)
- [x] **Screens:** All primary screens implemented ✅
- [x] **Navigation:** Fully connected ✅
- [ ] **Architecture:** Clean Architecture (needs work ⚠️)
- [ ] **Offline Support:** App works offline (not working ❌)

**Current Compliance: 35/100** ❌  
**Target Compliance: 90+/100** ✅

---

## 🤝 Contributing

This is a course project. For implementation:

1. Read [EXECUTIVE_SUMMARY.md](EXECUTIVE_SUMMARY.md)
2. Follow [PROJECT_AUDIT_AND_IMPLEMENTATION_GUIDE.md](docs/PROJECT_AUDIT_AND_IMPLEMENTATION_GUIDE.md)
3. Use provided code templates
4. Test each phase before proceeding
5. Commit frequently with clear messages

---

## 📝 Project Structure

```
mahsoul_dz/
├── android/              # Android platform code
├── ios/                  # iOS platform code
├── lib/                  # Flutter application code
│   ├── assets/          # Images and resources
│   ├── logic/           # Controllers (to be migrated)
│   ├── views/           # UI components
│   ├── utils/           # Utilities
│   └── main.dart        # App entry point
├── docs/                # 📚 Comprehensive documentation
│   ├── PROJECT_AUDIT_AND_IMPLEMENTATION_GUIDE.md
│   ├── QUICK_REFERENCE_GUIDE.md
│   ├── ARCHITECTURE_MIGRATION_GUIDE.md
│   ├── DATABASE_SCHEMA.md
│   └── BACKEND_ARCHITECTURE.md
├── EXECUTIVE_SUMMARY.md # 👈 START HERE
├── pubspec.yaml         # Dependencies
└── README.md           # This file
```

---

## 🆘 Getting Help

### If You're Stuck:

1. **Check Documentation:**
   - Start with [EXECUTIVE_SUMMARY.md](EXECUTIVE_SUMMARY.md)
   - Reference [QUICK_REFERENCE_GUIDE.md](docs/QUICK_REFERENCE_GUIDE.md)
   - Follow step-by-step guides

2. **Common Issues:**
   - Database not working? See DATABASE_SCHEMA.md
   - Cubit confusion? See code templates in guides
   - Architecture unclear? See ARCHITECTURE_MIGRATION_GUIDE.md

3. **External Resources:**
   - [Flutter Bloc Documentation](https://bloclibrary.dev/)
   - [Drift Documentation](https://drift.simonbinder.eu/)
   - [Flutter Localization](https://docs.flutter.dev/ui/accessibility-and-localization/internationalization)

---

## 📄 License

Private project for educational purposes.

---

## 🎓 Academic Information

- **Course:** Mobile Development
- **Institution:** [Your Institution]
- **Semester:** 1st Semester, 3rd Year
- **Project Type:** MVP Mobile Application
- **Platform:** Flutter (iOS/Android)

---

## ⚠️ Important Notice

**This project currently DOES NOT meet MVP requirements.**

**Critical Issues:**
1. Using Provider instead of required Bloc/Cubit
2. No database implementation
3. No localization support

**Action Required:**
Follow the comprehensive guides in the `/docs/` folder to implement missing features.

**Estimated Time to MVP:** 3 weeks with provided guides

---

## 🚀 Next Steps

### Immediate Actions:
1. ✅ Read [EXECUTIVE_SUMMARY.md](EXECUTIVE_SUMMARY.md) (10 minutes)
2. ✅ Review [QUICK_REFERENCE_GUIDE.md](docs/QUICK_REFERENCE_GUIDE.md) (15 minutes)
3. ✅ Start Week 1 implementation from [PROJECT_AUDIT_AND_IMPLEMENTATION_GUIDE.md](docs/PROJECT_AUDIT_AND_IMPLEMENTATION_GUIDE.md)

### This Week:
1. Add required dependencies
2. Create new folder structure
3. Begin Bloc/Cubit migration
4. Daily commits

**Don't wait. Start today. You have everything you need to succeed.** 🚀

---

<div align="center">

**Made with ❤️ for connecting farmers and customers**

[Report Bug](https://github.com/yourusername/mahsoul_dz/issues) • [Request Feature](https://github.com/yourusername/mahsoul_dz/issues)

</div>
