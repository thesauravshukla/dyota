import 'package:dyota/components/checkout_address_section.dart';
import 'package:dyota/components/checkout_payment_section.dart';
import 'package:dyota/components/checkout_submit_button.dart';
import 'package:dyota/components/checkout_summary_section.dart';
import 'package:dyota/components/delivery_method_section.dart';
import 'package:dyota/components/section_title.dart';
import 'package:flutter/material.dart';

class CheckoutScreen extends StatelessWidget {
  final TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Go back on press
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search action
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Shipping address',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            AddressSection(),
            const SizedBox(height: 16), // Padding beneath the address card

            // Add Payment Heading
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: SectionTitle(title: 'Payment'),
            ),
            PaymentSection(),
            DeliveryMethodSection(),
            SummarySection(),
            SubmitButton(),
          ],
        ),
      ),
    );
  }
}
