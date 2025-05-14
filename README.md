# Dyota

A Flutter-based e-commerce application with Firebase backend integration, designed for showcasing textile products with category-based browsing and detailed product views. The codebase employs clean architecture principles for maintainable, testable code with clear separation of concerns.

## Project Overview

Dyota is structured around several main feature areas:

- **Home**: Product discovery with categorized displays and featured items
- **Category**: Filtered browsing with subcategory selection and sorting capabilities 
- **Product Detail**: In-depth product information with specifications and imagery
- **Authentication**: User registration, login, and password recovery
- **Shopping Experience**: Shopping bag, checkout process, and payment handling
- **User Profile**: Account management and personal information
- **Orders**: Order history and detailed order information
- **Search**: Product search functionality with filtering options
- **Shipping**: Address management and selection

The application follows a component-based architecture with state management utilizing Flutter's ChangeNotifier pattern, along with dependency injection for loose coupling between components. Each major feature area is organized in its own directory with dedicated components, data models, and service classes.

## Technical Architecture

### State Management

The application implements a custom state management approach based on the following principles:

- **Data Classes**: Immutable models using [ChangeNotifier](https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html) for state
  ```dart
  class CategoryData with ChangeNotifier {
    final String _categoryDocumentId;
    String _categoryName = '';
    List<String> _subCategories = [];
    
    // Immutable getters
    String get categoryDocumentId => _categoryDocumentId;
    String get categoryName => _categoryName;
    List<String> get subCategories => List.unmodifiable(_subCategories);
    
    // Methods to update state
    void updateCategoryName(String name) {
      if (_disposed) return;
      _categoryName = name;
      notifyListeners();
    }
  }
  ```

- **Loading State Management**: Dedicated classes to handle loading states
  ```dart
  class CategoryLoadingState with ChangeNotifier {
    bool _isLoading = true;
    bool _isSubCategoriesLoading = false;
    bool _isProductListLoading = false;
    
    bool get anyComponentLoading =>
        _isLoading || _isSubCategoriesLoading || _isProductListLoading;
  }
  ```

- **Data Providers**: Classes that coordinate between data and UI
  ```dart
  class CategoryDataProvider with ChangeNotifier {
    final CategoryData _categoryData;
    final CategoryLoadingState _loadingState;
    final FirestoreService _firestoreService;
    
    // Methods for data fetching and manipulation
    Future<void> fetchItems({String sortOption = 'Sort'}) async {
      // Implementation
    }
  }
  ```

### Immutable Data Architecture

The application minimizes state mutation through:

