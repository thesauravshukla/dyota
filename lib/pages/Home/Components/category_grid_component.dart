import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dyota/pages/Home/Components/category_item.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class CategoryGrid extends StatefulWidget {
  final Function(bool)? onLoadingChanged;

  const CategoryGrid({super.key, this.onLoadingChanged});

  @override
  State<CategoryGrid> createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  final Logger _logger = Logger('CategoryGridComponent');
  late final CategoryDataProvider _dataProvider;
  bool _loadingNotified = false;

  @override
  void initState() {
    super.initState();
    _dataProvider = CategoryDataProvider(
      onLoadingChanged: _handleLoadingChanged,
    );
  }

  void _handleLoadingChanged(bool isLoading) {
    if (!_loadingNotified) {
      _loadingNotified = true;
      widget.onLoadingChanged?.call(isLoading);
    } else {
      widget.onLoadingChanged?.call(isLoading);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DocumentSnapshot>>(
      future: _dataProvider.categoryDocumentsFuture,
      builder: (context, snapshot) {
        return _buildGridContent(snapshot);
      },
    );
  }

  Widget _buildGridContent(AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
    if (_shouldShowEmptyWidget(snapshot)) {
      return const SizedBox();
    }

    if (snapshot.hasError) {
      _logger.severe('Error in snapshot: ${snapshot.error}');
      return const Text('');
    }

    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      _logger.severe('No data found');
      return const Text('');
    }

    return _buildCategoryGrid(snapshot.data!);
  }

  bool _shouldShowEmptyWidget(AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
    return snapshot.connectionState == ConnectionState.waiting;
  }

  Widget _buildCategoryGrid(List<DocumentSnapshot> categoryDocuments) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1,
      ),
      itemCount: categoryDocuments.length,
      itemBuilder: (context, index) => CategoryItem(index: index),
    );
  }
}

class CategoryDataProvider {
  final Function(bool) onLoadingChanged;
  late final Future<List<DocumentSnapshot>> categoryDocumentsFuture;
  final Logger _logger = Logger('CategoryDataProvider');

  CategoryDataProvider({required this.onLoadingChanged}) {
    categoryDocumentsFuture = _fetchCategoryDocuments();
  }

  Future<List<DocumentSnapshot>> _fetchCategoryDocuments() async {
    onLoadingChanged(true);

    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('categories').get();

      onLoadingChanged(false);
      return snapshot.docs;
    } catch (e) {
      onLoadingChanged(false);
      _logger.severe('Error fetching categories: $e');
      return [];
    }
  }
}
