import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dyota/components/generic_appbar.dart';
import 'package:dyota/pages/Category/Components/product_list_item.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final String searchInput;

  const SearchPage({Key? key, required this.searchInput}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Tuple<int, String>> searchResults = [];
  bool isLoading = true;
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController(text: widget.searchInput);
    _performSearch();
  }

  Future<void> _performSearch() async {
    setState(() {
      isLoading = true;
    });

    try {
      searchResults = await search(searchController.text);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      // Handle error
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: genericAppbar(title: 'Search Results'),
      body: Column(
        children: [
          Container(
            color: Colors.black,
            padding: EdgeInsets.all(16.0),
            child: Container(
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
                  setState(() {
                    isLoading = true;
                  });
                  _performSearch();
                },
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : searchResults.isEmpty
                    ? Center(child: Text('No items found'))
                    : buildGridView(),
          ),
        ],
      ),
    );
  }

  Widget buildGridView() {
    return GridView.builder(
      itemCount: searchResults.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      itemBuilder: (BuildContext context, int index) {
        String documentId = searchResults[index].item2;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ProductListItem(
            documentId: documentId,
          ),
        );
      },
    );
  }
}

// Helper class to represent a tuple
class Tuple<T1, T2> {
  final T1 item1;
  final T2 item2;

  Tuple(this.item1, this.item2);
}

Future<List<Tuple<int, String>>> search(String query) async {
  List<Tuple<int, String>> matchingDocumentIds = [];

  // Convert the query to lowercase
  String lowerCaseQuery = query.toLowerCase();

  // Reference to the Firestore collection
  CollectionReference itemsCollection =
      FirebaseFirestore.instance.collection('items');

  // Fetch all documents in the 'items' collection
  QuerySnapshot querySnapshot = await itemsCollection.get();

  // Iterate through each document
  for (QueryDocumentSnapshot doc in querySnapshot.docs) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Iterate through each field in the document
    for (var entry in data.entries) {
      if (entry.value is Map<String, dynamic>) {
        Map<String, dynamic> mapField = entry.value;

        // Check if the 'value' field matches the query
        if (mapField.containsKey('value')) {
          var value = mapField['value'];
          int priority = 0;

          if (value is String) {
            String lowerCaseValue = value.toLowerCase();
            if (lowerCaseValue == lowerCaseQuery) {
              priority = 100; // Highest priority for exact match
            } else if (lowerCaseValue.contains(lowerCaseQuery)) {
              priority = (lowerCaseQuery.length / lowerCaseValue.length * 100)
                  .toInt(); // Proportional priority
            }
          } else if (value is num) {
            String valueStr = value.toString().toLowerCase();
            if (valueStr == lowerCaseQuery) {
              priority = 100; // Highest priority for exact match
            } else if (valueStr.contains(lowerCaseQuery)) {
              priority = (lowerCaseQuery.length / valueStr.length * 100)
                  .toInt(); // Proportional priority
            }
          }

          if (priority > 0) {
            matchingDocumentIds.add(Tuple(priority, doc.id));
          }
        }
      }
    }
  }

  // Sort the results by priority in descending order
  matchingDocumentIds.sort((a, b) => b.item1.compareTo(a.item1));

  return matchingDocumentIds;
}
