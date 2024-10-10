# Dyota Mobile Application

## Overview

Dyota is a mobile application built using Flutter and Firebase. It provides a seamless shopping experience with features like user authentication, product browsing, cart management, order tracking, and more.

## Table of Contents

- [Installation](#installation)
- [Features](#features)
- [Usage](#usage)

## AuthPage

### Overview

The `AuthPage` is a stateless widget that serves as the authentication entry point for the application. It utilizes Firebase Authentication to manage user sessions and Firestore to store user-related data. The page dynamically updates based on the user's authentication state, providing a seamless experience for both logged-in and unauthenticated users.

### Features

- **Real-time Authentication State Monitoring**: The `AuthPage` listens for changes in the user's authentication state using Firebase's `authStateChanges()` stream.
- **User Record Management**: Automatically checks if a user record exists in Firestore upon login and creates one if it does not, ensuring that user data is initialized correctly.
- **Navigation**: Redirects users to the appropriate page based on their authentication status—either the home page for logged-in users or the login/registration page for unauthenticated users.

## HomePage

### Overview

The `HomePage` class is a stateless widget that serves as the main interface for users after logging in. It displays categories and best-selling products, integrating with Firestore to fetch relevant data.

### Features

- **Dynamic Content**: Displays items marked to be shown on the home page.
- **Firestore Integration**: Queries the `items` collection to retrieve document IDs based on the `isShownOnHomePage` field.
- **User Navigation**: Provides a bottom navigation bar for easy access to the home page, shopping bag, and user profile.

### Methods

#### `Future<List<String>> getDocumentIdsShownOnHomePage()`

- Fetches document IDs from Firestore where `isShownOnHomePage` is set to 1.
- Returns a list of document IDs.

#### `void _onItemTapped(BuildContext context, int index)`

- Handles navigation based on the tapped index in the bottom navigation bar.
- Navigates to the `HomePage`, `MyBag`, or `ProfileScreen`.

#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `HomePage`.
- Utilizes a `FutureBuilder` to manage asynchronous data fetching.
- Displays loading indicators, error messages, or the main content based on the data state.

## CustomBottomNavigationBar

### Overview

The `CustomBottomNavigationBar` class is a stateless widget that provides a customizable bottom navigation bar for the application. It allows users to navigate between different sections of the app, such as Home, Bag, and Profile.

### Features

- **Dynamic Selection**: Highlights the currently selected item based on the `selectedIndex` parameter.
- **Customizable Callback**: Accepts a callback function `onItemTapped` to handle navigation when an item is tapped.
- **Consistent Design**: Uses a fixed type bottom navigation bar with a black background and white icons for a cohesive look.

### Constructor

- **Parameters**:
  - `selectedIndex`: An integer representing the currently selected index of the navigation items.
  - `onItemTapped`: A function that takes an integer as an argument, used to handle item tap events.

### Build Method

- Constructs the `BottomNavigationBar` widget with:
  - A black background color.
  - White color for selected items and a lighter shade for unselected items.
  - Three fixed items: Home, Bag, and Profile, each represented by an icon and a label.
  - The `currentIndex` is set to the value of `selectedIndex`, ensuring the correct item is highlighted.
  - The `onTap` property is linked to the `onItemTapped` function to facilitate navigation.

## CategoryGrid

### Overview

The `CategoryGrid` class is a stateless widget that displays a grid of categories fetched from Firestore. It utilizes a `FutureBuilder` to handle asynchronous data retrieval and dynamically updates the UI based on the data state.

### Features

- **Data Fetching**: Retrieves category documents from the Firestore `categories` collection.
- **Dynamic UI**: Displays categories in a grid format, adjusting based on the number of documents retrieved.
- **Error Handling**: Manages loading states, errors, and empty data scenarios gracefully.

### Methods

#### `Future<List<DocumentSnapshot>> getCategoryDocuments()`

- Fetches category documents from Firestore and returns a list of `DocumentSnapshot` objects.

#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `CategoryGrid`.
- Uses a `FutureBuilder` to manage the asynchronous fetching of category data.
- Displays a loading indicator while data is being fetched.
- Handles errors and empty data cases, logging relevant information.
- Renders a grid of `CategoryItem` widgets based on the retrieved category documents.

## BestSellerHeader

### Overview

The `BestSellerHeader` class is a stateless widget that displays a header for the best-selling products section of the application.

### Features

- **Static Header**: Displays a fixed title "Best Sellers" to indicate the section of best-selling products.
- **Custom Styling**: Utilizes a specific font family, size, weight, and color.

### Methods

#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `BestSellerHeader`.

## CustomAppBar

### Overview

The `CustomAppBar` class is a stateless widget that implements a custom application bar for the app. It includes a title and a search field, providing a user-friendly interface for navigation and search functionality.

### Features

- **Customizable Appearance**: The app bar has a black background and is designed to fit the overall theme of the application.
- **Search Functionality**: Includes a text field for user input, allowing users to search for items within the app.
- **Dynamic Height**: The height of the app bar is adjustable, accommodating additional elements as needed.

### Methods

#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `CustomAppBar`.
- Utilizes a `TextEditingController` to manage the input for the search field.
- Organizes the layout using a `Column` to evenly distribute space between the title and the search field.
- The search field includes:
  - A hint text prompting the user to enter a search query.
  - A search icon for visual indication.
  - An `onSubmitted` callback that navigates to the `SearchPage` with the user's query when the search is submitted.

#### `@override Size get preferredSize`

- Returns the preferred size of the app bar, which is set to accommodate the standard toolbar height plus additional space for the custom elements.

## SearchPage

### Overview

The `SearchPage` class is a stateful widget that provides a user interface for searching items within the application. It allows users to input search queries and displays the results in a grid format.

### Features

- **Dynamic Search Functionality**: Users can enter search queries, and the results are fetched and displayed in real-time.
- **Loading Indicator**: Displays a loading spinner while search results are being fetched.
- **Error Handling**: Manages potential errors during the search process gracefully.

### Constructor

- **Parameters**:
  - `searchInput`: A string that initializes the search field with a predefined query.

### State Management

#### `_SearchPageState`

- **Attributes**:
  - `searchResults`: A list of tuples containing search results, where each tuple holds a priority and a document ID.
  - `isLoading`: A boolean indicating whether the search results are currently being loaded.
  - `searchController`: A `TextEditingController` for managing the input in the search field.

#### `initState()`

- Initializes the `searchController` with the provided `searchInput` and triggers the search operation.

#### `Future<void> _performSearch()`

- Executes the search based on the current input in the search field.
- Updates the `isLoading` state to reflect the search status.
- Fetches search results asynchronously and updates the state accordingly.

### Build Method

#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `SearchPage`.
- Contains a `Scaffold` with:
  - A custom app bar displaying the title "Search Results".
  - A search input field styled with rounded corners and a search icon.
  - A body that displays either a loading indicator, a message for no results found, or the grid view of search results.

#### `Widget buildGridView()`

- Constructs a grid view to display the search results.
- Uses a `GridView.builder` to create a grid layout based on the number of search results.

### Helper Class

#### `Tuple<T1, T2>`

- A simple helper class to represent a tuple containing two items, used to store search result priorities and document IDs.

### Search Function

#### `Future<List<Tuple<int, String>>> search(String query)`

- Searches the Firestore `items` collection for documents matching the provided query.
- Converts the query to lowercase for case-insensitive matching.
- Iterates through each document and checks if any field matches the query, assigning a priority based on the match type.
- Returns a sorted list of matching document IDs based on their priority.

## CategoryHeader

### Overview

The `CategoryHeader` class is a stateless widget that displays a header for the categories section of the application.

### Features

- **Static Header**: Displays a fixed title "Categories" to indicate the section for category listings.
- **Custom Styling**: Utilizes a specific font family, size, weight, and color.

### Methods

#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `CategoryHeader`.
- Uses padding to create space around the text.

## ProductGrid

### Overview

The `ProductGrid` class is a stateless widget that displays a grid of products based on a list of document IDs. It utilizes a `GridView` to present the products.

### Features

- **Dynamic Product Display**: Renders a grid of products using the provided document IDs.
- **Logging**: Implements logging to track the building process of the grid and individual product items.

### Constructor

- **Parameters**:
  - `documentIds`: A list of strings representing the document IDs of the products to be displayed.

### Methods

#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `ProductGrid`.
- Logs the number of items being built for the grid.
- Utilizes a `GridView.builder` to create a grid layout with:
  - **Non-scrollable**: The grid is set to not scroll, allowing it to fit within its parent widget.
  - **Dynamic Item Count**: The number of items displayed is based on the length of the `documentIds` list.
  - **Grid Delegate**: Configures the grid to have a fixed number of columns (2) and specified spacing between items.
  - **Item Builder**: For each item, it logs the document ID being processed and returns a `ProductListItem` widget wrapped in padding for spacing.

## CategoryItem

### Overview

The `CategoryItem` class is a stateless widget that represents an individual category item in the application. It fetches category data from Firestore and displays the category image and name. When tapped, it navigates to the corresponding category page.

### Features

- **Dynamic Data Fetching**: Retrieves category names, image file names, and document IDs from Firestore.
- **Image Handling**: Fetches the download URL for category images stored in Firebase Storage.
- **User Interaction**: Allows users to tap on a category item to navigate to the respective category page.

### Constructor

- **Parameters**:
  - `index`: An integer representing the index of the category item, used to access specific category data.

### Methods

#### `Future<String> getImageUrl(String imageName)`

- Fetches the download URL for a category image from Firebase Storage.
- Returns the URL as a string.

#### `Future<List<Map<String, String>>> getCategoryData()`

- Fetches category data from Firestore, including category names, image file names, and document IDs.
- Returns a list of maps containing the category data.

#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `CategoryItem`.
- Utilizes a `FutureBuilder` to manage asynchronous data fetching for category data.
- Handles various states of the data fetching process:
  - Displays nothing while waiting for data.
  - Throws an exception if an error occurs during data fetching.
  - Logs a warning and displays nothing if no data is found.
- If data is available, it fetches the image URL using another `FutureBuilder`:
  - Displays a loading indicator while fetching the image.
  - Throws an exception if an error occurs while fetching the image.
  - Logs a warning if no image is found.
- If the image URL is successfully retrieved, it displays the image and category name in a column layout:
  - The image is wrapped in a `GestureDetector` to handle taps, navigating to the `CategoryPage` with the corresponding document ID.
  - Includes spacing between the image and text for better visual separation.

## CategoryPage

### Overview

The `CategoryPage` class is a stateful widget that displays a specific category of items within the application. It allows users to view subcategories, sort items, and select categories to filter the displayed items. The page fetches data from Firestore and updates the UI based on user interactions.

### Features

- **Dynamic Data Fetching**: Retrieves category data, including subcategories and items, from Firestore.
- **Sorting Options**: Provides users with the ability to sort items by price in ascending or descending order.
- **User Interaction**: Allows users to select categories and view items based on their selections.

### Constructor

- **Parameters**:
  - `categoryDocumentId`: A string representing the document ID of the category to be displayed.

## State Management

#### `_CategoryPageState`

- **Attributes**:
  - `isGridView`: A boolean indicating whether the items should be displayed in a grid view.
  - `selectedCategories`: A list of strings representing the categories selected by the user.
  - `selectedSortOption`: A string representing the currently selected sorting option.
  - `categoryName`: A string for the name of the category.
  - `subCategories`: A list of strings for the subcategories under the main category.
  - `itemDocumentIds`: A list of strings for the document IDs of the items to be displayed.
  - `isLoading`: A boolean indicating whether data is currently being loaded.

#### `initState()`

- Initializes the state and fetches category data when the widget is first created.
- Logs the initialization process and handles any errors that occur during data fetching.

#### `_selectCategory(String category)`

- Updates the selected categories based on user interaction.
- Fetches items again after updating the selected categories.

#### `_showSortOptions(BuildContext context)`

- Displays a modal bottom sheet with sorting options for the user to select.

#### `_buildSortOptions(BuildContext context)`

- Constructs a list of sorting options for the modal bottom sheet.

#### `_buildSortOption(BuildContext context, String option)`

- Creates a list tile for each sorting option, allowing the user to select it and fetch items accordingly.

#### `_fetchCategoryData()`

- Asynchronously fetches category data from Firestore, including the category name and subcategories.
- Updates the state with the fetched data and logs the success or failure of the operation.

#### `_fetchItems({String sortOption = 'Sort'})`

- Asynchronously fetches item document IDs based on the selected categories and category name.
- Sorts the items based on the selected sorting option and updates the state with the sorted item IDs.

#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `CategoryPage`.
- Displays a loading indicator while data is being fetched.
- Contains a `Scaffold` with:
  - A custom app bar displaying the category name.
  - A scrollable column containing:
    - A list of subcategories.
    - A sort button to trigger sorting options.
    - A grid view of items or a loading indicator based on the loading state.

#### `Widget buildGridView()`

- Constructs a grid view to display the items based on the fetched document IDs.
- Returns an empty text widget if there are no items to display.
