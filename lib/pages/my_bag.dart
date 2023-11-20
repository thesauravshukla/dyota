import 'package:dyota/components/bottom_navigation_bar_component.dart';
import 'package:dyota/components/mybag_appbar.dart';
import 'package:dyota/components/mybag_itemcard.dart';
import 'package:dyota/components/promocodefield.dart';
import 'package:dyota/components/total_amount_selection.dart';
import 'package:flutter/material.dart';

class MyBag extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyBagAppBar(),
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
