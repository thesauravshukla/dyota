import 'package:dyota/pages/Search/search_page.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();

    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      flexibleSpace: Padding(
        padding: EdgeInsets.only(
            left: 16.0, right: 16.0, top: MediaQuery.of(context).padding.top),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.spaceEvenly, // Distribute space evenly
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 8.0), // Add space on top if needed
            const Text(
              'dyota',
              style: TextStyle(
                  fontFamily: 'AlfaSlab', fontSize: 25.0, color: Colors.white),
            ),
            Container(
              height: 35.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.black),
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                ),
                style: const TextStyle(color: Colors.black),
                onSubmitted: (query) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchPage(searchInput: query),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 8.0), // Add space at the bottom if needed
          ],
        ),
      ),
      actions: [],
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + 48.0); // Adjust height accordingly
}
