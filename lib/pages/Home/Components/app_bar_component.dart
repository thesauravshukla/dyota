import 'package:dyota/pages/Search/search_page.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      flexibleSpace: _buildAppBarContent(context),
      actions: const [],
    );
  }

  Widget _buildAppBarContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: 16.0, right: 16.0, top: MediaQuery.of(context).padding.top),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 8.0),
          _buildBrandLogo(),
          _buildSearchBar(context),
          const SizedBox(height: 8.0),
        ],
      ),
    );
  }

  Widget _buildBrandLogo() {
    return const Text(
      'dyota',
      style: TextStyle(
          fontFamily: 'AlfaSlab', fontSize: 25.0, color: Colors.white),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    return Container(
      height: 35.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: searchController,
        decoration: _createSearchInputDecoration(),
        style: const TextStyle(color: Colors.black),
        onSubmitted: (query) => _navigateToSearchPage(context, query),
      ),
    );
  }

  InputDecoration _createSearchInputDecoration() {
    return InputDecoration(
      hintText: 'Search...',
      hintStyle: const TextStyle(color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      prefixIcon: const Icon(Icons.search, color: Colors.black),
      contentPadding: const EdgeInsets.symmetric(vertical: 0),
    );
  }

  void _navigateToSearchPage(BuildContext context, String query) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPage(searchInput: query),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 48.0);
}
