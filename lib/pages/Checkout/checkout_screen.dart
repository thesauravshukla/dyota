import 'package:dyota/components/generic_appbar.dart';
import 'package:dyota/pages/Checkout/Components/checkout_address_section.dart';
import 'package:dyota/pages/Checkout/Components/checkout_payment_section.dart';
import 'package:dyota/pages/Checkout/Components/checkout_submit_button.dart';
import 'package:dyota/pages/Checkout/Components/checkout_summary_section.dart';
import 'package:dyota/pages/Checkout/Components/delivery_method_section.dart';
import 'package:dyota/pages/Checkout/Components/section_title.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class CheckoutScreen extends StatelessWidget {
  final TextEditingController dateController = TextEditingController();
  final Logger _logger = Logger('CheckoutScreen');

  @override
  Widget build(BuildContext context) {
    try {
      _logger.info('Building CheckoutScreen');
      return Scaffold(
        appBar: genericAppbar(title: 'Checkout'),
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
    } catch (e) {
      _logger.severe('Error building CheckoutScreen', e);
      return const Center(child: Text('Error loading checkout screen'));
    }
  }
}