- **[Unmodifiable Collections](https://api.flutter.dev/flutter/dart-core/List/unmodifiable.html)**: Prevents external modification of internal state
  ```dart
  List<String> get subCategories => List.unmodifiable(_subCategories);
  ```

- **Defensive Copying**: Creates new instances when updating collections
  ```dart
  void updateSubCategories(List<String> categories) {
    _subCategories = List.from(categories);
    notifyListeners();
  }
  ```

- **Explicit State Updates**: Clear methods for state changes rather than direct mutation

### Component-Based UI Architecture

UI components are designed with:

- **Single Responsibility**: Each widget has a focused purpose
- **Clear Interfaces**: Props and callbacks are explicitly defined
- **Composition**: Complex UIs built from simpler components

Example component structure:
```dart
class ProductListItem extends StatefulWidget {
  final String documentId;
  final Function(bool)? onLoadingChanged;
  
  // Component implementation
}
```

### Asynchronous Data Flow

The application handles asynchronous operations with:

- **[Future-based APIs](https://dart.dev/codelabs/async-await)**: Clear async boundaries
- **Loading State Management**: Explicit loading states for UI feedback
- **Error Handling**: Structured approach to error management with logging

## Firebase Integration

### Firestore Database

The application uses [Firestore](https://firebase.google.com/docs/firestore) for data storage with the following collections:

- **categories**: Product categorization and hierarchy
- **items**: Product information with detailed specifications

Example Firestore query:
```dart
QuerySnapshot querySnapshot = await _firestore
    .collection(collectionName)
    .where('category.value', isEqualTo: categoryName)
    .where('subCategory.value', whereIn: subCategoryList)
    .get();
```

### Firebase Storage

[Firebase Storage](https://firebase.google.com/docs/storage) is used for product imagery with structured paths:

```dart
String url = await FirebaseStorage.instance.ref(path).getDownloadURL();
```

## Directory Structure

```
dyota/
├── android/         # Android platform-specific code
├── assets/          # Static assets like images and fonts
│   ├── fonts/       # Typography assets including Lato
│   └── images/      # Static image assets
├── ios/             # iOS platform-specific code
├── lib/
│   ├── components/  # Shared UI components
│   │   ├── generic_appbar.dart           # Common app bar component
│   │   └── [other shared components]
│   ├── models/      # Data models and interfaces
│   ├── services/    # Service layer for external APIs
│   └── pages/       # Feature-specific code
│       ├── Authentication/       # Authentication management
│       ├── Category/             # Category browsing feature
│       │   ├── category_page.dart        # Main category page
│       │   └── Components/               # Category-specific components
│       │       ├── category_button.dart  # Selection UI component
│       │       ├── category_data.dart    # Category state model
│       │       ├── category_data_provider.dart # State management
│       │       ├── category_loading_state.dart # Loading state management
│       │       ├── firestore_service.dart      # Firebase interactions
│       │       ├── product_item_data.dart      # Product state model
│       │       ├── product_list_item.dart      # Product grid component
│       │       ├── sort_button.dart            # Sorting UI component
│       │       └── sub_category_list.dart      # Subcategory UI component
│       ├── Checkout/             # Checkout process
│       ├── Forgot_Password/      # Password recovery
│       ├── Home/                 # Home page feature
│       │   ├── home_page.dart            # Main home page
│       │   └── Components/               # Home-specific components
│       │       ├── app_bar_component.dart       # Home app bar
│       │       ├── cart_data.dart               # Cart state model
│       │       ├── cart_data_provider.dart      # Cart state management
│       │       ├── category_grid_component.dart # Category display
│       │       ├── item_card_data.dart          # Item card model
│       │       ├── loading_state.dart           # Loading management
│       │       └── product_grid_component.dart  # Product grid
│       ├── Login/                # User login
│       ├── Login_Or_Register/    # Auth selection page
│       ├── My_Bag/               # Shopping bag management
│       ├── My_Orders/            # Order history
│       ├── Order_Detail/         # Specific order information
│       ├── Payment/              # Payment processing
│       ├── Product_Card/         # Product detail feature
│       │   ├── product_card.dart         # Product detail page
│       │   └── Components/               # Product-specific components
│       │       ├── product_data.dart           # Product state model
│       │       └── product_loading_state.dart  # Loading state management
│       ├── Profile/              # User profile management
│       ├── Register/             # New user registration
│       ├── Search/               # Product search functionality
│       └── Select_Shipping_Address/ # Address selection
├── macos/           # macOS platform-specific code
├── test/            # Test files
│   ├── unit/        # Unit tests
│   ├── widget/      # Widget tests
│   └── integration/ # Integration tests
├── web/             # Web platform-specific code
└── windows/         # Windows platform-specific code
```

## Key Features

### Category Browsing

- **Subcategory Filtering**: Allow users to filter products by subcategories
- **Sorting Options**: Sort products by price (high to low or low to high)
- **Loading States**: Visual feedback during data loading
- **Empty State Handling**: Clear messaging when no products match filters

### Product Display

- **Grid Layout**: Responsive grid of product cards
- **Lazy Loading**: Load products as needed for performance
- **Image Caching**: Optimize image loading for better UX

### Product Detail

- **Detailed Information**: Comprehensive product details
- **Multiple Images**: Support for product galleries
- **Related Products**: Suggestions for similar items

## Development Setup

### Prerequisites

- Flutter SDK (2.0.0 or higher)
- Dart SDK (2.12.0 or higher)
- Android Studio or VS Code with Flutter extensions
- Firebase project with Firestore and Storage enabled

### Setup Steps

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/dyota.git
   cd dyota
   ```

2. Install dependencies:
   ```
   flutter pub get
   ```

3. Create Firebase configuration:
   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Add Android and iOS apps to your Firebase project
   - Download `google-services.json` for Android and `GoogleService-Info.plist` for iOS
   - Place these files in the appropriate directories (they're gitignored)
   - Generate `firebase_options.dart` using FlutterFire CLI

4. Run the application:
   ```
   flutter run
   ```

## Code Standards

### Naming Conventions

- **Classes**: PascalCase (e.g., `CategoryButton`)
- **Variables/Methods**: camelCase (e.g., `categoryName`)
- **Private Members**: Prefix with underscore (e.g., `_isLoading`)
- **Constants**: SCREAMING_SNAKE_CASE or camelCase depending on scope

### Code Organization

- **Single Responsibility**: Each class should have one responsibility
- **Immutability**: Prefer immutable state when possible
- **Dependency Injection**: Pass dependencies rather than creating them
- **Logging**: Use structured logging with appropriate severity levels

### Error Handling

- **Graceful Degradation**: UI should handle errors without crashing
- **User Feedback**: Provide clear error messages to users
- **Logging**: Log errors with context for debugging

## Testing

The project supports three types of tests:

- **Unit Tests**: For logic and state management classes
- **Widget Tests**: For component rendering and behavior
- **Integration Tests**: For feature flows and Firebase interaction

## Continuous Integration

- GitHub Actions for automated testing and linting
- Firebase Test Lab for device testing

## Contributing

### Getting Started

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Implement your changes following the code standards
4. Add tests for your changes
5. Update documentation as needed
6. Commit your changes (`git commit -m 'Add some amazing feature'`)
7. Push to the branch (`git push origin feature/amazing-feature`)
8. Open a Pull Request

### Pull Request Guidelines

- Keep PRs focused on a single feature or bug fix
- Include tests for new functionality
- Update documentation as needed
- Link related issues
- Follow code style guidelines

## Libraries Used

- **[Firebase Firestore](https://firebase.google.com/docs/firestore)**: NoSQL database for product and category data
- **[Firebase Storage](https://firebase.google.com/docs/storage)**: Image storage and retrieval
- **[Provider](https://pub.dev/packages/provider)**: Dependency injection and state management helpers
- **[Logger](https://pub.dev/packages/logging)**: Structured logging with severity levels
- **[Lato Font](https://fonts.google.com/specimen/Lato)**: Primary typography

## Future Enhancements

- User authentication and profile management
- Shopping cart functionality
- Order processing and history
- Advanced search functionality
- Localization support
- Dark mode theme

## License

This project is licensed under the MIT License - see the LICENSE file for details.
