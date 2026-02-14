import 'package:dyota/pages/Search/search_page.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 48.0);
}

class _CustomAppBarState extends State<CustomAppBar> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
      style: TextStyle(fontFamily: 'AlfaSlab', fontSize: 25.0),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
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
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          prefixIcon: const Icon(Icons.search, color: Colors.black),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
        style: const TextStyle(color: Colors.black),
        onSubmitted: (query) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchPage(searchInput: query),
            ),
          );
          _searchController.clear();
        },
      ),
    );
  }
}
