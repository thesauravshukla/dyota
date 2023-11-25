import 'package:dyota/components/bottom_navigation_bar_component.dart';
import 'package:dyota/components/generic_appbar.dart';
import 'package:dyota/pages/My_Bag/Components/mybag_itemcard.dart';
import 'package:dyota/pages/My_Bag/Components/promocodefield.dart';
import 'package:dyota/pages/My_Bag/Components/total_amount_selection.dart';
import 'package:flutter/material.dart';

class MyBag extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: genericAppbar(title: 'My Bag'),
      body: ListView(
        children: [
          ItemCard(),
          ItemCard(),
          ItemCard(),
          PromoCodeField(),
          TotalAmountSection(),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
