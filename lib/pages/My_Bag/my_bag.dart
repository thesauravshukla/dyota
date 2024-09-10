import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dyota/components/generic_appbar.dart';
import 'package:dyota/pages/My_Bag/Components/itemcard.dart';
import 'package:dyota/pages/My_Bag/Components/total_amount_selection.dart';
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
      StreamBuilder<QuerySnapshot>(
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
                // PromoCodeField(),
                TotalAmountSection(),
              ],
            );
          } catch (e) {
            _logger.severe('Error in StreamBuilder: $e');
            return Center(child: Text(''));
          }
        },
      ),
    );
  }

  Scaffold _buildScaffold(BuildContext context, Widget body) {
    return Scaffold(
      appBar: genericAppbar(title: 'My Bag', showBackButton: false),
      body: body,
    );
  }
}
