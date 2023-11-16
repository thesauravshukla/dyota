import 'package:flutter/material.dart';

class AddToCartButton extends StatelessWidget {
  const AddToCartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: ElevatedButton(
        onPressed: () {
          // TODO: Handle add to cart button press
        },
        // ignore: sort_child_properties_last
        child: const Text('ADD TO CART'),
        style: ElevatedButton.styleFrom(
          primary: Color.fromARGB(255, 0, 0, 0), // Button color set to black
          onPrimary: Colors.white,
          shape: StadiumBorder(),
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 15),
        ),
      ),
    );
  }
}
