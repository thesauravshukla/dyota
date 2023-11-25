import 'package:dyota/components/generic_appbar.dart';
import 'package:dyota/pages/Product_Card/Components/add_to_cart_button.dart';
import 'package:dyota/pages/Product_Card/Components/dropdown_length_select.dart';
import 'package:dyota/pages/Product_Card/Components/image_placeholder.dart';
import 'package:dyota/pages/Product_Card/Components/product_details_section.dart';
import 'package:dyota/pages/Product_Card/Components/product_information.dart';
import 'package:dyota/pages/Product_Card/Components/shipping_info.dart';
import 'package:dyota/pages/Product_Card/Components/support_section.dart';
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
      appBar: genericAppbar(title: 'Product Card'),
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
