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
  int loadingProductCount = 0;
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
      loadingProductCount = 0;
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
        loadingProductCount = 0;
      });
    }
  }

  void _onProductLoadingChanged(bool loading) {
    setState(() {
      if (loading) {
        loadingProductCount++;
      } else {
        loadingProductCount =
            (loadingProductCount - 1).clamp(0, searchResults.length);
      }
    });
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
                    loadingProductCount = 0;
                  });
                  _performSearch();
                },
              ),
            ),
          ),
          // Brown linear progress bar below the black search container
          if (loadingProductCount > 0)
            LinearProgressIndicator(
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.brown),
            ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : searchResults.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('No items found'),
                            SizedBox(height: 10),
                            Text('Search query: "${searchController.text}"'),
                            Text('Results count: ${searchResults.length}'),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Found ${searchResults.length} results for "${searchController.text}"',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(child: buildGridView()),
                        ],
                      ),
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
            onLoadingChanged: _onProductLoadingChanged,
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

  // If no query, return all documents
  if (query.isEmpty) {
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      matchingDocumentIds.add(Tuple(1, doc.id));
    }
    return matchingDocumentIds;
  }

  // Iterate through each document
  for (QueryDocumentSnapshot doc in querySnapshot.docs) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    bool documentMatched = false;
    int highestPriority = 0;

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
            documentMatched = true;
            if (priority > highestPriority) {
              highestPriority = priority;
            }
          }
        }
      } else if (entry.value is String) {
        // Also search in simple string fields
        String fieldValue = entry.value.toLowerCase();
        if (fieldValue.contains(lowerCaseQuery)) {
          int priority =
              (lowerCaseQuery.length / fieldValue.length * 50).toInt();
          documentMatched = true;
          if (priority > highestPriority) {
            highestPriority = priority;
          }
        }
      }
    }

    if (documentMatched) {
      matchingDocumentIds.add(Tuple(highestPriority, doc.id));
    }
  }

  // Sort the results by priority in descending order
  matchingDocumentIds.sort((a, b) => b.item1.compareTo(a.item1));

  return matchingDocumentIds;
}
