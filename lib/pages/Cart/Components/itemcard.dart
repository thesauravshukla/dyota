import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dyota/pages/My_Bag/Components/delete_confirmation_dialog.dart';
import 'package:dyota/pages/My_Bag/Components/fetch_data.dart';
import 'package:dyota/pages/My_Bag/Components/image_loader.dart';
import 'package:dyota/pages/My_Bag/Components/item_card_data.dart';
import 'package:dyota/pages/Product_Card/product_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class ItemCard extends StatefulWidget {
  final String documentId;
  final VoidCallback onDelete;
  final Function(bool)? onLoadingChanged;

  const ItemCard({
    Key? key,
    required this.documentId,
    required this.onDelete,
    this.onLoadingChanged,
  }) : super(key: key);

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  final Logger _logger = Logger('ItemCard');
  bool _isDeleted = false;
  bool _isLoading = true;
  bool _hasNotifiedLoading = false;
  Map<String, dynamic>? _cachedCartData;
  Map<String, dynamic>? _cachedDocumentData;

  @override
  void initState() {
    super.initState();
    _scheduleInitialLoadingNotification();
    _setupSafetyTimeout();
  }

  void _scheduleInitialLoadingNotification() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_shouldNotifyInitialLoading()) {
        _hasNotifiedLoading = true;
        _notifyLoadingState(_isLoading);
      }
    });
  }

  bool _shouldNotifyInitialLoading() {
    return mounted && !_hasNotifiedLoading && widget.onLoadingChanged != null;
  }

  void _setupSafetyTimeout() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _isLoading) {
        _updateLoadingState(false);
      }
    });
  }

  String _parseDocumentId(String input) {
    return input.split('-')[0];
  }

  String _getFieldValue(Map<String, dynamic> field) {
    String value = field['value']?.toString() ?? '';
    String prefix = field['prefix']?.toString() ?? '';
    String suffix = field['suffix']?.toString() ?? '';
    return '$prefix$value$suffix';
  }

  void _updateLoadingState(bool isLoading) {
    if (_isLoading != isLoading) {
      _isLoading = isLoading;
      _notifyLoadingState(_isLoading);
    }
  }

  void _notifyLoadingState(bool isLoading) {
    if (widget.onLoadingChanged != null && mounted) {
      // Use a delay to prevent too frequent updates
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) widget.onLoadingChanged!(isLoading);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isDeleted) {
      return const SizedBox.shrink();
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _updateLoadingState(false);
      return const Center(child: Text('User not logged in'));
    }

    final ItemCardData itemData = ItemCardData(
      parsedDocumentId: _parseDocumentId(widget.documentId),
      unparsedDocumentId: widget.documentId,
      userEmail: user.email!,
    );

    return _buildCartDataFuture(itemData);
  }

  Widget _buildCartDataFuture(ItemCardData itemData) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _cachedCartData != null
          ? Future.value(_cachedCartData)
          : fetchCartData(itemData.userEmail, itemData.unparsedDocumentId),
      builder: (context, cartSnapshot) {
        return _buildCartDataContent(context, cartSnapshot, itemData);
      },
    );
  }

  Widget _buildCartDataContent(
      BuildContext context,
      AsyncSnapshot<Map<String, dynamic>?> cartSnapshot,
      ItemCardData itemData) {
    if (_isLoadingCartData(cartSnapshot)) {
      _updateLoadingState(true);
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Container(
          height: 120,
          padding: const EdgeInsets.all(16),
          child: const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
      );
    }

    if (_hasCartDataLoaded(cartSnapshot)) {
      _handleCartDataLoaded();
    }

    if (_hasCartDataError(cartSnapshot)) {
      return _buildErrorWidget(cartSnapshot.error);
    }

    if (!_hasCartData(cartSnapshot)) {
      return const Center(child: Text('No cart data found'));
    }

    _cacheCartData(cartSnapshot.data);
    return _buildDocumentDataFuture(itemData);
  }

  bool _isLoadingCartData(AsyncSnapshot<Map<String, dynamic>?> snapshot) {
    return snapshot.connectionState == ConnectionState.waiting;
  }

  bool _hasCartDataLoaded(AsyncSnapshot<Map<String, dynamic>?> snapshot) {
    return snapshot.connectionState == ConnectionState.done && _isLoading;
  }

  void _handleCartDataLoaded() {
    Future.delayed(Duration.zero, () {
      if (mounted) _updateLoadingState(false);
    });
  }

  bool _hasCartDataError(AsyncSnapshot<Map<String, dynamic>?> snapshot) {
    return snapshot.hasError;
  }

  Widget _buildErrorWidget(Object? error) {
    _updateLoadingState(false);
    return Center(child: Text('Error: $error'));
  }

  bool _hasCartData(AsyncSnapshot<Map<String, dynamic>?> snapshot) {
    return snapshot.hasData && snapshot.data != null;
  }

  void _cacheCartData(Map<String, dynamic>? data) {
    if (_cachedCartData == null) {
      _cachedCartData = data;
    }
  }

  Widget _buildDocumentDataFuture(ItemCardData itemData) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _cachedDocumentData != null
          ? Future.value(_cachedDocumentData)
          : fetchDocumentData(itemData.parsedDocumentId),
      builder: (context, snapshot) {
        return _buildDocumentDataContent(context, snapshot, itemData);
      },
    );
  }

  Widget _buildDocumentDataContent(BuildContext context,
      AsyncSnapshot<Map<String, dynamic>?> snapshot, ItemCardData itemData) {
    if (_isLoadingDocumentData(snapshot)) {
      _updateLoadingState(true);
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Container(
          height: 120,
          padding: const EdgeInsets.all(16),
          child: const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
      );
    }

    if (_hasDocumentDataError(snapshot)) {
      return _buildErrorWidget(snapshot.error);
    }

    if (!_hasDocumentData(snapshot)) {
      return const Center(child: Text(''));
    }

    _cacheAndHandleDocumentData(snapshot.data);
    return _buildItemCardWithImageLoader(itemData, snapshot.data!);
  }

  bool _isLoadingDocumentData(AsyncSnapshot<Map<String, dynamic>?> snapshot) {
    return snapshot.connectionState == ConnectionState.waiting;
  }

  bool _hasDocumentDataError(AsyncSnapshot<Map<String, dynamic>?> snapshot) {
    return snapshot.hasError;
  }

  bool _hasDocumentData(AsyncSnapshot<Map<String, dynamic>?> snapshot) {
    return snapshot.hasData && snapshot.data != null;
  }

  void _cacheAndHandleDocumentData(Map<String, dynamic>? data) {
    if (_cachedDocumentData == null) {
      _cachedDocumentData = data;
    }

    if (_isLoading) {
      _updateLoadingState(false);
    }
  }

  Widget _buildItemCardWithImageLoader(
      ItemCardData itemData, Map<String, dynamic> data) {
    final List<dynamic> imageLocations = data['imageLocation'];
    final String imageLocation =
        imageLocations.isNotEmpty ? imageLocations[0] : '';

    return ImageLoader(
      imageLocation: imageLocation,
      builder: (context, imageUrl) {
        _updateLoadingState(false);
        return _buildItemCardContent(context, itemData, data, imageUrl);
      },
    );
  }

  Widget _buildItemCardContent(BuildContext context, ItemCardData itemData,
      Map<String, dynamic> data, String imageUrl) {
    if (_cachedCartData == null) {
      return const SizedBox.shrink();
    }

    Map<String, dynamic> cartData = _cachedCartData!;
    List<Map<String, dynamic>> cartFields = cartData.entries
        .where((entry) => entry.value is Map<String, dynamic>)
        .map((entry) => entry.value as Map<String, dynamic>)
        .toList();

    // Sort cart fields by priority
    cartFields
        .sort((a, b) => (a['priority'] as int).compareTo(b['priority'] as int));

    return InkWell(
      onTap: () => _navigateToProductCard(context, itemData.parsedDocumentId),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProductImage(imageUrl),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildProductDetails(cartFields),
                ),
                _buildDeleteButton(itemData),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        imageUrl,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildProductDetails(List<Map<String, dynamic>> cartFields) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          cartFields.where((field) => field['toDisplay'] == 1).map((field) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Row(
            children: [
              Flexible(
                child: Text(
                  '${field['displayName'] ?? ''}:',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  _getFieldValue(field),
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDeleteButton(ItemCardData itemData) {
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () => _showDeleteConfirmation(itemData),
      color: Colors.black,
    );
  }

  void _showDeleteConfirmation(ItemCardData itemData) {
    _logger.info(
        'Showing delete confirmation for: ${itemData.unparsedDocumentId}');
    showDeleteConfirmationDialog(
        context, itemData.userEmail, itemData.unparsedDocumentId, () {
      setState(() {
        _isDeleted = true;
      });
      widget.onDelete();
    });
  }

  void _navigateToProductCard(BuildContext context, String documentId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductCard(documentId: documentId),
      ),
    );
  }
}
