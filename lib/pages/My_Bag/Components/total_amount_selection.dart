import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decimal/decimal.dart';
import 'package:dyota/pages/My_Bag/Components/payment_page.dart';
import 'package:dyota/pages/My_Bag/Components/price_calculator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

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
  final Logger _logger = Logger('TotalAmountSection');
  bool _isLoading = true;
  bool _hasNotifiedLoading = false;
  late Future<Decimal> _totalAmountFuture;

  @override
  void initState() {
    super.initState();
    _initializeTotalAmount();
    _scheduleInitialLoadingNotification();
    _setupSafetyTimeout();
  }

  void _initializeTotalAmount() {
    if (widget.totalAmount != null) {
      _totalAmountFuture = Future.value(widget.totalAmount!);
      _isLoading = false;
    } else {
      _totalAmountFuture = _calculateTotalAmount();
    }
  }

  void _scheduleInitialLoadingNotification() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_shouldNotifyInitialLoading()) {
        _hasNotifiedLoading = true;
        _notifyLoadingState(_isLoading);
      }
    });
  }

  bool _shouldNotifyInitialLoading() {
    return mounted && !_hasNotifiedLoading && widget.onLoadingChanged != null;
  }

  void _setupSafetyTimeout() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _isLoading) {
        _isLoading = false;
        _notifyLoadingState(false);
      }
    });
  }

  void _updateLoadingState(bool isLoading) {
    if (_isLoading != isLoading) {
      _isLoading = isLoading;
      _notifyLoadingState(_isLoading);
    }
  }

  void _notifyLoadingState(bool isLoading) {
    if (widget.onLoadingChanged != null && mounted) {
      // Add a small delay to prevent rapid state changes
      Future.delayed(const Duration(milliseconds: 50), () {
        if (mounted) widget.onLoadingChanged!(isLoading);
      });
    }
  }

  Future<Decimal> _calculateTotalAmount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (_isUserNotLoggedIn(user)) {
      _updateLoadingState(false);
      return Decimal.zero;
    }

    return _fetchCartItemsAndCalculate(user!.email!);
  }

  bool _isUserNotLoggedIn(User? user) {
    return user == null || user.email == null;
  }

  Future<Decimal> _fetchCartItemsAndCalculate(String userEmail) async {
    final cartItemsSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
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
        return _buildContent(snapshot);
      },
    );
  }

  Widget _buildContent(AsyncSnapshot<Decimal> snapshot) {
    if (_isLoadingData(snapshot)) {
      _updateLoadingStateIfNeeded(true);
      return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Total amount:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              height: 32,
              child: const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 48,
              child: ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Loading...'),
              ),
            ),
          ],
        ),
      );
    }

    if (_hasDataLoaded(snapshot)) {
      _updateLoadingStateIfNeeded(false);
    }

    if (snapshot.hasError) {
      _logger.severe('Error loading total amount: ${snapshot.error}');
      return Center(child: Text('Error: ${snapshot.error}'));
    }

    final totalAmount = snapshot.data ?? Decimal.zero;
    return _buildTotalAmountDisplay(totalAmount);
  }

  bool _isLoadingData(AsyncSnapshot<Decimal> snapshot) {
    return snapshot.connectionState == ConnectionState.waiting;
  }

  bool _hasDataLoaded(AsyncSnapshot<Decimal> snapshot) {
    return snapshot.connectionState == ConnectionState.done && _isLoading;
  }

  void _updateLoadingStateIfNeeded(bool isLoading) {
    if (isLoading != _isLoading) {
      Future.delayed(Duration.zero, () {
        if (mounted) {
          _updateLoadingState(isLoading);
        }
      });
    }
  }

  Widget _buildTotalAmountDisplay(Decimal totalAmount) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Total amount:',
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text('Rs. ${totalAmount.toStringAsFixed(2)}',
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          const SizedBox(height: 16),
          _buildPaymentButton(totalAmount),
        ],
      ),
    );
  }

  Widget _buildPaymentButton(Decimal totalAmount) {
    final bool canProceedToPayment = totalAmount >= widget.minimumOrderQuantity;

    return ElevatedButton(
      onPressed: canProceedToPayment ? _navigateToPaymentPage : null,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: const Text('Proceed To Payment'),
    );
  }

  void _navigateToPaymentPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaymentPage()),
    );
  }

  @override
  void dispose() {
    if (widget.onLoadingChanged != null && _isLoading) {
      _notifyLoadingState(false);
    }
    super.dispose();
  }
}
