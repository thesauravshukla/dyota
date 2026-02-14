import 'package:dyota/components/generic_appbar.dart';
import 'package:dyota/components/shared/app_loading_indicator.dart';
import 'package:dyota/pages/Category/Components/product_list_item.dart';
import 'package:dyota/services/search_service.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final String searchInput;

  const SearchPage({Key? key, required this.searchInput}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchService _searchService = SearchService();
  List<SearchResult> _results = [];
  bool _isLoading = true;
  int _loadingProductCount = 0;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchInput);
    _performSearch();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch() async {
    setState(() => _isLoading = true);

    _results = await _searchService.search(_searchController.text);

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _onProductLoadingChanged(bool loading) {
    setState(() {
      _loadingProductCount += loading ? 1 : -1;
      _loadingProductCount = _loadingProductCount.clamp(0, _results.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: genericAppbar(title: 'Search Results'),
      body: Column(
        children: [
          _buildSearchBar(),
          if (_loadingProductCount > 0) const AppLoadingBar(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 35.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: const TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            prefixIcon: const Icon(Icons.search, color: Colors.black),
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
          ),
          style: const TextStyle(color: Colors.black),
          onSubmitted: (_) => _performSearch(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const AppSpinner();
    }

    if (_results.isEmpty) {
      return Center(
        child: Text('No items found for "${_searchController.text}"'),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Found ${_results.length} results for "${_searchController.text}"',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: GridView.builder(
            itemCount: _results.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ProductListItem(
                  documentId: _results[index].documentId,
                  onLoadingChanged: _onProductLoadingChanged,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
