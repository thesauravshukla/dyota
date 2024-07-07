import 'package:dyota/pages/Category/Components/product_list_item.dart';
import 'package:flutter/material.dart';

class ProductGrid extends StatelessWidget {
  final List<String> documentIds;

  const ProductGrid({Key? key, required this.documentIds}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: documentIds.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ProductListItem(documentId: documentIds[index]),
        );
      },
    );
  }
}
