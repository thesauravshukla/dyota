import 'package:dyota/components/add_to_cart_button.dart';
import 'package:dyota/components/dropdown_length_select.dart';
import 'package:dyota/components/image_placeholder.dart';
import 'package:dyota/components/product_details_section.dart';
import 'package:dyota/components/product_information.dart';
import 'package:dyota/components/shipping_info.dart';
import 'package:dyota/components/support_section.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({super.key});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  String? selectedLength;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Card'),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {/* TODO */}),
          IconButton(
              icon: const Icon(Icons.more_vert), onPressed: () {/* TODO */}),
        ],
      ),
      body: ListView(
        children: <Widget>[
          const ImagePlaceholder(),
          DropdownLengthSelect(
            selectedValue: selectedLength,
            onChanged: (String? newValue) {
              setState(() => selectedLength = newValue);
            },
          ),
          const ProductInformation(),
          const ProductDetailsSection(),
          // OrderSwatchesButton(),
          const AddToCartButton(),
          const ShippingInfo(),
          const SupportSection(),
        ],
      ),
    );
  }
}
