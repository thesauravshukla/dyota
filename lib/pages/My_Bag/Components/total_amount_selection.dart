import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decimal/decimal.dart';
import 'package:dyota/pages/My_Bag/Components/payment_page.dart';
import 'package:dyota/pages/My_Bag/Components/price_calculator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TotalAmountSection extends StatefulWidget {
  final Decimal minimumOrderQuantity;
  final Function(bool)? onLoadingChanged;
  final Decimal? totalAmount;

  const TotalAmountSection({
    Key? key,
    required this.minimumOrderQuantity,
    this.onLoadingChanged,
    this.totalAmount,
  }) : super(key: key);

  @override
  _TotalAmountSectionState createState() => _TotalAmountSectionState();
}

class _TotalAmountSectionState extends State<TotalAmountSection> {
  bool _isLoading = true;
  bool _hasNotifiedLoading = false;
  late Future<Decimal> _totalAmountFuture;

  @override
  void initState() {
    super.initState();

    if (widget.totalAmount != null) {
      _totalAmountFuture = Future.value(widget.totalAmount!);
      _isLoading = false;
    } else {
      _totalAmountFuture = _calculateTotalAmount();
    }

    // Only notify about loading after a short delay to prevent UI flashing
    Future.delayed(Duration(milliseconds: 100), () {
      if (mounted && !_hasNotifiedLoading && widget.onLoadingChanged != null) {
        _hasNotifiedLoading = true;
        widget.onLoadingChanged!(_isLoading);
      }
    });

    // Safety timeout to ensure loading state is always reset
    Future.delayed(Duration(seconds: 3), () {
      if (mounted && _isLoading) {
        _isLoading = false;
        if (widget.onLoadingChanged != null) {
          widget.onLoadingChanged!(false);
        }
      }
    });
  }

  void _updateLoadingState(bool isLoading) {
    if (_isLoading != isLoading) {
      _isLoading = isLoading;
      if (widget.onLoadingChanged != null) {
        // Add a small delay to prevent rapid state changes
        Future.delayed(Duration(milliseconds: 50), () {
          if (mounted) widget.onLoadingChanged!(_isLoading);
        });
      }
    }
  }

  Future<Decimal> _calculateTotalAmount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) {
      _updateLoadingState(false);
      return Decimal.zero;
    }

    final cartItemsSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.email!)
        .collection('cartItemsList')
        .get();

    final calculator = PriceCalculator(cartItemsSnapshot.docs);
    return calculator.totalAmountDecimal;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Decimal>(
      future: _totalAmountFuture,
      builder: (context, snapshot) {
        // Only set loading state if it's not already loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          if (_isLoading == false) {
            _updateLoadingState(true);
          }
          // Return empty container - parent will show loading indicator
          return const SizedBox(height: 0);
        }

        // Only reset loading if currently loading and data is ready
        if (snapshot.connectionState == ConnectionState.done && _isLoading) {
          // Delay the update to prevent quick flicker
          Future.delayed(Duration.zero, () {
            if (mounted) {
              _updateLoadingState(false);
            }
          });
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final totalAmount = snapshot.data ?? Decimal.zero;

        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Total amount:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Rs. ${totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: totalAmount >= widget.minimumOrderQuantity
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PaymentPage()),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text('Proceed To Payment'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    if (widget.onLoadingChanged != null && _isLoading) {
      Future.microtask(() {
        widget.onLoadingChanged!(false);
      });
    }
    super.dispose();
  }
}
