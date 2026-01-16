# Horizon Attendance

A professional Flutter mobile application for employee attendance management with a clean, modern design system.

## 🎨 Design System

### Color Palette

#### Primary Colors
- **Primary**: `#0A2A66` (Dark Blue) - Main brand color
- **Primary Light**: `#1A3A76` - Lighter variant
- **Primary Dark**: `#051A46` - Darker variant

#### Secondary Colors
- **Secondary**: `#F5F6FA` (Light Gray) - Background accents
- **Secondary Light**: `#FFFFFF` - White
- **Secondary Dark**: `#E5E6EA` - Darker gray variant

#### Background Colors
- **Background**: `#FFFFFF` (White) - Main background
- **Surface**: `#FFFFFF` - Card/surface background
- **Surface Variant**: `#F5F6FA` - Alternate surface

#### Text Colors
- **Text Primary**: `#0A2A66` - Main text
- **Text Secondary**: `#6B7280` - Secondary text
- **Text Tertiary**: `#9CA3AF` - Placeholder/disabled text
- **Text On Primary**: `#FFFFFF` - Text on primary color

#### Utility Colors
- **Success**: `#10B981` - Green
- **Error**: `#EF4444` - Red
- **Warning**: `#F59E0B` - Orange
- **Info**: `#3B82F6` - Blue

### Typography

The app uses **Inter** font family from Google Fonts, a modern sans-serif typeface.

#### Text Styles
- **h1**: 32px, Bold, -0.5 letterSpacing
- **h2**: 28px, Bold, -0.4 letterSpacing
- **h3**: 24px, SemiBold (w600), -0.3 letterSpacing
- **h4**: 20px, SemiBold (w600), -0.2 letterSpacing
- **bodyLarge**: 18px, Normal
- **bodyMedium**: 16px, Normal
- **bodySmall**: 14px, Normal
- **labelLarge**: 16px, Medium (w500)
- **labelMedium**: 14px, Medium (w500)
- **labelSmall**: 12px, Medium (w500)
- **button**: 16px, SemiBold (w600), 0.2 letterSpacing
- **buttonSmall**: 14px, SemiBold (w600), 0.2 letterSpacing
- **caption**: 12px, Normal

### Components

#### Buttons

The design system includes a reusable `AppButton` widget with:

**Button Types:**
- `primary` - Solid dark blue background
- `secondary` - Light gray background
- `outlined` - Transparent with dark blue border
- `text` - Text-only button

**Button Sizes:**
- `small` - Compact padding (16x10)
- `medium` - Standard padding (24x14)
- `large` - Generous padding (32x18)

**Features:**
- Icon support
- Loading states
- Full-width option
- Rounded corners (12px radius)

**Usage:**
```dart
AppButton(
  text: 'Check In',
  type: ButtonType.primary,
  size: ButtonSize.medium,
  icon: Icons.login,
  fullWidth: true,
  isLoading: false,
  onPressed: () {},
)
```

#### Cards

The `AppCard` widget provides:
- Rounded corners (12px radius)
- Minimal shadows (elevation 2)
- Customizable padding
- Optional tap handling

**Usage:**
```dart
AppCard(
  padding: EdgeInsets.all(16),
  onTap: () {},
  child: YourWidget(),
)
```

### Design Principles

1. **Clean & Professional** - White backgrounds with minimal, purposeful use of color
2. **Modern Sans-Serif** - Inter font for clean, readable typography
3. **Rounded Corners** - 12px border radius for buttons and cards
4. **Minimal Shadows** - Subtle elevation (2-3px) for depth
5. **Consistent Spacing** - 8px base unit for padding and margins
6. **Clear Hierarchy** - Well-defined text styles for different content levels

## 📁 Project Structure

```
lib/
├── core/
│   ├── theme/
│   │   ├── app_colors.dart       # Color palette
│   │   ├── app_text_styles.dart  # Typography system
│   │   └── app_theme.dart        # Theme configuration
│   └── widgets/
│       ├── app_button.dart       # Reusable button component
│       └── app_card.dart         # Reusable card component
└── main.dart                     # App entry point with demo UI
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- iOS Simulator / Android Emulator / Physical Device

### Installation

1. Clone the repository
2. Navigate to project directory:
   ```bash
   cd /Users/mac/Documents/gascoba.db/freeeeeee/absen
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Run the app:
   ```bash
   flutter run
   ```

## 🎯 Features

- ✅ Clean, professional UI design
- ✅ Complete design system with reusable components
- ✅ Modern typography with Google Fonts (Inter)
- ✅ Consistent color palette
- ✅ Reusable button component with multiple variants
- ✅ Card component with minimal shadows
- ✅ Fully documented design tokens

## 📦 Dependencies

- `google_fonts: ^6.2.1` - Modern typography with Inter font
- `cupertino_icons: ^1.0.8` - iOS-style icons

## 🎨 Design System Usage

### Accessing Colors
```dart
import 'package:horizon_attendance/core/theme/app_colors.dart';

Container(
  color: AppColors.primary,
  child: Text(
    'Hello',
    style: TextStyle(color: AppColors.textOnPrimary),
  ),
)
```

### Accessing Text Styles
```dart
import 'package:horizon_attendance/core/theme/app_text_styles.dart';

Text(
  'Welcome',
  style: AppTextStyles.h1,
)
```

### Using Theme
```dart
import 'package:horizon_attendance/core/theme/app_theme.dart';

MaterialApp(
  theme: AppTheme.lightTheme,
  home: HomePage(),
)
```

## 📝 License

This project is created for employee attendance management.

## 👨‍💻 Development

To extend the design system:

1. **Adding New Colors**: Update `lib/core/theme/app_colors.dart`
2. **Adding New Text Styles**: Update `lib/core/theme/app_text_styles.dart`
3. **Adding New Components**: Create new files in `lib/core/widgets/`
4. **Modifying Theme**: Update `lib/core/theme/app_theme.dart`

---

**Horizon Attendance** - Clean, Professional, Modern
