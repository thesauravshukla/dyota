import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decimal/decimal.dart';
import 'package:dyota/components/bottom_navigation_bar_component.dart';
import 'package:dyota/components/generic_appbar.dart';
import 'package:dyota/pages/Home/home_page.dart';
import 'package:dyota/pages/My_Bag/Components/itemcard.dart';
import 'package:dyota/pages/My_Bag/Components/total_amount_selection.dart';
import 'package:dyota/pages/Profile/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class MyBag extends StatefulWidget {
  @override
  _MyBagState createState() => _MyBagState();
}

class _MyBagState extends State<MyBag> {
  final Logger _logger = Logger('MyBag');

  @override
  Widget build(BuildContext context) {
    _logger.info('Building MyBag widget');
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) {
      _logger.warning('User not logged in or email is null');
      return _buildScaffold(
        context,
        Center(child: Text('Please log in to view your bag.')),
      );
    }

    return _buildScaffold(
      context,
      StreamBuilder<DocumentSnapshot>(
        // First, get the user document to get minimumOrderValue
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .snapshots(),
        builder: (context, userSnapshot) {
          if (!userSnapshot.hasData) {
            return Center(child: Text(''));
          }

          final minimumOrderValue = Decimal.parse(
              (userSnapshot.data?['minimumOrderValue'] ?? 5000).toString());

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user.email)
                .collection('cartItemsList')
                .snapshots(),
            builder: (context, snapshot) {
              try {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  _logger.info('Waiting for data...');
                  return Center(child: Text(''));
                }
                if (snapshot.hasError) {
                  _logger.severe('Error fetching data: ${snapshot.error}');
                  return Center(child: Text(''));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  _logger.info('No data found or bag is empty');
                  return Center(child: Text('Your bag is empty.'));
                }

                List<Widget> itemCards =
                    snapshot.data!.docs.map<Widget>((document) {
                  return ItemCard(
                    documentId: document.id,
                    onDelete: () {
                      setState(() {});
                    },
                  );
                }).toList();

                _logger.info('Data fetched successfully, building item cards');
                return ListView(
                  children: [
                    ...itemCards,
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.email)
                          .collection('cartItemsList')
                          .snapshots(),
                      builder: (context, cartSnapshot) {
                        if (!cartSnapshot.hasData) {
                          return const SizedBox();
                        }

                        // Calculate total amount from cart items
                        Decimal totalAmount = Decimal.zero;
                        for (var doc in cartSnapshot.data!.docs) {
                          Map<String, dynamic> priceMap = doc.get('price');
                          totalAmount +=
                              Decimal.parse(priceMap['value'].toString());
                        }

                        return Column(
                          children: [
                            if (totalAmount < minimumOrderValue)
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                    border:
                                        Border.all(color: Colors.red.shade200),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.warning,
                                          color: Colors.red.shade400),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Minimum order value should be Rs. ${minimumOrderValue.toString()}',
                                          style: TextStyle(
                                            color: Colors.red.shade700,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            TotalAmountSection(
                              minimumOrderQuantity: minimumOrderValue,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                );
              } catch (e) {
                _logger.severe('Error in StreamBuilder: $e');
                return Center(child: Text(''));
              }
            },
          );
        },
      ),
    );
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyBag()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
        break;
    }
  }

  Scaffold _buildScaffold(BuildContext context, Widget body) {
    return Scaffold(
      appBar: genericAppbar(title: 'My Bag', showBackButton: false),
      body: body,
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: 1, // Set the current index as needed
        onItemTapped: (index) => _onItemTapped(context, index),
      ),
    );
  }
}
