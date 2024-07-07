import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dyota/components/generic_appbar.dart';
import 'package:dyota/pages/My_Bag/Components/itemcard.dart';
import 'package:dyota/pages/My_Bag/Components/promocodefield.dart';
import 'package:dyota/pages/My_Bag/Components/total_amount_selection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyBag extends StatefulWidget {
  @override
  _MyBagState createState() => _MyBagState();
}

class _MyBagState extends State<MyBag> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) {
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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('Error fetching data: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Your bag is empty.'));
          }

          List<Widget> itemCards = snapshot.data!.docs.map<Widget>((document) {
            return ItemCard(
              documentId: document.id,
              onDelete: () {
                setState(() {});
              },
            );
          }).toList();

          return ListView(
            children: [
              ...itemCards,
              PromoCodeField(),
              TotalAmountSection(),
            ],
          );
        },
      ),
    );
  }

  Scaffold _buildScaffold(BuildContext context, Widget body) {
    return Scaffold(
      appBar: genericAppbar(title: 'My Bag'),
      body: body,
    );
  }
}
