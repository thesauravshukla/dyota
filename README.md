- [Dyota Mobile Application](#dyota-mobile-application)
   * [Overview](#overview)
   * [AuthPage](#authpage)
      + [Overview](#overview-1)
      + [Features](#features)
   * [HomePage](#homepage)
      + [Overview](#overview-2)
      + [Features](#features-1)
      + [Methods](#methods)
         - [`Future<List<String>> getDocumentIdsShownOnHomePage()`](#futureliststring-getdocumentidsshownonhomepage)
         - [`void _onItemTapped(BuildContext context, int index)`](#void-_onitemtappedbuildcontext-context-int-index)
         - [`@override Widget build(BuildContext context)`](#override-widget-buildbuildcontext-context)
   * [CustomBottomNavigationBar](#custombottomnavigationbar)
      + [Overview](#overview-3)
      + [Features](#features-2)
      + [Constructor](#constructor)
      + [Build Method](#build-method)
   * [CategoryGrid](#categorygrid)
      + [Overview](#overview-4)
      + [Features](#features-3)
      + [Methods](#methods-1)
         - [`Future<List<DocumentSnapshot>> getCategoryDocuments()`](#futurelistdocumentsnapshot-getcategorydocuments)
         - [`@override Widget build(BuildContext context)`](#override-widget-buildbuildcontext-context-1)
   * [BestSellerHeader](#bestsellerheader)
      + [Overview](#overview-5)
      + [Features](#features-4)
      + [Methods](#methods-2)
         - [`@override Widget build(BuildContext context)`](#override-widget-buildbuildcontext-context-2)
   * [CustomAppBar](#customappbar)
      + [Overview](#overview-6)
      + [Features](#features-5)
      + [Methods](#methods-3)
         - [`@override Widget build(BuildContext context)`](#override-widget-buildbuildcontext-context-3)
         - [`@override Size get preferredSize`](#override-size-get-preferredsize)
   * [SearchPage](#searchpage)
      + [Overview](#overview-7)
      + [Features](#features-6)
      + [Constructor](#constructor-1)
      + [State Management](#state-management)
         - [`_SearchPageState`](#_searchpagestate)
         - [`initState()`](#initstate)
         - [`Future<void> _performSearch()`](#futurevoid-_performsearch)
      + [Build Method](#build-method-1)
         - [`@override Widget build(BuildContext context)`](#override-widget-buildbuildcontext-context-4)
         - [`Widget buildGridView()`](#widget-buildgridview)
      + [Helper Class](#helper-class)
         - [`Tuple<T1, T2>`](#tuplet1-t2)
      + [Search Function](#search-function)
         - [`Future<List<Tuple<int, String>>> search(String query)`](#futurelisttupleint-string-searchstring-query)
   * [CategoryHeader](#categoryheader)
      + [Overview](#overview-8)
      + [Features](#features-7)
      + [Methods](#methods-4)
         - [`@override Widget build(BuildContext context)`](#override-widget-buildbuildcontext-context-5)
   * [ProductGrid](#productgrid)
      + [Overview](#overview-9)
      + [Features](#features-8)
      + [Constructor](#constructor-2)
      + [Methods](#methods-5)
         - [`@override Widget build(BuildContext context)`](#override-widget-buildbuildcontext-context-6)
   * [CategoryItem](#categoryitem)
      + [Overview](#overview-10)
      + [Features](#features-9)
      + [Constructor](#constructor-3)
      + [Methods](#methods-6)
         - [`Future<String> getImageUrl(String imageName)`](#futurestring-getimageurlstring-imagename)
         - [`Future<List<Map<String, String>>> getCategoryData()`](#futurelistmapstring-string-getcategorydata)
         - [`@override Widget build(BuildContext context)`](#override-widget-buildbuildcontext-context-7)
   * [CategoryPage](#categorypage)
      + [Overview](#overview-11)
      + [Features](#features-10)
      + [Constructor](#constructor-4)
      + [State Management](#state-management-1)
         - [`_CategoryPageState`](#_categorypagestate)
         - [`initState()`](#initstate-1)
         - [`_selectCategory(String category)`](#_selectcategorystring-category)
         - [`_showSortOptions(BuildContext context)`](#_showsortoptionsbuildcontext-context)
         - [`_buildSortOptions(BuildContext context)`](#_buildsortoptionsbuildcontext-context)
         - [`_buildSortOption(BuildContext context, String option)`](#_buildsortoptionbuildcontext-context-string-option)
         - [`_fetchCategoryData()`](#_fetchcategorydata)
         - [`_fetchItems({String sortOption = 'Sort'})`](#_fetchitemsstring-sortoption-sort)
         - [`@override Widget build(BuildContext context)`](#override-widget-buildbuildcontext-context-8)
         - [`Widget buildGridView()`](#widget-buildgridview-1)
   * [ProductListItem](#productlistitem)
      + [Overview](#overview-12)
      + [Features](#features-11)
      + [Constructor](#constructor-5)
      + [Methods](#methods-7)
         - [`Future<Map<String, dynamic>> fetchProductData()`](#futuremapstring-dynamic-fetchproductdata)
         - [`Future<String> getImageUrl(String path)`](#futurestring-getimageurlstring-path)
         - [`@override Widget build(BuildContext context)`](#override-widget-buildbuildcontext-context-9)
         - [`Widget buildProductCard(String imageUrl, Map<String, dynamic> data)`](#widget-buildproductcardstring-imageurl-mapstring-dynamic-data)
   * [genericAppbar](#genericappbar)
      + [Overview](#overview-13)
      + [Features](#features-12)
      + [Constructor](#constructor-6)
      + [Methods](#methods-8)
         - [`@override Widget build(BuildContext context)`](#override-widget-buildbuildcontext-context-10)
         - [`@override Size get preferredSize`](#override-size-get-preferredsize-1)
   * [LoginOrRegisterPage](#loginorregisterpage)
      + [Overview](#overview-14)
      + [Features](#features-13)
      + [Constructor](#constructor-7)
      + [State Management](#state-management-2)
         - [`_LoginOrRegisterPageState`](#_loginorregisterpagestate)
         - [`void togglePages()`](#void-togglepages)
   * [Build Method](#build-method-2)
         - [`@override Widget build(BuildContext context)`](#override-widget-buildbuildcontext-context-11)
   * [LoginPage](#loginpage)
      + [Overview](#overview-15)
      + [Features](#features-14)
      + [Constructor](#constructor-8)
      + [State Management](#state-management-3)
         - [`_LoginPageState`](#_loginpagestate)
         - [`void signUserIn()`](#void-signuserin)
   * [Build Method](#build-method-3)
         - [`@override Widget build(BuildContext context)`](#override-widget-buildbuildcontext-context-12)
   * [RegisterPage](#registerpage)
      + [Overview](#overview-16)
      + [Features](#features-15)
      + [Constructor](#constructor-9)
      + [State Management](#state-management-4)
         - [`_RegisterPageState`](#_registerpagestate)
         - [`void signUserUp()`](#void-signuserup)
   * [Build Method](#build-method-4)
         - [`@override Widget build(BuildContext context)`](#override-widget-buildbuildcontext-context-13)
   * [MyBag](#mybag)
      + [Overview](#overview-17)
      + [Features](#features-16)
      + [Constructor](#constructor-10)
      + [State Management](#state-management-5)
         - [`_MyBagState`](#_mybagstate)
         - [`@override Widget build(BuildContext context)`](#override-widget-buildbuildcontext-context-14)
         - [`void _onItemTapped(BuildContext context, int index)`](#void-_onitemtappedbuildcontext-context-int-index-1)
         - [`Scaffold _buildScaffold(BuildContext context, Widget body)`](#scaffold-_buildscaffoldbuildcontext-context-widget-body)
   * [ItemCard](#itemcard)
      + [Overview](#overview-18)
      + [Features](#features-17)
      + [Constructor](#constructor-11)
      + [State Management](#state-management-6)
         - [`_ItemCardState`](#_itemcardstate)
         - [`String _parseDocumentId(String input)`](#string-_parsedocumentidstring-input)
         - [`String _getFieldValue(Map<String, dynamic> field)`](#string-_getfieldvaluemapstring-dynamic-field)
      + [Build Method](#build-method-5)
         - [`@override Widget build(BuildContext context)`](#override-widget-buildbuildcontext-context-15)
   * [DeleteConfirmationDialog](#deleteconfirmationdialog)
      + [Overview](#overview-19)
      + [Features](#features-18)
      + [Function](#function)
         - [`showDeleteConfirmationDialog`](#showdeleteconfirmationdialog)
      + [Implementation](#implementation)
   * [ImageLoader](#imageloader)
      + [Overview](#overview-20)
      + [Features](#features-19)
      + [Constructor](#constructor-12)
      + [Methods](#methods-9)
         - [`@override Widget build(BuildContext context)`](#override-widget-buildbuildcontext-context-16)
   * [TotalAmountSection](#totalamountsection)
      + [Overview](#overview-21)
      + [Features](#features-20)
      + [Constructor](#constructor-13)
      + [Methods](#methods-10)
         - [`Future<Decimal> _calculateSubtotal()`](#futuredecimal-_calculatesubtotal)
         - [`Future<Decimal> _calculateTax()`](#futuredecimal-_calculatetax)
         - [`Future<Decimal> _calculateTotalAmount()`](#futuredecimal-_calculatetotalamount)
      + [Build Method](#build-method-6)
         - [`@override Widget build(BuildContext context)`](#override-widget-buildbuildcontext-context-17)
   * [PaymentPage](#paymentpage)
      + [Overview](#overview-22)
      + [Features](#features-21)
      + [Constructor](#constructor-14)
      + [State Management](#state-management-7)
         - [`_PaymentPageState`](#_paymentpagestate)
         - [`void _handlePay() async`](#void-_handlepay-async)
         - [`@override void initState()`](#override-void-initstate)
         - [`Future<void> _fetchAddresses() async`](#futurevoid-_fetchaddresses-async)
         - [`Future<void> _addNewAddress(String title, String address) async`](#futurevoid-_addnewaddressstring-title-string-address-async)
         - [`Future<void> _editAddress(int index, String title, String address) async`](#futurevoid-_editaddressint-index-string-title-string-address-async)
         - [`Future<void> _setMainAddress(int index) async`](#futurevoid-_setmainaddressint-index-async)
         - [`Future<void> _deleteAddress(int indexToDelete) async`](#futurevoid-_deleteaddressint-indextodelete-async)
         - [`void _showAddAddressDialog()`](#void-_showaddaddressdialog)
         - [`void _showEditAddressDialog(int index)`](#void-_showeditaddressdialogint-index)
         - [`void _showDeleteConfirmationDialog(int index)`](#void-_showdeleteconfirmationdialogint-index)
         - [`Future<List<Map<String, dynamic>>> _fetchCartItems() async`](#futurelistmapstring-dynamic-_fetchcartitems-async)
         - [`Future<Decimal> _calculateTax() async`](#futuredecimal-_calculatetax-async)
      + [Build Method](#build-method-7)
         - [`@override Widget build(BuildContext context)`](#override-widget-buildbuildcontext-context-18)
   * [RazorpayPayment](#razorpaypayment)
      + [Overview](#overview-23)
      + [Features](#features-22)
      + [Constructor](#constructor-15)
         - [`RazorpayPayment()`](#razorpaypayment-1)
      + [Methods](#methods-11)
         - [`void dispose()`](#void-dispose)
         - [`Future<String> openCheckout(double amount)`](#futurestring-opencheckoutdouble-amount)
         - [`void _handlePaymentSuccess(PaymentSuccessResponse response)`](#void-_handlepaymentsuccesspaymentsuccessresponse-response)
         - [`void _handlePaymentError(PaymentFailureResponse response)`](#void-_handlepaymenterrorpaymentfailureresponse-response)
         - [`void _handleExternalWallet(ExternalWalletResponse response)`](#void-_handleexternalwalletexternalwalletresponse-response)
      + [Function](#function-1)
         - [`Future<String> initiatePayment(Decimal amount)`](#futurestring-initiatepaymentdecimal-amount)
   * [AddressCard](#addresscard)
      + [Overview](#overview-24)
      + [Features](#features-23)
      + [Constructor](#constructor-16)
         - [`AddressCard`](#addresscard-1)
      + [Build Method](#build-method-8)
         - [`@override Widget build(BuildContext context)`](#override-widget-buildbuildcontext-context-19)
   * [AddressDialog](#addressdialog)
      + [Overview](#overview-25)
      + [Features](#features-24)
      + [Constructor](#constructor-17)
         - [`AddressDialog`](#addressdialog-1)
      + [Build Method](#build-method-9)
         - [`@override Widget build(BuildContext context)`](#override-widget-buildbuildcontext-context-20)
   * [ProfileScreen](#profilescreen)
      + [Overview](#overview-26)
      + [Features](#features-25)
      + [Constructor](#constructor-18)
         - [`ProfileScreen`](#profilescreen-1)
      + [State Management](#state-management-8)
         - [`_ProfileScreenState`](#_profilescreenstate)
         - [`@override void initState()`](#override-void-initstate-1)
         - [`Future<void> _fetchAddressCount() async`](#futurevoid-_fetchaddresscount-async)
         - [`void _handleLogout(BuildContext context) async`](#void-_handlelogoutbuildcontext-context-async)
      + [Build Method](#build-method-10)
         - [`@override Widget build(BuildContext context)`](#override-widget-buildbuildcontext-context-21)
         - [`Widget _buildProfileListTile(...)`](#widget-_buildprofilelisttile)
         - [`void _navigateTo(BuildContext context, Widget page)`](#void-_navigatetobuildcontext-context-widget-page)
   * [MyOrdersPage](#myorderspage)
      + [Overview](#overview-27)
      + [Features](#features-26)
      + [Constructor](#constructor-19)
         - [`MyOrdersPage`](#myorderspage-1)
      + [State Management](#state-management-9)
         - [`_MyOrdersPageState`](#_myorderspagestate)
         - [`@override void initState()`](#override-void-initstate-2)
         - [`@override void dispose()`](#override-void-dispose)
      + [Build Method](#build-method-11)
         - [`@override Widget build(BuildContext context)`](#override-widget-buildbuildcontext-context-22)
   * [OrderList](#orderlist)
      + [Overview](#overview-28)
      + [Features](#features-27)
      + [Constructor](#constructor-20)
         - [`OrderList`](#orderlist-1)
      + [Build Method](#build-method-12)
         - [`@override Widget build(BuildContext context)`](#override-widget-buildbuildcontext-context-23)
- [OrdersAppBar Class Documentation](#ordersappbar-class-documentation)
   * [Overview](#overview-29)
   * [Features](#features-28)
   * [Constructor](#constructor-21)
      + [`OrdersAppBar`](#ordersappbar)
   * [Build Method](#build-method-13)
      + [`@override Widget build(BuildContext context)`](#override-widget-buildbuildcontext-context-24)
   * [Preferred Size](#preferred-size)
      + [`@override Size get preferredSize`](#override-size-get-preferredsize-2)
   * [OrdersTabBar](#orderstabbar)
      + [Overview](#overview-30)
      + [Features](#features-29)
      + [Constructor](#constructor-22)
         - [`OrdersTabBar`](#orderstabbar-1)
      + [Build Method](#build-method-14)
         - [`@override Widget build(BuildContext context)`](#override-widget-buildbuildcontext-context-25)
      + [Preferred Size](#preferred-size-1)
         - [`@override Size get preferredSize`](#override-size-get-preferredsize-3)
   * [OrderCard](#ordercard)
      + [Overview](#overview-31)
      + [Features](#features-30)
      + [Constructor](#constructor-23)
         - [`OrderCard`](#ordercard-1)
      + [Build Method](#build-method-15)
         - [`@override Widget build(BuildContext context)`](#override-widget-buildbuildcontext-context-26)
   * [ProfileListTile](#profilelisttile)
      + [Overview](#overview-32)
      + [Features](#features-31)
      + [Constructor](#constructor-24)
         - [`ProfileListTile`](#profilelisttile-1)
      + [Build Method](#build-method-16)
         - [`@override Widget build(BuildContext context)`](#override-widget-buildbuildcontext-context-27)
   * [UserAccountHeader](#useraccountheader)
      + [Overview](#overview-33)
      + [Features](#features-32)
      + [Constructor](#constructor-25)
         - [`UserAccountHeader`](#useraccountheader-1)
      + [Methods](#methods-12)
         - [`Future<String?> getUserName(String email) async`](#futurestring-getusernamestring-email-async)
      + [Build Method](#build-method-17)
         - [`@override Widget build(BuildContext context)`](#override-widget-buildbuildcontext-context-28)
      + [UI Components](#ui-components)
   * [ShippingAddressesScreen](#shippingaddressesscreen)
      + [Overview](#overview-34)
      + [Features](#features-33)
      + [Constructor](#constructor-26)
         - [`ShippingAddressesScreen`](#shippingaddressesscreen-1)
      + [State Management](#state-management-10)
         - [`_ShippingAddressesScreenState`](#_shippingaddressesscreenstate)
         - [`@override void initState()`](#override-void-initstate-3)
      + [Methods](#methods-13)
         - [`void _toggleSelection(int? index)`](#void-_toggleselectionint-index)
         - [`Future<void> _fetchAddresses() async`](#futurevoid-_fetchaddresses-async-1)
         - [`Future<void> _addNewAddress(String title, String address) async`](#futurevoid-_addnewaddressstring-title-string-address-async-1)
         - [`Future<void> _editAddress(int index, String title, String address) async`](#futurevoid-_editaddressint-index-string-title-string-address-async-1)
         - [`Future<void> _setMainAddress(int index) async`](#futurevoid-_setmainaddressint-index-async-1)
         - [`Future<void> _deleteAddress(int indexToDelete) async`](#futurevoid-_deleteaddressint-indextodelete-async-1)
      + [Build Method](#build-method-18)
         - [`@override Widget build(BuildContext context)`](#override-widget-buildbuildcontext-context-29)
      + [UI Components](#ui-components-1)
   * [ProductCard](#productcard)
      + [Overview](#overview-35)
      + [Features](#features-34)
      + [Constructor](#constructor-27)
         - [`ProductCard`](#productcard-1)
      + [State Management](#state-management-11)
         - [`_ProductCardState`](#_productcardstate)
         - [`@override void initState()`](#override-void-initstate-4)
      + [Methods](#methods-14)
         - [`Future<void> fetchImages(String documentId) async`](#futurevoid-fetchimagesstring-documentid-async)
         - [`Future<void> updateRecentlyViewedProducts(String documentId) async`](#futurevoid-updaterecentlyviewedproductsstring-documentid-async)
         - [`Future<void> fetchRecentlyViewedProducts() async`](#futurevoid-fetchrecentlyviewedproducts-async)
         - [`Future<void> fetchUsersAlsoViewedProducts(String categoryValue) async`](#futurevoid-fetchusersalsoviewedproductsstring-categoryvalue-async)
         - [`void _onItemTapped(int index)`](#void-_onitemtappedint-index)
      + [Build Method](#build-method-19)
         - [`@override Widget build(BuildContext context)`](#override-widget-buildbuildcontext-context-30)
      + [UI Components](#ui-components-2)
   * [AddToCartButton](#addtocartbutton)
      + [Overview](#overview-36)
      + [Features](#features-35)
      + [Constructor](#constructor-28)
         - [`AddToCartButton`](#addtocartbutton-1)
      + [State Management](#state-management-12)
         - [`_AddToCartButtonState`](#_addtocartbuttonstate)
         - [`@override void initState()`](#override-void-initstate-5)
      + [Methods](#methods-15)
         - [`Future<void> fetchImageUrls() async`](#futurevoid-fetchimageurls-async)
         - [`void validateInputs()`](#void-validateinputs)
         - [`Future<void> _addToCart() async`](#futurevoid-_addtocart-async)
      + [Build Method](#build-method-20)
         - [`@override Widget build(BuildContext context)`](#override-widget-buildbuildcontext-context-31)
      + [UI Components](#ui-components-3)
   * [ImageCarousel](#imagecarousel)
      + [Overview](#overview-37)
      + [Features](#features-36)
      + [Constructor](#constructor-29)
         - [`ImageCarousel`](#imagecarousel-1)
      + [Build Method](#build-method-21)
         - [`@override Widget build(BuildContext context)`](#override-widget-buildbuildcontext-context-32)
   * [MoreColoursSection](#morecolourssection)
      + [Overview](#overview-38)
      + [Features](#features-37)
      + [Constructor](#constructor-30)
         - [`MoreColoursSection`](#morecolourssection-1)
      + [Build Method](#build-method-22)
         - [`@override Widget build(BuildContext context)`](#override-widget-buildbuildcontext-context-33)
   * [OrderSwatchesButton](#orderswatchesbutton)
      + [Overview](#overview-39)
      + [Features](#features-38)
      + [Constructor](#constructor-31)
         - [`OrderSwatchesButton`](#orderswatchesbutton-1)
      + [State Management](#state-management-13)
         - [`_OrderSwatchesButtonState`](#_orderswatchesbuttonstate)
         - [`@override void initState()`](#override-void-initstate-6)
   * [Methods](#methods-16)
         - [`Future<void> fetchImageUrls() async`](#futurevoid-fetchimageurls-async-1)
         - [`Future<void> _addSwatchesToCart() async`](#futurevoid-_addswatchestocart-async)
      + [Build Method](#build-method-23)
         - [`@override Widget build(BuildContext context)`](#override-widget-buildbuildcontext-context-34)
      + [UI Components](#ui-components-4)
   * [ProductName](#productname)
      + [Overview](#overview-40)
      + [Features](#features-39)
      + [Constructor](#constructor-32)
         - [`ProductName`](#productname-1)
      + [Build Method](#build-method-24)
         - [`@override Widget build(BuildContext context)`](#override-widget-buildbuildcontext-context-35)
   * [RecentlyViewedSection](#recentlyviewedsection)
      + [Overview](#overview-41)
      + [Features](#features-40)
      + [Constructor](#constructor-33)
         - [`RecentlyViewedSection`](#recentlyviewedsection-1)
      + [Build Method](#build-method-25)
         - [`@override Widget build(BuildContext context)`](#override-widget-buildbuildcontext-context-36)
   * [ShippingInfo](#shippinginfo)
      + [Overview](#overview-42)
      + [Features](#features-41)
      + [Constructor](#constructor-34)
         - [`ShippingInfo`](#shippinginfo-1)
      + [Build Method](#build-method-26)
         - [`@override Widget build(BuildContext context)`](#override-widget-buildbuildcontext-context-37)
   * [SupportSection ](#supportsection)
      + [Overview](#overview-43)
      + [Features](#features-42)
      + [Constructor](#constructor-35)
         - [`SupportSection`](#supportsection-1)
      + [Build Method](#build-method-27)
         - [`@override Widget build(BuildContext context)`](#override-widget-buildbuildcontext-context-38)
   * [UsersAlsoViewedSection](#usersalsoviewedsection)
      + [Overview](#overview-44)
      + [Features](#features-43)
      + [Constructor](#constructor-36)
         - [`UsersAlsoViewedSection`](#usersalsoviewedsection-1)
      + [Build Method](#build-method-28)
         - [`@override Widget build(BuildContext context)`](#override-widget-buildbuildcontext-context-39)
   * [DynamicFieldsDisplay](#dynamicfieldsdisplay)
      + [Overview](#overview-45)
      + [Features](#features-44)
   * [Constructor](#constructor-37)
         - [`DynamicFieldsDisplay`](#dynamicfieldsdisplay-1)
      + [Build Method](#build-method-29)
         - [`@override Widget build(BuildContext context)`](#override-widget-buildbuildcontext-context-40)
   * [DetailItem](#detailitem)
      + [Overview](#overview-46)
      + [Features](#features-45)
      + [Constructor](#constructor-38)
         - [`DetailItem`](#detailitem-1)
      + [Build Method](#build-method-30)
         - [`@override Widget build(BuildContext context)`](#override-widget-buildbuildcontext-context-41)
   * [ImageSelector](#imageselector)
      + [Overview](#overview-47)
      + [Features](#features-46)
      + [Constructor](#constructor-39)
         - [`ImageSelector`](#imageselector-1)
      + [Build Method](#build-method-31)
         - [`@override Widget build(BuildContext context)`](#override-widget-buildbuildcontext-context-42)
   * [LengthSlider](#lengthslider)
      + [Overview](#overview-48)
      + [Features](#features-47)
      + [Constructor](#constructor-40)
         - [`LengthSlider`](#lengthslider-1)
      + [Build Method](#build-method-32)
         - [`@override Widget build(BuildContext context)`](#override-widget-buildbuildcontext-context-43)
   * [ImagePlaceholder](#imageplaceholder)
      + [Overview](#overview-49)
      + [Features](#features-48)
      + [Constructor](#constructor-41)
         - [`ImagePlaceholder`](#imageplaceholder-1)
      + [Build Method](#build-method-33)
         - [`@override Widget build(BuildContext context)`](#override-widget-buildbuildcontext-context-44)
   * [ImageThumbnails](#imagethumbnails)
      + [Overview](#overview-50)
      + [Features](#features-49)
      + [Constructor](#constructor-42)
         - [`ImageThumbnails`](#imagethumbnails-1)
      + [Build Method](#build-method-34)
         - [`@override Widget build(BuildContext context)`](#override-widget-buildbuildcontext-context-45)
   * [SubCategoryList](#subcategorylist)
      + [Overview](#overview-51)
      + [Features](#features-50)
      + [Constructor](#constructor-43)
         - [`SubCategoryList`](#subcategorylist-1)
      + [Build Method](#build-method-35)
         - [`@override Widget build(BuildContext context)`](#override-widget-buildbuildcontext-context-46)
   * [SortButton](#sortbutton)
      + [Overview](#overview-52)
      + [Features](#features-51)
      + [Constructor](#constructor-44)
         - [`SortButton`](#sortbutton-1)
      + [Build Method](#build-method-36)
         - [`@override Widget build(BuildContext context)`](#override-widget-buildbuildcontext-context-47)

<!-- TOC end -->

<!-- TOC --><a name="dyota-mobile-application"></a>
# Dyota Mobile Application

<!-- TOC --><a name="overview"></a>
## Overview

Dyota is a mobile application built using Flutter and Firebase. It provides a seamless shopping experience with features like user authentication, product browsing, cart management, order tracking, and more.

<!-- TOC --><a name="authpage"></a>
## AuthPage

<!-- TOC --><a name="overview-1"></a>
### Overview

The `AuthPage` is a stateless widget that serves as the authentication entry point for the application. It utilizes Firebase Authentication to manage user sessions and Firestore to store user-related data. The page dynamically updates based on the user's authentication state.

<!-- TOC --><a name="features"></a>
### Features

- **Real-time Authentication State Monitoring**: The `AuthPage` listens for changes in the user's authentication state using Firebase's `authStateChanges()` stream.
- **User Record Management**: Automatically checks if a user record exists in Firestore upon login and creates one if it does not, ensuring that user data is initialized correctly.
- **Navigation**: Redirects users to the appropriate page based on their authentication status—either the home page for logged-in users or the login/registration page for unauthenticated users.

<!-- TOC --><a name="homepage"></a>
## HomePage

<!-- TOC --><a name="overview-2"></a>
### Overview

The `HomePage` class is a stateless widget that serves as the main interface for users after logging in. It displays categories and best-selling products, integrating with Firestore to fetch relevant data.

<!-- TOC --><a name="features-1"></a>
### Features

- **Dynamic Content**: Displays items marked to be shown on the home page.
- **Firestore Integration**: Queries the `items` collection to retrieve document IDs based on the `isShownOnHomePage` field.
- **User Navigation**: Provides a bottom navigation bar for easy access to the home page, shopping bag, and user profile.

<!-- TOC --><a name="methods"></a>
### Methods

<!-- TOC --><a name="futureliststring-getdocumentidsshownonhomepage"></a>
#### `Future<List<String>> getDocumentIdsShownOnHomePage()`

- Fetches document IDs from Firestore where `isShownOnHomePage` is set to 1.
- Returns a list of document IDs.

<!-- TOC --><a name="void-_onitemtappedbuildcontext-context-int-index"></a>
#### `void _onItemTapped(BuildContext context, int index)`

- Handles navigation based on the tapped index in the bottom navigation bar.
- Navigates to the `HomePage`, `MyBag`, or `ProfileScreen`.

<!-- TOC --><a name="override-widget-buildbuildcontext-context"></a>
#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `HomePage`.
- Utilizes a `FutureBuilder` to manage asynchronous data fetching.
- Displays loading indicators, error messages, or the main content based on the data state.

<!-- TOC --><a name="custombottomnavigationbar"></a>
## CustomBottomNavigationBar

<!-- TOC --><a name="overview-3"></a>
### Overview

The `CustomBottomNavigationBar` class is a stateless widget that provides a customizable bottom navigation bar for the application. It allows users to navigate between different sections of the app, such as Home, Bag, and Profile.

<!-- TOC --><a name="features-2"></a>
### Features

- **Dynamic Selection**: Highlights the currently selected item based on the `selectedIndex` parameter.
- **Customizable Callback**: Accepts a callback function `onItemTapped` to handle navigation when an item is tapped.
- **Consistent Design**: Uses a fixed type bottom navigation bar with a black background and white icons for a cohesive look.

<!-- TOC --><a name="constructor"></a>
### Constructor

- **Parameters**:
  - `selectedIndex`: An integer representing the currently selected index of the navigation items.
  - `onItemTapped`: A function that takes an integer as an argument, used to handle item tap events.

<!-- TOC --><a name="build-method"></a>
### Build Method

- Constructs the `BottomNavigationBar` widget with:
  - A black background color.
  - White color for selected items and a lighter shade for unselected items.
  - Three fixed items: Home, Bag, and Profile, each represented by an icon and a label.
  - The `currentIndex` is set to the value of `selectedIndex`, ensuring the correct item is highlighted.
  - The `onTap` property is linked to the `onItemTapped` function to facilitate navigation.

<!-- TOC --><a name="categorygrid"></a>
## CategoryGrid

<!-- TOC --><a name="overview-4"></a>
### Overview

The `CategoryGrid` class is a stateless widget that displays a grid of categories fetched from Firestore. It utilizes a `FutureBuilder` to handle asynchronous data retrieval and dynamically updates the UI based on the data state.

<!-- TOC --><a name="features-3"></a>
### Features

- **Data Fetching**: Retrieves category documents from the Firestore `categories` collection.
- **Dynamic UI**: Displays categories in a grid format, adjusting based on the number of documents retrieved.
- **Error Handling**: Manages loading states, errors, and empty data scenarios gracefully.

<!-- TOC --><a name="methods-1"></a>
### Methods

<!-- TOC --><a name="futurelistdocumentsnapshot-getcategorydocuments"></a>
#### `Future<List<DocumentSnapshot>> getCategoryDocuments()`

- Fetches category documents from Firestore and returns a list of `DocumentSnapshot` objects.

<!-- TOC --><a name="override-widget-buildbuildcontext-context-1"></a>
#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `CategoryGrid`.
- Uses a `FutureBuilder` to manage the asynchronous fetching of category data.
- Displays a loading indicator while data is being fetched.
- Handles errors and empty data cases, logging relevant information.
- Renders a grid of `CategoryItem` widgets based on the retrieved category documents.

<!-- TOC --><a name="bestsellerheader"></a>
## BestSellerHeader

<!-- TOC --><a name="overview-5"></a>
### Overview

The `BestSellerHeader` class is a stateless widget that displays a header for the best-selling products section of the application.

<!-- TOC --><a name="features-4"></a>
### Features

- **Static Header**: Displays a fixed title "Best Sellers" to indicate the section of best-selling products.
- **Custom Styling**: Utilizes a specific font family, size, weight, and color.

<!-- TOC --><a name="methods-2"></a>
### Methods

<!-- TOC --><a name="override-widget-buildbuildcontext-context-2"></a>
#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `BestSellerHeader`.

<!-- TOC --><a name="customappbar"></a>
## CustomAppBar

<!-- TOC --><a name="overview-6"></a>
### Overview

The `CustomAppBar` class is a stateless widget that implements a custom application bar for the app. It includes a title and a search field, providing a user-friendly interface for navigation and search functionality.

<!-- TOC --><a name="features-5"></a>
### Features

- **Customizable Appearance**: The app bar has a black background and is designed to fit the overall theme of the application.
- **Search Functionality**: Includes a text field for user input, allowing users to search for items within the app.
- **Dynamic Height**: The height of the app bar is adjustable, accommodating additional elements as needed.

<!-- TOC --><a name="methods-3"></a>
### Methods

<!-- TOC --><a name="override-widget-buildbuildcontext-context-3"></a>
#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `CustomAppBar`.
- Utilizes a `TextEditingController` to manage the input for the search field.
- Organizes the layout using a `Column` to evenly distribute space between the title and the search field.
- The search field includes:
  - A hint text prompting the user to enter a search query.
  - A search icon for visual indication.
  - An `onSubmitted` callback that navigates to the `SearchPage` with the user's query when the search is submitted.

<!-- TOC --><a name="override-size-get-preferredsize"></a>
#### `@override Size get preferredSize`

- Returns the preferred size of the app bar, which is set to accommodate the standard toolbar height plus additional space for the custom elements.

<!-- TOC --><a name="searchpage"></a>
## SearchPage

<!-- TOC --><a name="overview-7"></a>
### Overview

The `SearchPage` class is a stateful widget that provides a user interface for searching items within the application. It allows users to input search queries and displays the results in a grid format.

<!-- TOC --><a name="features-6"></a>
### Features

- **Dynamic Search Functionality**: Users can enter search queries, and the results are fetched and displayed in real-time.
- **Loading Indicator**: Displays a loading spinner while search results are being fetched.
- **Error Handling**: Manages potential errors during the search process gracefully.

<!-- TOC --><a name="constructor-1"></a>
### Constructor

- **Parameters**:
  - `searchInput`: A string that initializes the search field with a predefined query.

<!-- TOC --><a name="state-management"></a>
### State Management

<!-- TOC --><a name="_searchpagestate"></a>
#### `_SearchPageState`

- **Attributes**:
  - `searchResults`: A list of tuples containing search results, where each tuple holds a priority and a document ID.
  - `isLoading`: A boolean indicating whether the search results are currently being loaded.
  - `searchController`: A `TextEditingController` for managing the input in the search field.

<!-- TOC --><a name="initstate"></a>
#### `initState()`

- Initializes the `searchController` with the provided `searchInput` and triggers the search operation.

<!-- TOC --><a name="futurevoid-_performsearch"></a>
#### `Future<void> _performSearch()`

- Executes the search based on the current input in the search field.
- Updates the `isLoading` state to reflect the search status.
- Fetches search results asynchronously and updates the state accordingly.

<!-- TOC --><a name="build-method-1"></a>
### Build Method

<!-- TOC --><a name="override-widget-buildbuildcontext-context-4"></a>
#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `SearchPage`.
- Contains a `Scaffold` with:
  - A custom app bar displaying the title "Search Results".
  - A search input field styled with rounded corners and a search icon.
  - A body that displays either a loading indicator, a message for no results found, or the grid view of search results.

<!-- TOC --><a name="widget-buildgridview"></a>
#### `Widget buildGridView()`

- Constructs a grid view to display the search results.
- Uses a `GridView.builder` to create a grid layout based on the number of search results.

<!-- TOC --><a name="helper-class"></a>
### Helper Class

<!-- TOC --><a name="tuplet1-t2"></a>
#### `Tuple<T1, T2>`

- A simple helper class to represent a tuple containing two items, used to store search result priorities and document IDs.

<!-- TOC --><a name="search-function"></a>
### Search Function

<!-- TOC --><a name="futurelisttupleint-string-searchstring-query"></a>
#### `Future<List<Tuple<int, String>>> search(String query)`

- Searches the Firestore `items` collection for documents matching the provided query.
- Converts the query to lowercase for case-insensitive matching.
- Iterates through each document and checks if any field matches the query, assigning a priority based on the match type.
- Returns a sorted list of matching document IDs based on their priority.

<!-- TOC --><a name="categoryheader"></a>
## CategoryHeader

<!-- TOC --><a name="overview-8"></a>
### Overview

The `CategoryHeader` class is a stateless widget that displays a header for the categories section of the application.

<!-- TOC --><a name="features-7"></a>
### Features

- **Static Header**: Displays a fixed title "Categories" to indicate the section for category listings.
- **Custom Styling**: Utilizes a specific font family, size, weight, and color.

<!-- TOC --><a name="methods-4"></a>
### Methods

<!-- TOC --><a name="override-widget-buildbuildcontext-context-5"></a>
#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `CategoryHeader`.
- Uses padding to create space around the text.

<!-- TOC --><a name="productgrid"></a>
## ProductGrid

<!-- TOC --><a name="overview-9"></a>
### Overview

The `ProductGrid` class is a stateless widget that displays a grid of products based on a list of document IDs. It utilizes a `GridView` to present the products.

<!-- TOC --><a name="features-8"></a>
### Features

- **Dynamic Product Display**: Renders a grid of products using the provided document IDs.
- **Logging**: Implements logging to track the building process of the grid and individual product items.

<!-- TOC --><a name="constructor-2"></a>
### Constructor

- **Parameters**:
  - `documentIds`: A list of strings representing the document IDs of the products to be displayed.

<!-- TOC --><a name="methods-5"></a>
### Methods

<!-- TOC --><a name="override-widget-buildbuildcontext-context-6"></a>
#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `ProductGrid`.
- Logs the number of items being built for the grid.
- Utilizes a `GridView.builder` to create a grid layout with:
  - **Non-scrollable**: The grid is set to not scroll, allowing it to fit within its parent widget.
  - **Dynamic Item Count**: The number of items displayed is based on the length of the `documentIds` list.
  - **Grid Delegate**: Configures the grid to have a fixed number of columns (2) and specified spacing between items.
  - **Item Builder**: For each item, it logs the document ID being processed and returns a `ProductListItem` widget wrapped in padding for spacing.

<!-- TOC --><a name="categoryitem"></a>
## CategoryItem

<!-- TOC --><a name="overview-10"></a>
### Overview

The `CategoryItem` class is a stateless widget that represents an individual category item in the application. It fetches category data from Firestore and displays the category image and name. When tapped, it navigates to the corresponding category page.

<!-- TOC --><a name="features-9"></a>
### Features

- **Dynamic Data Fetching**: Retrieves category names, image file names, and document IDs from Firestore.
- **Image Handling**: Fetches the download URL for category images stored in Firebase Storage.
- **User Interaction**: Allows users to tap on a category item to navigate to the respective category page.

<!-- TOC --><a name="constructor-3"></a>
### Constructor

- **Parameters**:
  - `index`: An integer representing the index of the category item, used to access specific category data.

<!-- TOC --><a name="methods-6"></a>
### Methods

<!-- TOC --><a name="futurestring-getimageurlstring-imagename"></a>
#### `Future<String> getImageUrl(String imageName)`

- Fetches the download URL for a category image from Firebase Storage.
- Returns the URL as a string.

<!-- TOC --><a name="futurelistmapstring-string-getcategorydata"></a>
#### `Future<List<Map<String, String>>> getCategoryData()`

- Fetches category data from Firestore, including category names, image file names, and document IDs.
- Returns a list of maps containing the category data.

<!-- TOC --><a name="override-widget-buildbuildcontext-context-7"></a>
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

<!-- TOC --><a name="categorypage"></a>
## CategoryPage

<!-- TOC --><a name="overview-11"></a>
### Overview

The `CategoryPage` class is a stateful widget that displays a specific category of items within the application. It allows users to view subcategories, sort items, and select categories to filter the displayed items. The page fetches data from Firestore and updates the UI based on user interactions.

<!-- TOC --><a name="features-10"></a>
### Features

- **Dynamic Data Fetching**: Retrieves category data, including subcategories and items, from Firestore.
- **Sorting Options**: Provides users with the ability to sort items by price in ascending or descending order.
- **User Interaction**: Allows users to select categories and view items based on their selections.

<!-- TOC --><a name="constructor-4"></a>
### Constructor

- **Parameters**:
  - `categoryDocumentId`: A string representing the document ID of the category to be displayed.

<!-- TOC --><a name="state-management-1"></a>
### State Management

<!-- TOC --><a name="_categorypagestate"></a>
#### `_CategoryPageState`

- **Attributes**:
  - `isGridView`: A boolean indicating whether the items should be displayed in a grid view.
  - `selectedCategories`: A list of strings representing the categories selected by the user.
  - `selectedSortOption`: A string representing the currently selected sorting option.
  - `categoryName`: A string for the name of the category.
  - `subCategories`: A list of strings for the subcategories under the main category.
  - `itemDocumentIds`: A list of strings for the document IDs of the items to be displayed.
  - `isLoading`: A boolean indicating whether data is currently being loaded.

<!-- TOC --><a name="initstate-1"></a>
#### `initState()`

- Initializes the state and fetches category data when the widget is first created.
- Logs the initialization process and handles any errors that occur during data fetching.

<!-- TOC --><a name="_selectcategorystring-category"></a>
#### `_selectCategory(String category)`

- Updates the selected categories based on user interaction.
- Fetches items again after updating the selected categories.

<!-- TOC --><a name="_showsortoptionsbuildcontext-context"></a>
#### `_showSortOptions(BuildContext context)`

- Displays a modal bottom sheet with sorting options for the user to select.

<!-- TOC --><a name="_buildsortoptionsbuildcontext-context"></a>
#### `_buildSortOptions(BuildContext context)`

- Constructs a list of sorting options for the modal bottom sheet.

<!-- TOC --><a name="_buildsortoptionbuildcontext-context-string-option"></a>
#### `_buildSortOption(BuildContext context, String option)`

- Creates a list tile for each sorting option, allowing the user to select it and fetch items accordingly.

<!-- TOC --><a name="_fetchcategorydata"></a>
#### `_fetchCategoryData()`

- Asynchronously fetches category data from Firestore, including the category name and subcategories.
- Updates the state with the fetched data and logs the success or failure of the operation.

<!-- TOC --><a name="_fetchitemsstring-sortoption-sort"></a>
#### `_fetchItems({String sortOption = 'Sort'})`

- Asynchronously fetches item document IDs based on the selected categories and category name.
- Sorts the items based on the selected sorting option and updates the state with the sorted item IDs.

<!-- TOC --><a name="override-widget-buildbuildcontext-context-8"></a>
#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `CategoryPage`.
- Displays a loading indicator while data is being fetched.
- Contains a `Scaffold` with:
  - A custom app bar displaying the category name.
  - A scrollable column containing:
    - A list of subcategories.
    - A sort button to trigger sorting options.
    - A grid view of items or a loading indicator based on the loading state.

<!-- TOC --><a name="widget-buildgridview-1"></a>
#### `Widget buildGridView()`

- Constructs a grid view to display the items based on the fetched document IDs.
- Returns an empty text widget if there are no items to display.

<!-- TOC --><a name="productlistitem"></a>
## ProductListItem

<!-- TOC --><a name="overview-12"></a>
### Overview

The `ProductListItem` class is a stateless widget that represents an individual product in the application. It fetches product data from Firestore and displays the product's image, brand, title, and price. When tapped, it navigates to a detailed product view.

<!-- TOC --><a name="features-11"></a>
### Features

- **Dynamic Data Fetching**: Retrieves product data, including image locations and pricing, from Firestore.
- **Image Handling**: Fetches the download URL for the product image stored in Firebase Storage.
- **User Interaction**: Allows users to tap on the product item to view detailed information.

<!-- TOC --><a name="constructor-5"></a>
### Constructor

- **Parameters**:
  - `documentId`: A string representing the document ID of the product to be displayed.

<!-- TOC --><a name="methods-7"></a>
### Methods

<!-- TOC --><a name="futuremapstring-dynamic-fetchproductdata"></a>
#### `Future<Map<String, dynamic>> fetchProductData()`

- Asynchronously fetches product data from Firestore using the provided `documentId`.
- Returns a map containing the product's details.

<!-- TOC --><a name="futurestring-getimageurlstring-path"></a>
#### `Future<String> getImageUrl(String path)`

- Asynchronously retrieves the download URL for the product image from Firebase Storage.
- Returns the URL as a string.

<!-- TOC --><a name="override-widget-buildbuildcontext-context-9"></a>
#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `ProductListItem`.
- Utilizes a `FutureBuilder` to manage asynchronous data fetching for product data.
- Handles various states of the data fetching process:
  - Displays nothing while waiting for data.
  - Throws an exception if an error occurs during data fetching.
  - If data is available, it fetches the image URL using another `FutureBuilder`:
    - Displays a loading indicator while fetching the image.
    - Throws an exception if an error occurs while fetching the image.
    - If the image URL is successfully retrieved, it displays the product card with the image and details.

<!-- TOC --><a name="widget-buildproductcardstring-imageurl-mapstring-dynamic-data"></a>
#### `Widget buildProductCard(String imageUrl, Map<String, dynamic> data)`

- Constructs the UI for the product card.
- Extracts and formats the brand, title, and price from the product data.
- Displays the product image, brand, title, and price in a card layout.
- Includes a discount label if applicable.

<!-- TOC --><a name="genericappbar"></a>
## genericAppbar

<!-- TOC --><a name="overview-13"></a>
### Overview

The `genericAppbar` class is a stateless widget that provides a customizable application bar for the app. It allows for the display of a title and optionally includes a back button for navigation.

<!-- TOC --><a name="features-12"></a>
### Features

- **Customizable Title**: Accepts a title string to be displayed in the app bar.
- **Back Button Control**: Includes an option to show or hide the back button, allowing for flexible navigation options.
- **Consistent Styling**: Sets a consistent background color and text color for the app bar.

<!-- TOC --><a name="constructor-6"></a>
### Constructor

- **Parameters**:
  - `title`: A required string that sets the title of the app bar.
  - `showBackButton`: An optional boolean (defaulting to `true`) that determines whether the back button is displayed.

<!-- TOC --><a name="methods-8"></a>
### Methods

<!-- TOC --><a name="override-widget-buildbuildcontext-context-10"></a>
#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `genericAppbar`.
- Configures the app bar with:
  - A black background color.
  - White icon and text colors for visibility.
  - A leading back button that pops the current screen from the navigation stack if `showBackButton` is true.
  - No leading widget if `showBackButton` is false.

<!-- TOC --><a name="override-size-get-preferredsize-1"></a>
#### `@override Size get preferredSize`

- Returns the preferred size of the app bar, which is set to the standard toolbar height.

<!-- TOC --><a name="loginorregisterpage"></a>
## LoginOrRegisterPage

<!-- TOC --><a name="overview-14"></a>
### Overview

The `LoginOrRegisterPage` class is a stateful widget that provides a user interface for users to either log in or register for an account. It allows users to toggle between the login and registration forms.

<!-- TOC --><a name="features-13"></a>
### Features

- **Toggle Functionality**: Users can switch between the login and registration pages using a simple toggle mechanism.
- **Dynamic UI**: Displays either the `LoginPage` or `RegisterPage` based on the current state.

<!-- TOC --><a name="constructor-7"></a>
### Constructor

- **Parameters**:
  - None. The constructor initializes the widget with a key.

<!-- TOC --><a name="state-management-2"></a>
### State Management

<!-- TOC --><a name="_loginorregisterpagestate"></a>
#### `_LoginOrRegisterPageState`

- **Attributes**:
  - `showLoginPage`: A boolean that determines which page (login or register) is currently being displayed. It is initialized to `true`, meaning the login page is shown by default.

<!-- TOC --><a name="void-togglepages"></a>
#### `void togglePages()`

- Toggles the value of `showLoginPage` between `true` and `false`.
- Calls `setState` to update the UI whenever the toggle occurs.

<!-- TOC --><a name="build-method-2"></a>
## Build Method

<!-- TOC --><a name="override-widget-buildbuildcontext-context-11"></a>
#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `LoginOrRegisterPage`.
- Checks the value of `showLoginPage`:
  - If `true`, it returns the `LoginPage` widget, passing the `togglePages` function as a callback for when the user wants to switch to the registration page.
  - If `false`, it returns the `RegisterPage` widget, also passing the `togglePages` function for switching back to the login page.

<!-- TOC --><a name="loginpage"></a>
## LoginPage

<!-- TOC --><a name="overview-15"></a>
### Overview

The `LoginPage` class is a stateful widget that provides a user interface for users to log into their accounts. It includes fields for email and password input, a sign-in button, and options for password recovery and registration.

<!-- TOC --><a name="features-14"></a>
### Features

- **User Authentication**: Allows users to log in using their email and password.
- **Error Handling**: Displays an error message if invalid credentials are provided.
- **Navigation**: Provides options to navigate to the password recovery page and to switch to the registration page.

<!-- TOC --><a name="constructor-8"></a>
### Constructor

- **Parameters**:
  - `onTap`: A callback function that is called when the user wants to switch to the registration page.

<!-- TOC --><a name="state-management-3"></a>
### State Management

<!-- TOC --><a name="_loginpagestate"></a>
#### `_LoginPageState`

- **Attributes**:
  - `emailController`: A `TextEditingController` for managing the email input field.
  - `passwordController`: A `TextEditingController` for managing the password input field.
  - `showInvalidCredentials`: A boolean that tracks whether to display an invalid credentials message.

<!-- TOC --><a name="void-signuserin"></a>
#### `void signUserIn()`

- Asynchronously attempts to sign the user in using Firebase Authentication.
- Displays a loading indicator while the sign-in process is ongoing.
- If the sign-in fails, updates the state to show an invalid credentials message.

<!-- TOC --><a name="build-method-3"></a>
## Build Method

<!-- TOC --><a name="override-widget-buildbuildcontext-context-12"></a>
#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `LoginPage`.
- Utilizes a `Scaffold` with a black background and a `SafeArea` to ensure content is displayed within the safe area of the device.
- Contains a `ListView` to allow scrolling of the content, which includes:
  - A logo and heading for the application.
  - A welcome message.
  - Input fields for email and password using `MyTextField`.
  - A message indicating invalid credentials if applicable.
  - A link to the password recovery page.
  - A sign-in button that triggers the `signUserIn` method.
  - A section for Google sign-in using `SquareTile`.
  - A prompt for users who are not members to register, which triggers the `onTap` callback.

<!-- TOC --><a name="registerpage"></a>
## RegisterPage

<!-- TOC --><a name="overview-16"></a>
### Overview

The `RegisterPage` class is a stateful widget that provides a user interface for new users to register for an account. It includes fields for email, password, and password confirmation, as well as a button to submit the registration form.

<!-- TOC --><a name="features-15"></a>
### Features

- **User Registration**: Allows users to create an account using their email and password.
- **Error Handling**: Displays appropriate messages for invalid input, such as weak passwords or email already in use.
- **Navigation**: Provides an option to navigate back to the login page after registration.

<!-- TOC --><a name="constructor-9"></a>
### Constructor

- **Parameters**:
  - `onTap`: A callback function that is called when the user wants to switch to the login page.

<!-- TOC --><a name="state-management-4"></a>
### State Management

<!-- TOC --><a name="_registerpagestate"></a>
#### `_RegisterPageState`

- **Attributes**:
  - `emailController`: A `TextEditingController` for managing the email input field.
  - `passwordController`: A `TextEditingController` for managing the password input field.
  - `confirmPasswordController`: A `TextEditingController` for managing the password confirmation input field.
  - `showInvalidCredentials`: An integer that tracks the type of error encountered during registration.

<!-- TOC --><a name="void-signuserup"></a>
#### `void signUserUp()`

- Asynchronously attempts to register the user using Firebase Authentication.
- Displays a loading indicator while the registration process is ongoing.
- If registration is successful:
  - Closes the loading indicator.
  - Shows a success message using a `SnackBar`.
  - Waits for a few seconds and then navigates to the `LoginPage`.
- If registration fails:
  - Closes the loading indicator.
  - Updates the state to reflect the type of error encountered (e.g., invalid email, weak password, email already in use).

<!-- TOC --><a name="build-method-4"></a>
## Build Method

<!-- TOC --><a name="override-widget-buildbuildcontext-context-13"></a>
#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `RegisterPage`.
- Utilizes a `Scaffold` with a black background and a `SafeArea` to ensure content is displayed within the safe area of the device.
- Contains a `ListView` to allow scrolling of the content, which includes:
  - A logo and heading for the application.
  - Input fields for email, password, and password confirmation using `MyTextField`.
  - A register button that triggers the `signUserUp` method.
  - A section for Google sign-in using `SquareTile`.
  - A prompt for users who already have an account to log in, which triggers the `onTap` callback.

<!-- TOC --><a name="mybag"></a>
## MyBag

<!-- TOC --><a name="overview-17"></a>
### Overview

The `MyBag` class is a stateful widget that represents the user's shopping bag within the application. It displays the items that the user has added to their cart and provides functionality to navigate to different sections of the app.

<!-- TOC --><a name="features-16"></a>
### Features

- **User Authentication Check**: Verifies if the user is logged in before displaying the bag contents.
- **Real-time Data Fetching**: Uses a `StreamBuilder` to listen for changes in the user's cart items stored in Firestore.
- **Dynamic UI Updates**: Automatically updates the UI when items are added or removed from the cart.
- **Navigation**: Provides a bottom navigation bar to switch between the home page, the bag, and the user profile.

<!-- TOC --><a name="constructor-10"></a>
### Constructor

- **MyBag**: The constructor initializes the widget without any parameters.

<!-- TOC --><a name="state-management-5"></a>
### State Management

<!-- TOC --><a name="_mybagstate"></a>
#### `_MyBagState`

- **Attributes**:
  - `Logger _logger`: A logger instance for logging information and errors related to the `MyBag` widget.

<!-- TOC --><a name="override-widget-buildbuildcontext-context-14"></a>
#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `MyBag` widget.
- Checks if the user is logged in:
  - If not, displays a message prompting the user to log in.
- If the user is logged in, it sets up a `StreamBuilder` to listen for changes in the user's cart items:
  - Displays a loading indicator while waiting for data.
  - Handles errors that may occur during data fetching.
  - If the cart is empty, displays a message indicating that the bag is empty.
  - If items are present, it builds a list of `ItemCard` widgets for each item in the cart, along with a `TotalAmountSection` to display the total amount.

<!-- TOC --><a name="void-_onitemtappedbuildcontext-context-int-index-1"></a>
#### `void _onItemTapped(BuildContext context, int index)`

- Handles navigation when an item in the bottom navigation bar is tapped:
  - Navigates to the home page, the current bag, or the profile screen based on the selected index.

<!-- TOC --><a name="scaffold-_buildscaffoldbuildcontext-context-widget-body"></a>
#### `Scaffold _buildScaffold(BuildContext context, Widget body)`

- Constructs a `Scaffold` widget that includes:
  - A custom app bar with the title "My Bag".
  - The body content passed as a parameter.
  - A bottom navigation bar that allows users to switch between different sections of the app.

<!-- TOC --><a name="itemcard"></a>
## ItemCard

<!-- TOC --><a name="overview-18"></a>
### Overview

The `ItemCard` class is a stateful widget that represents an individual item in the user's shopping bag. It displays the item's details, including an image and various attributes, and provides functionality to delete the item from the cart.

<!-- TOC --><a name="features-17"></a>
### Features

- **Dynamic Data Fetching**: Retrieves item data from Firestore based on the user's email and the item's document ID.
- **User Interaction**: Allows users to tap on the item to view its details in a separate `ProductCard` screen.
- **Delete Functionality**: Provides an option to delete the item from the cart with a confirmation dialog.

<!-- TOC --><a name="constructor-11"></a>
### Constructor

- **Parameters**:
  - `documentId`: A required string representing the document ID of the item.
  - `onDelete`: A required callback function that is called when the item is deleted.

<!-- TOC --><a name="state-management-6"></a>
### State Management

<!-- TOC --><a name="_itemcardstate"></a>
#### `_ItemCardState`

- **Attributes**:
  - `_isDeleted`: A boolean that tracks whether the item has been deleted.

<!-- TOC --><a name="string-_parsedocumentidstring-input"></a>
#### `String _parseDocumentId(String input)`

- Parses the document ID to extract a relevant portion of the ID for further processing.

<!-- TOC --><a name="string-_getfieldvaluemapstring-dynamic-field"></a>
#### `String _getFieldValue(Map<String, dynamic> field)`

- Extracts and formats the value, prefix, and suffix from a field map, returning a combined string.

<!-- TOC --><a name="build-method-5"></a>
### Build Method

<!-- TOC --><a name="override-widget-buildbuildcontext-context-15"></a>
#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `ItemCard`.
- Checks if the item has been deleted:
  - If deleted, returns an empty widget.
- Retrieves the current user and checks if they are logged in:
  - If not logged in, displays a message indicating the user needs to log in.
- Uses a `FutureBuilder` to fetch cart data based on the user's email and the item's document ID:
  - Displays a loading indicator while waiting for data.
  - Handles errors that may occur during data fetching.
  - If no cart data is found, displays a message indicating this.
- If cart data is available, it processes the data and builds the UI:
  - Uses another `FutureBuilder` to fetch additional document data for the item.
  - Displays a loading indicator while waiting for the document data.
  - Handles errors and empty data scenarios.
- Once the document data is retrieved, it constructs the item card UI:
  - Displays the item's image using the `ImageLoader` component.
  - Shows the item's attributes in a formatted manner.
  - Includes a delete button that triggers a confirmation dialog before deleting the item.

<!-- TOC --><a name="deleteconfirmationdialog"></a>
## DeleteConfirmationDialog

<!-- TOC --><a name="overview-19"></a>
### Overview

The `DeleteConfirmationDialog` is a utility function that displays a confirmation dialog to the user when they attempt to delete an item from their shopping bag in a Flutter application. It provides a clear interface for confirming or canceling the delete action.

<!-- TOC --><a name="features-18"></a>
### Features

- **Confirmation Dialog**: Prompts the user to confirm the deletion of an item.
- **Logging**: Utilizes the logging package to track the dialog's state and actions.
- **Firestore Integration**: Deletes the specified item from the Firestore database upon confirmation.

<!-- TOC --><a name="function"></a>
### Function

<!-- TOC --><a name="showdeleteconfirmationdialog"></a>
#### `showDeleteConfirmationDialog`

- **Parameters**:
  - `context`: The `BuildContext` in which the dialog will be displayed.
  - `email`: A string representing the user's email, used to locate the user's cart items in Firestore.
  - `unparsedDocumentId`: A string representing the document ID of the item to be deleted.
  - `onDelete`: A callback function that is invoked after the item has been successfully deleted.

<!-- TOC --><a name="implementation"></a>
### Implementation

- **Logging**: Logs the action of showing the delete confirmation dialog along with the document ID.
- **showDialog**: Displays an `AlertDialog` with the following components:
  - **Title**: "Remove Item"
  - **Content**: A message asking the user to confirm the deletion.
  - **Actions**:
    - **Cancel Button**: Closes the dialog without performing any action. Logs the cancellation.
    - **Yes Button**: 
      - Logs the confirmation of the delete action.
      - Closes the dialog.
      - Deletes the item from Firestore using the provided email and document ID.
      - Logs the successful deletion.
      - Displays a `SnackBar` notification to inform the user that the item has been removed.
      - Calls the `onDelete` callback to perform any additional actions after deletion.

<!-- TOC --><a name="imageloader"></a>
## ImageLoader

<!-- TOC --><a name="overview-20"></a>
### Overview

The `ImageLoader` class is a stateless widget designed to asynchronously load an image from a specified location and provide it to a builder function for rendering. It utilizes a `FutureBuilder` to manage the loading state and handle potential errors during the image fetching process.

<!-- TOC --><a name="features-19"></a>
### Features

- **Asynchronous Image Loading**: Fetches the image URL from a remote storage location using a provided image path.
- **Error Handling**: Logs and throws exceptions for any errors encountered during the image fetching process.
- **Flexible Rendering**: Uses a builder function to allow for customizable rendering of the loaded image.

<!-- TOC --><a name="constructor-12"></a>
### Constructor

- **Parameters**:
  - `imageLocation`: A required string that specifies the location of the image to be loaded.
  - `builder`: A required function that takes a `BuildContext` and a `String` (the image URL) and returns a `Widget`. This allows the user to define how the image should be displayed once it is loaded.

<!-- TOC --><a name="methods-9"></a>
### Methods

<!-- TOC --><a name="override-widget-buildbuildcontext-context-16"></a>
#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `ImageLoader`.
- Logs the start of the image loading process.
- Uses a `FutureBuilder` to handle the asynchronous fetching of the image URL:
  - **Loading State**: Displays a loading indicator while the image URL is being fetched.
  - **Error State**: Logs the error and throws an exception if an error occurs during the fetching process.
  - **No Data State**: Logs a warning and displays an empty container if no data is found.
  - **Success State**: Once the image URL is successfully fetched, it logs the success and calls the builder function to render the image.

<!-- TOC --><a name="totalamountsection"></a>
## TotalAmountSection

<!-- TOC --><a name="overview-21"></a>
### Overview

The `TotalAmountSection` class is a stateless widget that displays the total amount of items in the user's shopping cart, including the subtotal and applicable taxes. It also provides a button to proceed to the payment page if the total amount meets a specified minimum order quantity.

<!-- TOC --><a name="features-20"></a>
### Features

- **Subtotal Calculation**: Computes the subtotal of items in the user's cart by fetching data from Firestore.
- **Tax Calculation**: Calculates the total tax based on the items in the cart.
- **Total Amount Calculation**: Combines the subtotal and tax to display the total amount.
- **Conditional Navigation**: Enables navigation to the payment page only if the total amount meets the minimum order quantity.

<!-- TOC --><a name="constructor-13"></a>
### Constructor

- **Parameters**:
  - `minimumOrderQuantity`: A required `Decimal` that specifies the minimum amount required to proceed to payment.

<!-- TOC --><a name="methods-10"></a>
### Methods

<!-- TOC --><a name="futuredecimal-_calculatesubtotal"></a>
#### `Future<Decimal> _calculateSubtotal()`

- Asynchronously calculates the subtotal of items in the user's cart.
- Retrieves the current user's email and fetches the cart items from Firestore.
- Sums the prices of all items in the cart and returns the subtotal as a `Decimal`.

<!-- TOC --><a name="futuredecimal-_calculatetax"></a>
#### `Future<Decimal> _calculateTax()`

- Asynchronously calculates the total tax for items in the user's cart.
- Retrieves the current user's email and fetches the cart items from Firestore.
- Iterates through the cart items to sum the tax values and returns the total tax as a `Decimal`.

<!-- TOC --><a name="futuredecimal-_calculatetotalamount"></a>
#### `Future<Decimal> _calculateTotalAmount()`

- Asynchronously calculates the total amount by combining the subtotal and tax.
- Calls the `_calculateSubtotal` and `_calculateTax` methods and returns the total amount as a `Decimal`.

<!-- TOC --><a name="build-method-6"></a>
### Build Method

<!-- TOC --><a name="override-widget-buildbuildcontext-context-17"></a>
#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `TotalAmountSection`.
- Uses a `FutureBuilder` to handle the asynchronous calculation of the total amount:
  - Displays a loading indicator while waiting for the total amount to be calculated.
  - Handles errors that may occur during the calculation.
- Once the total amount is available, it displays:
  - The total amount formatted to two decimal places.
  - A button to proceed to the payment page, which is enabled only if the total amount meets the minimum order quantity.

<!-- TOC --><a name="paymentpage"></a>
## PaymentPage

<!-- TOC --><a name="overview-22"></a>
### Overview

The `PaymentPage` class is a stateful widget that facilitates the payment process for the user's order. It allows users to select a shipping address, view the total amount for their cart items, and initiate the payment process. The page integrates with Firebase for data storage and retrieval.

<!-- TOC --><a name="features-21"></a>
### Features

- **Address Selection**: Users can select a shipping address from their saved addresses or add a new one.
- **Cart Item Summary**: Displays a summary of items in the cart, including subtotal, tax, and total amount.
- **Payment Processing**: Initiates payment through a payment gateway (e.g., Razorpay) and handles order placement.
- **Error Handling**: Provides feedback to users through snack bars for various actions, such as missing addresses or payment failures.

<!-- TOC --><a name="constructor-14"></a>
### Constructor

- **PaymentPage**: The constructor initializes the widget without any parameters.

<!-- TOC --><a name="state-management-7"></a>
### State Management

<!-- TOC --><a name="_paymentpagestate"></a>
#### `_PaymentPageState`

- **Attributes**:
  - `_selectedAddress`: An integer that holds the index of the currently selected address. It can be null if no address is selected.
  - `addresses`: A list of maps that stores the user's saved addresses.

<!-- TOC --><a name="void-_handlepay-async"></a>
#### `void _handlePay() async`

- Handles the payment process:
  - Checks if any address is selected; if not, shows a snack bar prompting the user to select an address.
  - Retrieves the current user's email and cart items from Firestore.
  - Calculates the subtotal and tax for the cart items.
  - Initiates the payment process and handles the result:
    - If successful, saves the order details to Firestore and deletes the cart items.
    - If failed, shows an error message.

<!-- TOC --><a name="override-void-initstate"></a>
#### `@override void initState()`

- Initializes the state and fetches the user's addresses when the widget is first created.

<!-- TOC --><a name="futurevoid-_fetchaddresses-async"></a>
#### `Future<void> _fetchAddresses() async`

- Fetches the user's saved addresses from Firestore and updates the state with the retrieved addresses.

<!-- TOC --><a name="futurevoid-_addnewaddressstring-title-string-address-async"></a>
#### `Future<void> _addNewAddress(String title, String address) async`

- Adds a new address to the user's saved addresses in Firestore.

<!-- TOC --><a name="futurevoid-_editaddressint-index-string-title-string-address-async"></a>
#### `Future<void> _editAddress(int index, String title, String address) async`

- Edits an existing address in the user's saved addresses.

<!-- TOC --><a name="futurevoid-_setmainaddressint-index-async"></a>
#### `Future<void> _setMainAddress(int index) async`

- Sets the specified address as the main address for the user.

<!-- TOC --><a name="futurevoid-_deleteaddressint-indextodelete-async"></a>
#### `Future<void> _deleteAddress(int indexToDelete) async`

- Deletes the specified address from the user's saved addresses.

<!-- TOC --><a name="void-_showaddaddressdialog"></a>
#### `void _showAddAddressDialog()`

- Displays a dialog for the user to input a new address.

<!-- TOC --><a name="void-_showeditaddressdialogint-index"></a>
#### `void _showEditAddressDialog(int index)`

- Displays a dialog for the user to edit an existing address.

<!-- TOC --><a name="void-_showdeleteconfirmationdialogint-index"></a>
#### `void _showDeleteConfirmationDialog(int index)`

- Displays a confirmation dialog before deleting an address.

<!-- TOC --><a name="futurelistmapstring-dynamic-_fetchcartitems-async"></a>
#### `Future<List<Map<String, dynamic>>> _fetchCartItems() async`

- Fetches the items in the user's cart from Firestore.

<!-- TOC --><a name="futuredecimal-_calculatetax-async"></a>
#### `Future<Decimal> _calculateTax() async`

- Calculates the total tax for the items in the user's cart.

<!-- TOC --><a name="build-method-7"></a>
### Build Method

<!-- TOC --><a name="override-widget-buildbuildcontext-context-18"></a>
#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `PaymentPage`.
- Displays the total amount, including items, tax, and total.
- Provides a list of addresses for the user to select from.
- Includes a button to initiate the payment process.

<!-- TOC --><a name="razorpaypayment"></a>
## RazorpayPayment

<!-- TOC --><a name="overview-23"></a>
### Overview

The `RazorpayPayment` class provides an interface for handling payments using the Razorpay payment gateway. It manages the payment process, including opening the checkout, handling payment success, errors, and external wallet responses.

<!-- TOC --><a name="features-22"></a>
### Features

- **Payment Processing**: Initiates the payment process and handles the response from Razorpay.
- **Event Handling**: Listens for payment success, error, and external wallet events.
- **Completer for Asynchronous Handling**: Uses a `Completer` to manage the asynchronous nature of the payment process.

<!-- TOC --><a name="constructor-15"></a>
### Constructor

<!-- TOC --><a name="razorpaypayment-1"></a>
#### `RazorpayPayment()`

- Initializes the Razorpay instance and sets up event listeners for payment success, error, and external wallet events.

<!-- TOC --><a name="methods-11"></a>
### Methods

<!-- TOC --><a name="void-dispose"></a>
#### `void dispose()`

- Cleans up the Razorpay instance by calling the `clear` method to prevent memory leaks.

<!-- TOC --><a name="futurestring-opencheckoutdouble-amount"></a>
#### `Future<String> openCheckout(double amount)`

- Opens the Razorpay checkout interface for the user to complete the payment.
- **Parameters**:
  - `amount`: The total amount to be charged, in double format.
- **Returns**: A `Future<String>` that resolves to the payment result ('success', 'failure', or 'external_wallet').
- **Throws**: Completes with an error if the checkout cannot be opened.

<!-- TOC --><a name="void-_handlepaymentsuccesspaymentsuccessresponse-response"></a>
#### `void _handlePaymentSuccess(PaymentSuccessResponse response)`

- Handles the event when a payment is successful.
- Completes the payment completer with a success message and logs the payment ID.

<!-- TOC --><a name="void-_handlepaymenterrorpaymentfailureresponse-response"></a>
#### `void _handlePaymentError(PaymentFailureResponse response)`

- Handles the event when a payment fails.
- Completes the payment completer with a failure message and logs the error code and message.

<!-- TOC --><a name="void-_handleexternalwalletexternalwalletresponse-response"></a>
#### `void _handleExternalWallet(ExternalWalletResponse response)`

- Handles the event when an external wallet is used for payment.
- Completes the payment completer with a message indicating the use of an external wallet and logs the wallet name.

<!-- TOC --><a name="function-1"></a>
### Function

<!-- TOC --><a name="futurestring-initiatepaymentdecimal-amount"></a>
#### `Future<String> initiatePayment(Decimal amount)`

- Initiates the payment process by creating an instance of `RazorpayPayment` and calling the `openCheckout` method.
- **Parameters**:
  - `amount`: The total amount to be charged, in `Decimal` format.
- **Returns**: A `Future<String>` that resolves to the payment result.
- **Handles**: Catches any errors during the payment initiation and ensures the Razorpay instance is disposed of after use.

<!-- TOC --><a name="addresscard"></a>
## AddressCard

<!-- TOC --><a name="overview-24"></a>
### Overview

The `AddressCard` class is a stateless widget that represents a single address entry in the user interface. It displays the address details and provides options to edit, delete, and select the address as the shipping address. This component is commonly used in forms where users can manage their shipping addresses.

<!-- TOC --><a name="features-23"></a>
### Features

- **Display Address Information**: Shows the name and address details in a structured format.
- **Edit and Delete Options**: Provides buttons to edit or delete the address.
- **Selection Mechanism**: Allows users to select the address as their shipping address with a checkbox.

<!-- TOC --><a name="constructor-16"></a>
### Constructor

<!-- TOC --><a name="addresscard-1"></a>
#### `AddressCard`

- **Parameters**:
  - `index`: A required integer that uniquely identifies the card.
  - `name`: A required string representing the name associated with the address.
  - `address`: A required string representing the full address.
  - `isSelected`: A required boolean indicating whether this address is currently selected.
  - `onSelected`: A required callback function that is called when the address is selected.
  - `onEdit`: A required callback function that is called when the edit button is pressed.
  - `onMainAddressChanged`: A required callback function that is called when the main address selection changes.
  - `onDelete`: A required callback function that is called when the delete button is pressed.

<!-- TOC --><a name="build-method-8"></a>
### Build Method

<!-- TOC --><a name="override-widget-buildbuildcontext-context-19"></a>
#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `AddressCard`.
- **Card Layout**: The card is styled with rounded corners and a shadow for visual separation.
- **Address Display**: Displays the name in bold and the address below it.
- **Edit and Delete Buttons**: Provides an edit button and a delete icon button for user interaction.
- **Selection Checkbox**: Displays a checkbox that indicates whether the address is selected. Tapping on this checkbox triggers the `onSelected` callback.

<!-- TOC --><a name="addressdialog"></a>
## AddressDialog

<!-- TOC --><a name="overview-25"></a>
### Overview

The `AddressDialog` class is a stateless widget that presents a dialog for users to input or edit an address. It provides text fields for entering the title and address, along with options to save or cancel the action. This dialog is typically used in forms where users need to manage their shipping addresses.

<!-- TOC --><a name="features-24"></a>
### Features

- **Input Fields**: Provides text fields for users to enter the title and address.
- **Save and Cancel Actions**: Includes buttons to save the entered data or cancel the operation.
- **Initial Values**: Supports pre-filling the text fields with initial values for editing existing addresses.

<!-- TOC --><a name="constructor-17"></a>
### Constructor

<!-- TOC --><a name="addressdialog-1"></a>
#### `AddressDialog`

- **Parameters**:
  - `title`: A required string that specifies the title of the dialog.
  - `initialTitle`: An optional string that provides the initial title for the text field (used when editing an address).
  - `initialAddress`: An optional string that provides the initial address for the text field (used when editing an address).
  - `onSave`: A required callback function that is called when the user saves the address. It takes two parameters: the title and the address as strings.

<!-- TOC --><a name="build-method-9"></a>
### Build Method

<!-- TOC --><a name="override-widget-buildbuildcontext-context-20"></a>
#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `AddressDialog`.
- **Text Editing Controllers**: Initializes `TextEditingController` instances for the title and address fields, using the initial values if provided.
- **AlertDialog**: Returns an `AlertDialog` widget that includes:
  - A title displaying the dialog's title.
  - A content section containing two `TextField` widgets for user input (title and address).
  - Action buttons for canceling or saving the input:
    - **Cancel Button**: Closes the dialog without saving.
    - **Save Button**: Calls the `onSave` callback with the current text from the title and address fields.

<!-- TOC --><a name="profilescreen"></a>
## ProfileScreen

<!-- TOC --><a name="overview-26"></a>
### Overview

The `ProfileScreen` class is a stateful widget that represents the user's profile page within the application. It displays user account information, including the number of shipping addresses, order history, and payment methods. The screen also provides options for logging out.

<!-- TOC --><a name="features-25"></a>
### Features

- **User Account Header**: Displays the user's account information at the top of the profile screen.
- **Profile List Tiles**: Provides interactive list tiles for navigating to different sections such as orders, shipping addresses, and payment methods.
- **Logout Functionality**: Allows users to log out of their account.

<!-- TOC --><a name="constructor-18"></a>
### Constructor

<!-- TOC --><a name="profilescreen-1"></a>
#### `ProfileScreen`

- **Parameters**: 
  - `key`: An optional key that can be used to control the widget's identity in the widget tree.

<!-- TOC --><a name="state-management-8"></a>
### State Management

<!-- TOC --><a name="_profilescreenstate"></a>
#### `_ProfileScreenState`

- **Attributes**:
  - `_addressCount`: An integer that holds the count of the user's saved shipping addresses.

<!-- TOC --><a name="override-void-initstate-1"></a>
#### `@override void initState()`

- Initializes the state and fetches the address count when the widget is first created.

<!-- TOC --><a name="futurevoid-_fetchaddresscount-async"></a>
#### `Future<void> _fetchAddressCount() async`

- Asynchronously fetches the count of shipping addresses from Firestore for the currently logged-in user.
- Updates the `_addressCount` state variable with the fetched value.

<!-- TOC --><a name="void-_handlelogoutbuildcontext-context-async"></a>
#### `void _handleLogout(BuildContext context) async`

- Handles the logout process by signing the user out of Firebase Authentication.

<!-- TOC --><a name="build-method-10"></a>
### Build Method

<!-- TOC --><a name="override-widget-buildbuildcontext-context-21"></a>
#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `ProfileScreen`.
- **Scaffold**: Uses a `Scaffold` widget to provide the basic material design layout.
- **AppBar**: Displays a generic app bar with the title "Profile".
- **ListView**: Contains a list of profile-related items, including:
  - A user account header.
  - List tiles for navigating to "My Orders", "Shipping Addresses", and "Payment Methods".
  - A logout button.

<!-- TOC --><a name="widget-_buildprofilelisttile"></a>
#### `Widget _buildProfileListTile(...)`

- A helper method that constructs a `ProfileListTile` widget with the provided icon, title, subtitle, and tap handler.

<!-- TOC --><a name="void-_navigatetobuildcontext-context-widget-page"></a>
#### `void _navigateTo(BuildContext context, Widget page)`

- A helper method that navigates to a specified page using a `MaterialPageRoute`.

<!-- TOC --><a name="myorderspage"></a>
## MyOrdersPage

<!-- TOC --><a name="overview-27"></a>
### Overview

The `MyOrdersPage` class is a stateful widget that displays the user's order history in a tabbed interface. It allows users to view their orders categorized by status: Delivered, Processing, and Cancelled. This page enhances the user experience by providing a clear and organized way to manage and review past orders.

<!-- TOC --><a name="features-26"></a>
### Features

- **Tabbed Navigation**: Users can switch between different order statuses using tabs.
- **Order List Display**: Each tab displays a list of orders corresponding to the selected status.

<!-- TOC --><a name="constructor-19"></a>
### Constructor

<!-- TOC --><a name="myorderspage-1"></a>
#### `MyOrdersPage`

- **Parameters**: 
  - `key`: An optional key that can be used to control the widget's identity in the widget tree.

<!-- TOC --><a name="state-management-9"></a>
### State Management

<!-- TOC --><a name="_myorderspagestate"></a>
#### `_MyOrdersPageState`

- **Attributes**:
  - `_tabController`: A `TabController` that manages the tab selection and animation.

<!-- TOC --><a name="override-void-initstate-2"></a>
#### `@override void initState()`

- Initializes the state and creates a `TabController` with three tabs (for Delivered, Processing, and Cancelled orders).

<!-- TOC --><a name="override-void-dispose"></a>
#### `@override void dispose()`

- Disposes of the `_tabController` to free up resources when the widget is removed from the widget tree.

<!-- TOC --><a name="build-method-11"></a>
### Build Method

<!-- TOC --><a name="override-widget-buildbuildcontext-context-22"></a>
#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `MyOrdersPage`.
- **Scaffold**: Uses a `Scaffold` widget to provide the basic material design layout.
- **AppBar**: Displays a custom app bar (`OrdersAppBar`) that includes the tab controller.
- **TabBarView**: Contains a `TabBarView` that displays different `OrderList` widgets based on the selected tab:
  - **Delivered**: Displays orders that have been delivered.
  - **Processing**: Displays orders that are currently being processed.
  - **Cancelled**: Displays orders that have been cancelled.

<!-- TOC --><a name="orderlist"></a>
## OrderList

<!-- TOC --><a name="overview-28"></a>
### Overview

The `OrderList` class is a stateless widget that displays a list of orders based on their status. It utilizes a `ListView` to create a scrollable list of `OrderCard` widgets, each representing an individual order. This component is designed to be reusable for different order statuses such as Delivered, Processing, and Cancelled.

<!-- TOC --><a name="features-27"></a>
### Features

- **Dynamic Order Display**: Renders a list of orders based on the provided status.
- **Reusability**: Can be used in various contexts where order lists are needed, simply by passing different statuses.

<!-- TOC --><a name="constructor-20"></a>
### Constructor

<!-- TOC --><a name="orderlist-1"></a>
#### `OrderList`

- **Parameters**:
  - `status`: A required string that specifies the status of the orders to be displayed (e.g., 'Delivered', 'Processing', 'Cancelled').

<!-- TOC --><a name="build-method-12"></a>
### Build Method

<!-- TOC --><a name="override-widget-buildbuildcontext-context-23"></a>
#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `OrderList`.
- **ListView.builder**: Utilizes a `ListView.builder` to efficiently create a scrollable list of order cards:
  - **itemCount**: Set to 3, indicating that three order cards will be displayed. This can be modified to reflect the actual number of orders in a real implementation.
  - **itemBuilder**: A function that builds each `OrderCard` widget, passing the current order's status to it.

<!-- TOC --><a name="ordersappbar-class-documentation"></a>
# OrdersAppBar Class Documentation

<!-- TOC --><a name="overview-29"></a>
## Overview

The `OrdersAppBar` class is a stateless widget that represents the app bar for the "My Orders" screen. It includes a title, navigation buttons, and a tab bar for switching between different order statuses. This component enhances the user interface by providing a consistent and functional navigation experience.

<!-- TOC --><a name="features-28"></a>
## Features

- **Back Navigation**: Includes a back button for navigating to the previous screen.
- **Title Display**: Shows the title "My Orders" prominently in the center of the app bar.
- **Action Buttons**: Provides buttons for search and additional actions.
- **Tab Navigation**: Integrates a tab bar for switching between order statuses (Delivered, Processing, Cancelled).

<!-- TOC --><a name="constructor-21"></a>
## Constructor

<!-- TOC --><a name="ordersappbar"></a>
### `OrdersAppBar`

- **Parameters**:
  - `tabController`: A required `TabController` that manages the state of the tab bar.

<!-- TOC --><a name="build-method-13"></a>
## Build Method

<!-- TOC --><a name="override-widget-buildbuildcontext-context-24"></a>
### `@override Widget build(BuildContext context)`

- Constructs the UI for the `OrdersAppBar`.
- **AppBar**: Returns an `AppBar` widget with the following components:
  - **Leading**: A back button that allows users to return to the previous screen.
  - **Background Color**: Sets the background color of the app bar to black.
  - **Title**: Displays the title "My Orders" in white text.
  - **Center Title**: Centers the title within the app bar.
  - **Actions**: Includes two icon buttons:
    - **Search Button**: A button for initiating a search action (currently a placeholder).
    - **More Actions Button**: A button for additional actions (currently a placeholder).
  - **Bottom**: Integrates the `OrdersTabBar`, passing the `tabController` to manage tab selection.

<!-- TOC --><a name="preferred-size"></a>
## Preferred Size

<!-- TOC --><a name="override-size-get-preferredsize-2"></a>
### `@override Size get preferredSize`

- Returns the preferred size of the app bar, which includes the height of the toolbar and the tab bar.

<!-- TOC --><a name="orderstabbar"></a>
## OrdersTabBar

<!-- TOC --><a name="overview-30"></a>
### Overview

The `OrdersTabBar` class is a stateless widget that represents the tab bar for the "My Orders" screen. It allows users to switch between different order statuses, enhancing navigation and organization within the app.

<!-- TOC --><a name="features-29"></a>
### Features

- **Tab Navigation**: Provides tabs for different order statuses (Delivered, Processing, Cancelled).
- **Customizable Appearance**: Allows customization of label colors and styles.

<!-- TOC --><a name="constructor-22"></a>
### Constructor

<!-- TOC --><a name="orderstabbar-1"></a>
#### `OrdersTabBar`

- **Parameters**:
  - `tabController`: A required `TabController` that manages the state of the tabs.

<!-- TOC --><a name="build-method-14"></a>
### Build Method

<!-- TOC --><a name="override-widget-buildbuildcontext-context-25"></a>
#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `OrdersTabBar`.
- **TabBar**: Returns a `TabBar` widget with the following properties:
  - **Controller**: Uses the provided `tabController` to manage tab selection.
  - **Label Color**: Sets the color of the selected tab label to white.
  - **Indicator Color**: Sets the color of the tab indicator to white.
  - **Unselected Label Color**: Sets the color of unselected tab labels to white.
  - **Label Style**: Defines the font size for the tab labels.
  - **Tabs**: Creates three tabs for different order statuses.

<!-- TOC --><a name="preferred-size-1"></a>
### Preferred Size

<!-- TOC --><a name="override-size-get-preferredsize-3"></a>
#### `@override Size get preferredSize`

- Returns the preferred size of the tab bar, which is set to the height of the tab bar.

<!-- TOC --><a name="ordercard"></a>
## OrderCard

<!-- TOC --><a name="overview-31"></a>
### Overview

The `OrderCard` class is a stateless widget that represents an individual order's details in the user interface. It displays essential information about the order, including the order number, tracking number, quantity, total amount, and the order status. This component is designed to be reusable within the order management sections of the application.

<!-- TOC --><a name="features-30"></a>
### Features

- **Order Information Display**: Shows key details about the order, such as order number, tracking number, quantity, and total amount.
- **Action Buttons**: Provides buttons for viewing more details about the order and for handling status actions.
- **Dynamic Status Color**: Changes the color of the status button based on the order's status.

<!-- TOC --><a name="constructor-23"></a>
### Constructor

<!-- TOC --><a name="ordercard-1"></a>
#### `OrderCard`

- **Parameters**:
  - `status`: A required string that indicates the current status of the order (e.g., 'Delivered', 'Processing', 'Cancelled').

<!-- TOC --><a name="build-method-15"></a>
### Build Method

<!-- TOC --><a name="override-widget-buildbuildcontext-context-26"></a>
#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `OrderCard`.
- **Card Widget**: Uses a `Card` widget to provide a material design look with elevation and rounded corners.
- **Padding**: Applies padding around the card's content for better spacing.
- **Column Layout**: Organizes the content in a vertical column:
  - **Order Number**: Displays a static order number.
  - **Tracking Number**: Displays the tracking number associated with the order.
  - **Quantity and Total Amount**: Displays the quantity of items and the total amount in a row, with the total amount styled in green.
  - **Details Button**: An `OutlinedButton` that triggers an action to view more details about the order.
  - **Status Button**: A `TextButton` that displays the order's status, with its color changing based on the status (green for 'Delivered', black for others).

<!-- TOC --><a name="profilelisttile"></a>
## ProfileListTile

<!-- TOC --><a name="overview-32"></a>
### Overview

The `ProfileListTile` class is a stateless widget that represents a customizable list tile for displaying profile-related information in a Flutter application. It includes an icon, a title, a subtitle, and a tap action, making it suitable for use in profile screens or settings menus.

<!-- TOC --><a name="features-31"></a>
### Features

- **Icon Display**: Shows an icon on the left side of the list tile.
- **Title and Subtitle**: Displays a title and a subtitle, allowing for additional context or information.
- **Tap Action**: Provides a callback function that is triggered when the list tile is tapped, enabling navigation or other actions.

<!-- TOC --><a name="constructor-24"></a>
### Constructor

<!-- TOC --><a name="profilelisttile-1"></a>
#### `ProfileListTile`

- **Parameters**:
  - `icon`: A required `IconData` that specifies the icon to be displayed on the list tile.
  - `title`: A required string that represents the main title of the list tile.
  - `subtitle`: A required string that provides additional information or context below the title.
  - `onTap`: A required `VoidCallback` that is called when the list tile is tapped.

<!-- TOC --><a name="build-method-16"></a>
### Build Method

<!-- TOC --><a name="override-widget-buildbuildcontext-context-27"></a>
#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `ProfileListTile`.
- **ListTile Widget**: Returns a `ListTile` widget with the following components:
  - **Leading Icon**: Displays the provided icon on the left side of the tile.
  - **Title**: Displays the title in black text.
  - **Subtitle**: Displays the subtitle in black text below the title.
  - **Trailing Icon**: Shows a right arrow icon (`Icons.navigate_next`) on the right side, indicating that the tile is tappable.
  - **OnTap**: Assigns the provided `onTap` callback to the `onTap` property of the `ListTile`, allowing for interaction.

<!-- TOC --><a name="useraccountheader"></a>
## UserAccountHeader

<!-- TOC --><a name="overview-33"></a>
### Overview

The `UserAccountHeader` class is a stateless widget that displays the user's account information in a header format, typically used in a drawer or profile section of a Flutter application. It retrieves the user's name from Firestore based on their email and displays it along with the user's email address and a default profile picture.

<!-- TOC --><a name="features-32"></a>
### Features

- **User Information Retrieval**: Fetches the user's full name from Firestore based on their email address.
- **Loading and Error States**: Displays appropriate loading indicators and error messages while fetching user data.
- **Default Fallback**: If the user's full name is not available, it uses the part of the email before the '@' as a fallback.

<!-- TOC --><a name="constructor-25"></a>
### Constructor

<!-- TOC --><a name="useraccountheader-1"></a>
#### `UserAccountHeader`

- **Parameters**:
  - `key`: An optional key that can be used to control the widget's identity in the widget tree.

<!-- TOC --><a name="methods-12"></a>
### Methods

<!-- TOC --><a name="futurestring-getusernamestring-email-async"></a>
#### `Future<String?> getUserName(String email) async`

- **Parameters**:
  - `email`: A string representing the user's email address.
- **Returns**: A `Future` that resolves to the user's full name or `null` if no document is found.
- **Description**: 
  - Queries the Firestore database for the user's profile data based on the provided email.
  - If a document is found, it retrieves the `fullName` field. If this field is empty, it returns the part of the email before the '@' symbol. If no document is found, it returns `null`.

<!-- TOC --><a name="build-method-17"></a>
### Build Method

<!-- TOC --><a name="override-widget-buildbuildcontext-context-28"></a>
#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `UserAccountHeader`.
- **User Retrieval**: Uses `FirebaseAuth` to get the currently logged-in user and their email.
- **FutureBuilder**: Utilizes a `FutureBuilder` to handle the asynchronous fetching of the user's name:
  - **Loading State**: Displays a loading indicator while waiting for the data.
  - **Error State**: Displays an error message if there is an issue fetching the data.
  - **Data State**: Displays the user's email and a default profile picture if the data is successfully retrieved.

<!-- TOC --><a name="ui-components"></a>
### UI Components

- **UserAccountsDrawerHeader**: 
  - Displays the user's email address.
  - Shows a default profile picture using a `CircleAvatar`.
  - The header has a black background for styling.

<!-- TOC --><a name="shippingaddressesscreen"></a>
## ShippingAddressesScreen

<!-- TOC --><a name="overview-34"></a>
### Overview

The `ShippingAddressesScreen` class is a stateful widget that manages the display and manipulation of a user's shipping addresses within a Flutter application. It allows users to view, add, edit, and delete their shipping addresses, as well as set a primary address.

<!-- TOC --><a name="features-33"></a>
### Features

- **Address Management**: Users can view a list of their saved addresses, add new addresses, edit existing ones, and delete addresses.
- **User Authentication**: Ensures that the user is logged in before allowing any address-related operations.
- **Dynamic UI Updates**: Automatically refreshes the address list after any changes (add, edit, delete).

<!-- TOC --><a name="constructor-26"></a>
### Constructor

<!-- TOC --><a name="shippingaddressesscreen-1"></a>
#### `ShippingAddressesScreen`

- **Parameters**: None.

<!-- TOC --><a name="state-management-10"></a>
### State Management

<!-- TOC --><a name="_shippingaddressesscreenstate"></a>
#### `_ShippingAddressesScreenState`

- **Attributes**:
  - `_selectedAddress`: An optional integer that holds the index of the currently selected address.
  - `addresses`: A list of maps that stores the user's addresses, where each map contains details about an address.

<!-- TOC --><a name="override-void-initstate-3"></a>
#### `@override void initState()`

- Initializes the state and fetches the user's addresses when the widget is first created.

<!-- TOC --><a name="methods-13"></a>
### Methods

<!-- TOC --><a name="void-_toggleselectionint-index"></a>
#### `void _toggleSelection(int? index)`

- Toggles the selection of an address based on its index. If the address is already selected, it deselects it; otherwise, it selects the new address.

<!-- TOC --><a name="futurevoid-_fetchaddresses-async-1"></a>
#### `Future<void> _fetchAddresses() async`

- Fetches the user's addresses from Firestore:
  - Checks if the user is logged in.
  - Retrieves the user's document from Firestore and extracts the addresses.
  - Updates the state with the fetched addresses.

<!-- TOC --><a name="futurevoid-_addnewaddressstring-title-string-address-async-1"></a>
#### `Future<void> _addNewAddress(String title, String address) async`

- Adds a new address to the user's list:
  - Checks if the user is logged in.
  - Updates the Firestore document to include the new address and increments the address count.

<!-- TOC --><a name="futurevoid-_editaddressint-index-string-title-string-address-async-1"></a>
#### `Future<void> _editAddress(int index, String title, String address) async`

- Edits an existing address:
  - Checks if the user is logged in.
  - Updates the specified address in Firestore.

<!-- TOC --><a name="futurevoid-_setmainaddressint-index-async-1"></a>
#### `Future<void> _setMainAddress(int index) async`

- Sets the specified address as the main address:
  - Checks if the user is logged in.
  - Updates the Firestore document to mark the selected address as the main address and updates others accordingly.

<!-- TOC --><a name="futurevoid-_deleteaddressint-indextodelete-async-1"></a>
#### `Future<void> _deleteAddress(int indexToDelete) async`

- Deletes an address from the user's list:
  - Checks if the user is logged in.
  - Uses a Firestore batch operation to delete the address and shift subsequent addresses.
  - Updates the address count in Firestore.

<!-- TOC --><a name="build-method-18"></a>
### Build Method

<!-- TOC --><a name="override-widget-buildbuildcontext-context-29"></a>
#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `ShippingAddressesScreen`:
  - **AppBar**: Displays a generic app bar with the title "Shipping Address".
  - **ListView**: Displays the list of addresses using a `ListView.builder`.
  - **Floating Action Button**: Provides a button to add a new address.

<!-- TOC --><a name="ui-components-1"></a>
### UI Components

- **AddressCard**: A custom widget that displays each address with options to select, edit, or delete.
- **Dialogs**: Utilizes dialog boxes for adding, editing, and confirming deletions of addresses.

<!-- TOC --><a name="productcard"></a>
## ProductCard

<!-- TOC --><a name="overview-35"></a>
### Overview

The `ProductCard` class is a stateful widget that displays detailed information about a specific product in a Flutter application. It fetches product images, displays them in a carousel, and provides options for users to view related products, add the product to their cart, and see additional product details.

<!-- TOC --><a name="features-34"></a>
### Features

- **Image Carousel**: Displays a carousel of product images that users can swipe through.
- **Dynamic Fields**: Shows additional product information based on the product's details.
- **Recently Viewed Products**: Keeps track of and displays products that the user has recently viewed.
- **Users Also Viewed**: Suggests products that other users have viewed in the same category.
- **Navigation**: Provides a bottom navigation bar for easy access to the home, bag, and profile screens.

<!-- TOC --><a name="constructor-27"></a>
### Constructor

<!-- TOC --><a name="productcard-1"></a>
#### `ProductCard`

- **Parameters**:
  - `documentId`: A required string that uniquely identifies the product document in Firestore.

<!-- TOC --><a name="state-management-11"></a>
### State Management

<!-- TOC --><a name="_productcardstate"></a>
#### `_ProductCardState`

- **Attributes**:
  - `selectedImageIndex`: An integer that tracks the currently selected image in the carousel.
  - `selectedParentImageIndex`: An integer for tracking the selected parent image.
  - `imageDetails`: A list of maps containing image URLs and document IDs for the product images.
  - `allImageUrls`: A list of all image URLs for the product.
  - `recentlyViewedDetails`: A list of maps containing details of recently viewed products.
  - `usersAlsoViewedDetails`: A list of maps containing details of products that users also viewed.
  - `isLoading`: A boolean indicating whether the product data is still being loaded.
  - `currentDocumentId`: A string that holds the current product's document ID.
  - `currentCategoryValue`: A string that holds the current category value of the product.

<!-- TOC --><a name="override-void-initstate-4"></a>
#### `@override void initState()`

- Initializes the state and fetches product images and recently viewed products when the widget is first created.

<!-- TOC --><a name="methods-14"></a>
### Methods

<!-- TOC --><a name="futurevoid-fetchimagesstring-documentid-async"></a>
#### `Future<void> fetchImages(String documentId) async`

- Fetches images for the specified product from Firestore and Firebase Storage:
  - Retrieves the product document and its associated images.
  - Updates the state with the fetched image URLs and details.

<!-- TOC --><a name="futurevoid-updaterecentlyviewedproductsstring-documentid-async"></a>
#### `Future<void> updateRecentlyViewedProducts(String documentId) async`

- Updates the list of recently viewed products for the current user:
  - Checks if the user is logged in and updates their recently viewed products in Firestore.

<!-- TOC --><a name="futurevoid-fetchrecentlyviewedproducts-async"></a>
#### `Future<void> fetchRecentlyViewedProducts() async`

- Fetches the user's recently viewed products from Firestore and updates the state.

<!-- TOC --><a name="futurevoid-fetchusersalsoviewedproductsstring-categoryvalue-async"></a>
#### `Future<void> fetchUsersAlsoViewedProducts(String categoryValue) async`

- Fetches products that users also viewed based on the current product's category and updates the state.

<!-- TOC --><a name="void-_onitemtappedint-index"></a>
#### `void _onItemTapped(int index)`

- Handles navigation when an item in the bottom navigation bar is tapped:
  - Navigates to the appropriate screen based on the selected index.

<!-- TOC --><a name="build-method-19"></a>
### Build Method

<!-- TOC --><a name="override-widget-buildbuildcontext-context-30"></a>
#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `ProductCard`:
  - Displays a loading indicator while data is being fetched.
  - Shows the product name, image carousel, dynamic fields, and sections for users also viewed and recently viewed products.
  - Includes a bottom navigation bar for easy navigation.

<!-- TOC --><a name="ui-components-2"></a>
### UI Components

- **ImageCarousel**: Displays the product images in a carousel format.
- **MoreColoursSection**: Shows additional color options for the product.
- **DynamicFieldsDisplay**: Displays dynamic fields related to the product.
- **OrderSwatchesButton**: Provides options for selecting product variations.
- **AddToCartButton**: Allows users to add the product to their shopping cart.
- **UsersAlsoViewedSection**: Displays products that other users have viewed.
- **RecentlyViewedSection**: Displays products that the user has recently viewed.

<!-- TOC --><a name="addtocartbutton"></a>
## AddToCartButton

<!-- TOC --><a name="overview-36"></a>
### Overview

The `AddToCartButton` class is a stateful widget that allows users to select product designs and add them to their shopping cart in a Flutter application. It provides a user interface for selecting images, specifying order lengths, and validating inputs before adding items to the cart.

<!-- TOC --><a name="features-35"></a>
### Features

- **Image Selection**: Users can select product images to add to their cart.
- **Length Specification**: Users can specify the order length for each selected design using a slider.
- **Validation**: Ensures that the selected lengths meet the minimum order requirements before adding items to the cart.
- **Logging**: Utilizes logging to track actions and errors throughout the process.

<!-- TOC --><a name="constructor-28"></a>
### Constructor

<!-- TOC --><a name="addtocartbutton-1"></a>
#### `AddToCartButton`

- **Parameters**:
  - `documentIds`: A required list of strings representing the document IDs of the products to be added to the cart.

<!-- TOC --><a name="state-management-12"></a>
### State Management

<!-- TOC --><a name="_addtocartbuttonstate"></a>
#### `_AddToCartButtonState`

- **Attributes**:
  - `showDetails`: A boolean indicating whether the details section is expanded.
  - `selectedImages`: A list of booleans tracking which images have been selected.
  - `selectedLengths`: A list of doubles representing the lengths selected for each product.
  - `imageUrls`: A list of strings containing the URLs of the product images.
  - `minimumOrderLengths`: A map that associates each document ID with its minimum order length.
  - `validationErrors`: A map that tracks validation errors for each selected item.

<!-- TOC --><a name="override-void-initstate-5"></a>
#### `@override void initState()`

- Initializes the state and fetches image URLs when the widget is first created. It also sets up the selected images and lengths.

<!-- TOC --><a name="methods-15"></a>
### Methods

<!-- TOC --><a name="futurevoid-fetchimageurls-async"></a>
#### `Future<void> fetchImageUrls() async`

- Fetches the image URLs for the products based on their document IDs:
  - Retrieves each product document from Firestore and extracts the image locations and minimum order lengths.
  - Updates the state with the fetched image URLs.

<!-- TOC --><a name="void-validateinputs"></a>
#### `void validateInputs()`

- Validates the selected lengths against the minimum order lengths:
  - Populates the `validationErrors` map with any errors found during validation.

<!-- TOC --><a name="futurevoid-_addtocart-async"></a>
#### `Future<void> _addToCart() async`

- Adds the selected items to the user's cart:
  - Checks if the user is logged in; if not, displays a message.
  - For each selected image, fetches the price and tax from Firestore, calculates the total price, and adds the item to the user's cart in Firestore.

<!-- TOC --><a name="build-method-20"></a>
### Build Method

<!-- TOC --><a name="override-widget-buildbuildcontext-context-31"></a>
#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `AddToCartButton`:
  - Displays an `ExpansionTile` that can be expanded to show more details.
  - Lists the product images with selection options and length sliders.
  - Includes a button to add the selected designs to the cart, which triggers validation and the add-to-cart process.

<!-- TOC --><a name="ui-components-3"></a>
### UI Components

- **ImageSelector**: A custom widget that allows users to select an image.
- **LengthSlider**: A slider that allows users to specify the order length for the selected design.
- **ElevatedButton**: A button that adds the selected designs to the cart, with validation checks.

<!-- TOC --><a name="imagecarousel"></a>
## ImageCarousel

<!-- TOC --><a name="overview-37"></a>
### Overview

The `ImageCarousel` class is a stateless widget that displays a carousel of images for a product in a Flutter application. It allows users to view a selected image and provides thumbnail navigation for selecting different images.

<!-- TOC --><a name="features-36"></a>
### Features

- **Image Display**: Shows the currently selected image prominently.
- **Thumbnail Navigation**: Provides a row of thumbnail images that users can tap to change the displayed image.
- **Customizable Callbacks**: Allows for custom actions when a thumbnail is tapped.

<!-- TOC --><a name="constructor-29"></a>
### Constructor

<!-- TOC --><a name="imagecarousel-1"></a>
#### `ImageCarousel`

- **Parameters**:
  - `allImageUrls`: A required list of strings containing the URLs of all images to be displayed in the carousel.
  - `selectedImageIndex`: A required integer representing the index of the currently selected image.
  - `onThumbnailTap`: A required callback function that is called when a thumbnail is tapped, passing the index of the tapped thumbnail.

<!-- TOC --><a name="build-method-21"></a>
### Build Method

<!-- TOC --><a name="override-widget-buildbuildcontext-context-32"></a>
#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `ImageCarousel`:
  - **Column Widget**: Organizes the image display and thumbnails vertically.
  - **ImagePlaceholder**: Displays the currently selected image using the `ImagePlaceholder` widget, which takes the URL of the selected image.
  - **ImageThumbnails**: Displays a list of thumbnails using the `ImageThumbnails` widget, passing the image details, the currently selected index, and the thumbnail tap callback.

<!-- TOC --><a name="morecolourssection"></a>
## MoreColoursSection

<!-- TOC --><a name="overview-38"></a>
### Overview

The `MoreColoursSection` class is a stateless widget that displays a section for selecting additional color options for a product in a Flutter application. It presents a title and a set of image thumbnails that represent different color variations of the product.

<!-- TOC --><a name="features-37"></a>
### Features

- **Color Selection**: Allows users to view and select different color options for a product.
- **Customizable Callbacks**: Provides a callback function that is triggered when a thumbnail is tapped, enabling interaction with the selected color.

<!-- TOC --><a name="constructor-30"></a>
### Constructor

<!-- TOC --><a name="morecolourssection-1"></a>
#### `MoreColoursSection`

- **Parameters**:
  - `imageDetails`: A required list of maps containing details about the images representing different colors. Each map should include the image URL and any other relevant information.
  - `selectedParentImageIndex`: A required integer that indicates the index of the currently selected color thumbnail.
  - `onThumbnailTap`: A required callback function that is called when a thumbnail is tapped, passing the index of the tapped thumbnail.

<!-- TOC --><a name="build-method-22"></a>
### Build Method

<!-- TOC --><a name="override-widget-buildbuildcontext-context-33"></a>
#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `MoreColoursSection`:
  - **Container**: Wraps the section in a container with a light grey background.
  - **Column**: Organizes the title and thumbnails vertically.
  - **Padding**: Adds padding around the title text for better spacing.
  - **Text**: Displays the title "More Colours" with specified styling (font family, size, and weight).
  - **Divider**: Adds a horizontal line to separate the title from the thumbnails.
  - **ImageThumbnails**: Displays the thumbnails using the `ImageThumbnails` widget, passing the image details, the currently selected index, and the thumbnail tap callback.

<!-- TOC --><a name="orderswatchesbutton"></a>
## OrderSwatchesButton

<!-- TOC --><a name="overview-39"></a>
### Overview

The `OrderSwatchesButton` class is a stateful widget that allows users to select fabric swatches and add them to their shopping cart in a Flutter application. It fetches image URLs for the swatches from Firestore and provides an interface for users to select and order them.

<!-- TOC --><a name="features-38"></a>
### Features

- **Swatch Selection**: Users can tap on swatch images to select or deselect them.
- **Dynamic Image Loading**: Fetches swatch images from Firebase Storage based on document IDs.
- **Cart Integration**: Allows users to add selected swatches to their cart, with validation to ensure at least one swatch is selected.
- **User Authentication**: Checks if the user is logged in before allowing them to add items to the cart.

<!-- TOC --><a name="constructor-31"></a>
### Constructor

<!-- TOC --><a name="orderswatchesbutton-1"></a>
#### `OrderSwatchesButton`

- **Parameters**:
  - `documentIds`: A required list of strings representing the document IDs of the swatches to be displayed.

<!-- TOC --><a name="state-management-13"></a>
### State Management

<!-- TOC --><a name="_orderswatchesbuttonstate"></a>
#### `_OrderSwatchesButtonState`

- **Attributes**:
  - `_selectedImages`: A list of booleans indicating which swatches have been selected by the user.
  - `_imageUrls`: A list of strings containing the URLs of the swatch images.

<!-- TOC --><a name="override-void-initstate-6"></a>
#### `@override void initState()`

- Initializes the state and fetches the image URLs for the swatches when the widget is first created.

<!-- TOC --><a name="methods-16"></a>
## Methods

<!-- TOC --><a name="futurevoid-fetchimageurls-async-1"></a>
#### `Future<void> fetchImageUrls() async`

- Fetches the image URLs for the swatches based on their document IDs:
  - Retrieves each swatch document from Firestore and extracts the image locations.
  - Updates the state with the fetched image URLs and initializes the selection list.

<!-- TOC --><a name="futurevoid-_addswatchestocart-async"></a>
#### `Future<void> _addSwatchesToCart() async`

- Adds the selected swatches to the user's cart:
  - Checks if the user is logged in; if not, displays a message.
  - For each selected swatch, adds an entry to the user's cart in Firestore.

<!-- TOC --><a name="build-method-23"></a>
### Build Method

<!-- TOC --><a name="override-widget-buildbuildcontext-context-34"></a>
#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `OrderSwatchesButton`:
  - **Container**: Wraps the entire section in a container with a white background and shadow.
  - **ExpansionTile**: Provides a collapsible section titled "Order Swatches".
  - **Wrap**: Displays the swatch images in a grid format, allowing users to select them.
  - **GestureDetector**: Wraps each image to handle taps for selection.
  - **ElevatedButton**: A button that adds the selected swatches to the cart, with validation to ensure at least one swatch is selected.

<!-- TOC --><a name="ui-components-4"></a>
### UI Components

- **Image Display**: Each swatch image is displayed with a border that changes color based on selection.
- **Selection Indicator**: Displays a check icon over selected images to indicate selection.

<!-- TOC --><a name="productname"></a>
## ProductName

<!-- TOC --><a name="overview-40"></a>
### Overview

The `ProductName` class is a stateless widget that displays the name of a product in a Flutter application. It is designed to be used within a product card.

<!-- TOC --><a name="features-39"></a>
### Features

- **Text Display**: Renders the product name with customizable styling.
- **Padding**: Adds padding around the text for better visual spacing.

<!-- TOC --><a name="constructor-32"></a>
### Constructor

<!-- TOC --><a name="productname-1"></a>
#### `ProductName`

- **Parameters**: None.

<!-- TOC --><a name="build-method-24"></a>
### Build Method

<!-- TOC --><a name="override-widget-buildbuildcontext-context-35"></a>
#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `ProductName` widget:
  - **Padding**: Wraps the text in a `Padding` widget to provide space on the left, right, and top.
  - **Text**: Displays the product name as a `Text` widget with the following properties:
    - **Content**: The text content is currently hardcoded as 'Product Name', which can be replaced with a dynamic variable to display the actual product name.
    - **Style**: The text is styled with a font size of 24.0 and a bold font weight.

<!-- TOC --><a name="recentlyviewedsection"></a>
## RecentlyViewedSection

<!-- TOC --><a name="overview-41"></a>
### Overview

The `RecentlyViewedSection` class is a stateless widget that displays a section for recently viewed products in a Flutter application. It provides a visual representation of products that the user has recently interacted with.

<!-- TOC --><a name="features-40"></a>
### Features

- **Display of Recently Viewed Products**: Shows a list of products that the user has recently viewed.
- **Thumbnail Navigation**: Utilizes the `ImageThumbnails` component to display product images, allowing users to tap on thumbnails to revisit products.
- **Customizable Callbacks**: Provides a callback function that is triggered when a thumbnail is tapped, enabling interaction with the selected product.

<!-- TOC --><a name="constructor-33"></a>
### Constructor

<!-- TOC --><a name="recentlyviewedsection-1"></a>
#### `RecentlyViewedSection`

- **Parameters**:
  - `recentlyViewedDetails`: A required list of maps containing details about the recently viewed products. Each map should include the image URL and any other relevant information.
  - `onThumbnailTap`: A required callback function that is called when a thumbnail is tapped, passing the index of the tapped thumbnail.

<!-- TOC --><a name="build-method-25"></a>
### Build Method

<!-- TOC --><a name="override-widget-buildbuildcontext-context-36"></a>
#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `RecentlyViewedSection`:
  - **Container**: Wraps the entire section in a container with a light grey background.
  - **Column**: Organizes the title and thumbnails vertically.
  - **Padding**: Adds padding around the title text for better spacing.
  - **Text**: Displays the title "Recently Viewed" with specified styling (font family, size, and weight).
  - **Divider**: Adds a horizontal line to separate the title from the thumbnails.
  - **ImageThumbnails**: Displays the thumbnails using the `ImageThumbnails` widget, passing the recently viewed details, a default selected index of -1 (indicating no selection), and the thumbnail tap callback.

<!-- TOC --><a name="shippinginfo"></a>
## ShippingInfo

<!-- TOC --><a name="overview-42"></a>
### Overview

The `ShippingInfo` class is a stateless widget that displays a shipping information section in a Flutter application. It provides a simple interface for users to view shipping details and interact with the section.

<!-- TOC --><a name="features-41"></a>
### Features

- **Display of Shipping Information**: Shows a title for the shipping information.
- **Tap Interaction**: Allows users to tap on the section, which can be used to navigate to more detailed shipping information or perform other actions.

<!-- TOC --><a name="constructor-34"></a>
### Constructor

<!-- TOC --><a name="shippinginfo-1"></a>
#### `ShippingInfo`

- **Parameters**: 
  - `super.key`: An optional key that can be used to control the widget's identity in the widget tree.

<!-- TOC --><a name="build-method-26"></a>
### Build Method

<!-- TOC --><a name="override-widget-buildbuildcontext-context-37"></a>
#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `ShippingInfo` widget:
  - **Container**: Wraps the content in a container with a white background and a shadow effect for visual depth.
    - **BoxDecoration**: Configures the container's appearance:
      - `color`: Sets the background color to white.
      - `boxShadow`: Adds a shadow effect with specified properties:
        - `color`: A grey color with reduced opacity for a subtle shadow.
        - `spreadRadius`: Controls the spread of the shadow.
        - `blurRadius`: Controls the blur effect of the shadow.
        - `offset`: Specifies the position of the shadow relative to the container.
  - **ListTile**: Displays a list tile with the following properties:
    - `title`: Contains a text widget displaying the title "Shipping info".
    - `onTap`: A callback function that is triggered when the tile is tapped. Currently, it contains a TODO comment indicating that further functionality should be implemented.

<!-- TOC --><a name="supportsection"></a>
## SupportSection 

<!-- TOC --><a name="overview-43"></a>
### Overview

The `SupportSection` class is a stateless widget that provides a user interface element for accessing support information in a Flutter application. It is designed to be part of a product card or detail view, allowing users to easily find and tap into support options.

<!-- TOC --><a name="features-42"></a>
### Features

- **Display of Support Information**: Shows a title for the support section.
- **Tap Interaction**: Allows users to tap on the section to access support-related functionalities.

<!-- TOC --><a name="constructor-35"></a>
### Constructor

<!-- TOC --><a name="supportsection-1"></a>
#### `SupportSection`

- **Parameters**: 
  - `super.key`: An optional key that can be used to control the widget's identity in the widget tree.

<!-- TOC --><a name="build-method-27"></a>
### Build Method

<!-- TOC --><a name="override-widget-buildbuildcontext-context-38"></a>
#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `SupportSection` widget:
  - **Container**: Wraps the content in a container with a white background and a shadow effect for visual depth.
    - **BoxDecoration**: Configures the container's appearance:
      - `color`: Sets the background color to white.
      - `boxShadow`: Adds a shadow effect with specified properties:
        - `color`: A grey color with reduced opacity for a subtle shadow.
        - `spreadRadius`: Controls the spread of the shadow.
        - `blurRadius`: Controls the blur effect of the shadow.
        - `offset`: Specifies the position of the shadow relative to the container.
  - **ListTile**: Displays a list tile with the following properties:
    - `title`: Contains a text widget displaying the title "Support".
    - `onTap`: A callback function that is triggered when the tile is tapped. Currently, it contains a TODO comment indicating that further functionality should be implemented.

<!-- TOC --><a name="usersalsoviewedsection"></a>
## UsersAlsoViewedSection

<!-- TOC --><a name="overview-44"></a>
### Overview

The `UsersAlsoViewedSection` class is a stateless widget that displays a section for products that other users have also viewed in a Flutter application. This section helps users discover related products based on the viewing behavior of others.

<!-- TOC --><a name="features-43"></a>
### Features

- **Display of Related Products**: Shows a list of products that other users have viewed, enhancing product discovery.
- **Thumbnail Navigation**: Utilizes the `ImageThumbnails` component to display product images, allowing users to tap on thumbnails to view those products.
- **Customizable Callbacks**: Provides a callback function that is triggered when a thumbnail is tapped, enabling interaction with the selected product.

<!-- TOC --><a name="constructor-36"></a>
### Constructor

<!-- TOC --><a name="usersalsoviewedsection-1"></a>
#### `UsersAlsoViewedSection`

- **Parameters**:
  - `usersAlsoViewedDetails`: A required list of maps containing details about the products that users have also viewed. Each map should include the image URL and any other relevant information.
  - `onThumbnailTap`: A required callback function that is called when a thumbnail is tapped, passing the index of the tapped thumbnail.

<!-- TOC --><a name="build-method-28"></a>
### Build Method

<!-- TOC --><a name="override-widget-buildbuildcontext-context-39"></a>
#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `UsersAlsoViewedSection`:
  - **Container**: Wraps the entire section in a container with a light grey background.
  - **Column**: Organizes the title and thumbnails vertically.
  - **Padding**: Adds padding around the title text for better spacing.
  - **Text**: Displays the title "Users Also Viewed" with specified styling (font family, size, and weight).
  - **Divider**: Adds a horizontal line to separate the title from the thumbnails.
  - **ImageThumbnails**: Displays the thumbnails using the `ImageThumbnails` widget, passing the users also viewed details, a default selected index of -1 (indicating no selection), and the thumbnail tap callback.

<!-- TOC --><a name="dynamicfieldsdisplay"></a>
## DynamicFieldsDisplay

<!-- TOC --><a name="overview-45"></a>
### Overview

The `DynamicFieldsDisplay` class is a stateless widget that retrieves and displays dynamic fields related to a product from a Firestore database in a Flutter application. It is designed to show product details based on the provided document ID.

<!-- TOC --><a name="features-44"></a>
### Features

- **Dynamic Data Retrieval**: Fetches product details from Firestore based on the provided document ID.
- **Loading State Handling**: Displays a loading indicator while data is being fetched.
- **Error Handling**: Displays an error message if there is an issue retrieving the data.
- **Conditional Rendering**: Shows a message if the document does not exist.
- **Dynamic Field Display**: Renders fields based on their properties, including display name, value, and priority.

<!-- TOC --><a name="constructor-37"></a>
## Constructor

<!-- TOC --><a name="dynamicfieldsdisplay-1"></a>
#### `DynamicFieldsDisplay`

- **Parameters**:
  - `documentId`: A required string that represents the ID of the document in Firestore from which to fetch the product details.

<!-- TOC --><a name="build-method-29"></a>
### Build Method

<!-- TOC --><a name="override-widget-buildbuildcontext-context-40"></a>
#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `DynamicFieldsDisplay` widget:
  - **FutureBuilder**: Utilizes a `FutureBuilder` to handle asynchronous data fetching from Firestore.
    - **Future**: Fetches the document snapshot from the 'items' collection using the provided `documentId`.
    - **Builder**: Handles different states of the future:
      - **Loading State**: Displays a `CircularProgressIndicator` while waiting for data.
      - **Error State**: Displays an error message if the snapshot has an error.
      - **No Data State**: Displays a message if the document does not exist.
      - **Data State**: Processes the retrieved data:
        - Extracts fields that meet specific criteria (e.g., must contain `displayName`, `toDisplay`, `value`, and `priority`).
        - Sorts the fields by their priority.
        - Maps the fields to `DetailItem` widgets for display.
  - **Container**: Wraps the content in a container with padding and a shadow effect for visual depth.
    - **Column**: Organizes the title and fields vertically.
      - **Text**: Displays the title "Product Details" with specified styling.
      - **Divider**: Adds a horizontal line to separate the title from the fields.
      - **Field Widgets**: Displays the dynamically generated field widgets.

<!-- TOC --><a name="detailitem"></a>
## DetailItem

<!-- TOC --><a name="overview-46"></a>
### Overview

The `DetailItem` class is a stateless widget that displays a key-value pair in a structured format within a Flutter application. It is designed to present product details.

<!-- TOC --><a name="features-45"></a>
### Features

- **Key-Value Display**: Shows a title and its corresponding value in a row format.
- **Logging**: Utilizes the `logging` package to log the building process and any errors that occur.
- **Error Handling**: Displays an error message if there is an issue during the rendering of the widget.

<!-- TOC --><a name="constructor-38"></a>
### Constructor

<!-- TOC --><a name="detailitem-1"></a>
#### `DetailItem`

- **Parameters**:
  - `title`: A required string that represents the title of the detail item.
  - `value`: A required string that represents the value associated with the title.

<!-- TOC --><a name="build-method-30"></a>
### Build Method

<!-- TOC --><a name="override-widget-buildbuildcontext-context-41"></a>
#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `DetailItem` widget:
  - **Logging**: Logs the title and value being built for debugging purposes.
  - **Container**: Wraps the content in a container with padding and a shadow effect for visual depth.
    - **Padding**: Adds vertical padding to the container.
    - **BoxDecoration**: Configures the container's appearance:
      - `color`: Sets the background color to white.
      - `boxShadow`: Adds a shadow effect with specified properties.
  - **Row**: Organizes the title and value horizontally.
    - **Title**: Displays the title in a `Text` widget with bold styling.
    - **Value**: Displays the value in an `Expanded` `Text` widget, aligned to the right.
  - **Error Handling**: If an error occurs during the building process:
    - Logs the error and stack trace.
    - Returns a container with a red background indicating an error state.
    - Displays an error message in white text.

<!-- TOC --><a name="imageselector"></a>
## ImageSelector

<!-- TOC --><a name="overview-47"></a>
### Overview

The `ImageSelector` class is a stateless widget that displays an image with a selection indicator in a Flutter application. It allows users to select an image by tapping on it, providing visual feedback when the image is selected.

<!-- TOC --><a name="features-46"></a>
### Features

- **Image Display**: Renders an image from a provided URL.
- **Selection Indicator**: Shows a circular check icon over the image when it is selected.
- **Tap Interaction**: Allows users to tap on the image to trigger a callback function.

<!-- TOC --><a name="constructor-39"></a>
### Constructor

<!-- TOC --><a name="imageselector-1"></a>
#### `ImageSelector`

- **Parameters**:
  - `imageUrl`: A required string that represents the URL of the image to be displayed.
  - `isSelected`: A required boolean that indicates whether the image is currently selected.
  - `onTap`: A required callback function that is invoked when the image is tapped.

<!-- TOC --><a name="build-method-31"></a>
### Build Method

<!-- TOC --><a name="override-widget-buildbuildcontext-context-42"></a>
#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `ImageSelector` widget:
  - **GestureDetector**: Wraps the content in a `GestureDetector` to handle tap events.
    - **onTap**: Calls the `onTap` callback when the image is tapped.
  - **Stack**: Uses a `Stack` to overlay the selection indicator on top of the image.
    - **Container**: Displays the image:
      - **margin**: Adds margin around the image for spacing.
      - **Image.network**: Loads the image from the provided URL with specified dimensions and fit.
    - **Conditional Selection Indicator**: If `isSelected` is true:
      - **Container**: Displays a circular background for the check icon.
        - **BoxDecoration**: Configures the container's appearance:
          - `color`: Sets the background color to black.
          - `shape`: Sets the shape to a circle.
      - **Icon**: Displays a check circle icon in white color.

<!-- TOC --><a name="lengthslider"></a>
## LengthSlider

<!-- TOC --><a name="overview-48"></a>
### Overview

The `LengthSlider` class is a stateless widget that provides a customizable slider for selecting an order length within a specified range in a Flutter application. It allows users to visually adjust the length and displays the current selection along with any validation errors.

<!-- TOC --><a name="features-47"></a>
### Features

- **Customizable Range**: Allows setting minimum and maximum order lengths.
- **Visual Feedback**: Displays the current selected length and validation errors.
- **Dynamic Labels**: Shows labels at specific intervals along the slider for better user guidance.

<!-- TOC --><a name="constructor-40"></a>
### Constructor

<!-- TOC --><a name="lengthslider-1"></a>
#### `LengthSlider`

- **Parameters**:
  - `minOrderLength`: A required integer that specifies the minimum length for the slider.
  - `maxOrderLength`: A required integer that specifies the maximum length for the slider.
  - `selectedLength`: A required double that represents the currently selected length.
  - `labels`: A required list of integers that represent the labels to be displayed along the slider.
  - `onChanged`: A required callback function that is called when the slider value changes, passing the new length as a double.
  - `validationError`: An optional string that contains a validation error message, if any.

<!-- TOC --><a name="build-method-32"></a>
### Build Method

<!-- TOC --><a name="override-widget-buildbuildcontext-context-43"></a>
#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `LengthSlider` widget:
  - **Padding**: Adds padding around the entire widget for spacing.
  - **Column**: Organizes the title, slider, and current length display vertically.
    - **Title**: Displays the title "Order Length" with bold styling.
    - **Container**: Wraps the slider in a container with a light grey background and rounded corners.
      - **Stack**: Allows layering of the slider and labels.
        - **SliderTheme**: Customizes the appearance of the slider:
          - Sets colors for active and inactive tracks, thumb, and overlay.
          - Configures the shape and size of the slider components.
        - **Slider**: Displays the slider with the following properties:
          - `value`: The current selected length.
          - `min` and `max`: The range of the slider.
          - `divisions`: Number of discrete divisions on the slider.
          - `label`: Displays the current value as a label.
          - `onChanged`: Calls the provided callback when the slider value changes.
        - **Positioned**: Displays labels at specific intervals along the slider:
          - Each label is displayed with its corresponding value in meters.
    - **Current Length Display**: Shows the current selected length formatted to two decimal places.
    - **Validation Error**: If a validation error exists, it displays the error message in red text.

<!-- TOC --><a name="imageplaceholder"></a>
## ImagePlaceholder

<!-- TOC --><a name="overview-49"></a>
### Overview

The `ImagePlaceholder` class is a stateless widget that displays an image from a provided URL in a Flutter application. It is designed to serve as a placeholder for images, ensuring that the layout remains consistent while the image is being loaded.

<!-- TOC --><a name="features-48"></a>
### Features

- **Image Display**: Loads and displays an image from a specified URL.
- **Padding**: Provides consistent spacing around the image for better visual presentation.

<!-- TOC --><a name="constructor-41"></a>
### Constructor

<!-- TOC --><a name="imageplaceholder-1"></a>
#### `ImagePlaceholder`

- **Parameters**:
  - `imageUrl`: A required string that represents the URL of the image to be displayed.

<!-- TOC --><a name="build-method-33"></a>
### Build Method

<!-- TOC --><a name="override-widget-buildbuildcontext-context-44"></a>
#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `ImagePlaceholder` widget:
  - **Padding**: Wraps the image in a `Padding` widget to add space around it.
    - **EdgeInsets.all(16.0)**: Applies uniform padding of 16 pixels on all sides.
  - **Image.network**: Loads the image from the provided URL with the following properties:
    - `fit`: Sets the image's fit to `BoxFit.cover`, ensuring that the image covers the entire area of the widget while maintaining its aspect ratio.

<!-- TOC --><a name="imagethumbnails"></a>
## ImageThumbnails

<!-- TOC --><a name="overview-50"></a>
### Overview

The `ImageThumbnails` class is a stateless widget that displays a horizontal list of image thumbnails in a Flutter application. It allows users to select an image thumbnail, providing visual feedback for the selected thumbnail.

<!-- TOC --><a name="features-49"></a>
### Features

- **Horizontal Scrolling**: Displays thumbnails in a horizontally scrollable view.
- **Thumbnail Selection**: Highlights the currently selected thumbnail with a border.
- **Tap Interaction**: Allows users to tap on a thumbnail to trigger a callback function.

<!-- TOC --><a name="constructor-42"></a>
### Constructor

<!-- TOC --><a name="imagethumbnails-1"></a>
#### `ImageThumbnails`

- **Parameters**:
  - `imageDetails`: A required list of maps containing details about the images. Each map should include an `imageUrl` key that points to the image's URL.
  - `selectedImageIndex`: A required integer that indicates the index of the currently selected thumbnail.
  - `onThumbnailTap`: A required callback function that is called when a thumbnail is tapped, passing the index of the tapped thumbnail.

<!-- TOC --><a name="build-method-34"></a>
### Build Method

<!-- TOC --><a name="override-widget-buildbuildcontext-context-45"></a>
#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `ImageThumbnails` widget:
  - **SizedBox**: Sets a fixed height for the thumbnail container.
  - **Center**: Centers the content within the available space.
  - **SingleChildScrollView**: Allows horizontal scrolling of the thumbnails.
    - **Row**: Organizes the thumbnails in a horizontal layout.
      - **List.generate**: Generates a list of thumbnail widgets based on the `imageDetails` length:
        - **GestureDetector**: Wraps each thumbnail in a gesture detector to handle tap events.
          - **onTap**: Calls the `onThumbnailTap` callback with the index of the tapped thumbnail.
          - **Container**: Wraps the thumbnail image with margin and border decoration:
            - **margin**: Adds horizontal spacing between thumbnails.
            - **BoxDecoration**: Configures the appearance of the container:
              - **border**: Sets a border color based on whether the thumbnail is selected or not.
        - **Image.network**: Loads the image from the provided URL with specified dimensions and fit.

<!-- TOC --><a name="subcategorylist"></a>
## SubCategoryList

<!-- TOC --><a name="overview-51"></a>
### Overview

The `SubCategoryList` class is a stateless widget that displays a horizontal list of subcategories in a Flutter application. It allows users to select subcategories, providing visual feedback for the selected items. This component is useful for filtering or navigating through different categories of products.

<!-- TOC --><a name="features-50"></a>
### Features

- **Horizontal Scrolling**: Displays subcategories in a horizontally scrollable view.
- **Selection Feedback**: Highlights the currently selected subcategories.
- **Logging**: Utilizes the logging package to track the building process and user interactions.

<!-- TOC --><a name="constructor-43"></a>
### Constructor

<!-- TOC --><a name="subcategorylist-1"></a>
#### `SubCategoryList`

- **Parameters**:
  - `subCategories`: A required list of strings representing the subcategory names to be displayed.
  - `selectedCategories`: A required list of strings representing the currently selected subcategories.
  - `onSelectCategory`: A required callback function that is invoked when a subcategory is selected, passing the selected subcategory as a string.

<!-- TOC --><a name="build-method-35"></a>
### Build Method

<!-- TOC --><a name="override-widget-buildbuildcontext-context-46"></a>
#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `SubCategoryList` widget:
  - **Logging**: Logs the number of subcategories being built for debugging purposes.
  - **Padding**: Adds padding at the top of the list for spacing.
  - **SingleChildScrollView**: Allows horizontal scrolling of the subcategory buttons.
    - **Row**: Organizes the subcategory buttons in a horizontal layout.
      - **List.map**: Iterates over the `subCategories` list to create a `CategoryButton` for each subcategory:
        - **Logging**: Logs the creation of each `CategoryButton` for debugging.
        - **Padding**: Adds horizontal padding around each button for spacing.
        - **CategoryButton**: Displays the button with the following properties:
          - `label`: The name of the subcategory.
          - `isSelected`: A boolean indicating whether the subcategory is currently selected.
          - `onTap`: A callback function that logs the selection and invokes the `onSelectCategory` callback with the selected subcategory.

<!-- TOC --><a name="sortbutton"></a>
## SortButton

<!-- TOC --><a name="overview-52"></a>
### Overview

The `SortButton` class is a stateless widget that provides a button for sorting options in a Flutter application. It allows users to trigger a sorting action based on the currently selected sort option.

<!-- TOC --><a name="features-51"></a>
### Features

- **Sort Option Display**: Shows the currently selected sort option as a label on the button.
- **Icon Representation**: Includes a sort icon to visually indicate the button's purpose.
- **Logging**: Utilizes the logging package to track the button's state and interactions.

<!-- TOC --><a name="constructor-44"></a>
### Constructor

<!-- TOC --><a name="sortbutton-1"></a>
#### `SortButton`

- **Parameters**:
  - `selectedSortOption`: A required string that represents the currently selected sort option to be displayed on the button.
  - `onShowSortOptions`: A required callback function that is invoked when the button is pressed, allowing the application to show available sorting options.

<!-- TOC --><a name="build-method-36"></a>
### Build Method

<!-- TOC --><a name="override-widget-buildbuildcontext-context-47"></a>
#### `@override Widget build(BuildContext context)`

- Constructs the UI for the `SortButton` widget:
  - **Logging**: Logs the current selected sort option for debugging purposes.
  - **Align**: Aligns the button to the left of its parent container.
  - **TextButton.icon**: Creates a button with an icon and a label:
    - **icon**: Displays a sort icon in black color.
    - **label**: Displays the selected sort option in black text.
    - **onPressed**: Defines the action to be taken when the button is pressed:
      - Logs the button press event.
      - Calls the `onShowSortOptions` callback to display sorting options.