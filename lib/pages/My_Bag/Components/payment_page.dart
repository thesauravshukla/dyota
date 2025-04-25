import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decimal/decimal.dart';
import 'package:dyota/components/generic_appbar.dart';
import 'package:dyota/pages/My_Bag/Components/price_calculator.dart';
import 'package:dyota/pages/Payment/payments.dart';
import 'package:dyota/pages/Select_Shipping_Address/Components/address_card.dart';
import 'package:dyota/pages/Select_Shipping_Address/Components/address_dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int? _selectedAddress; // It can be null when no address is selected
  List<Map<String, dynamic>> addresses = [];

  void _handlePay() async {
    if (addresses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Select at least one address')),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You need to be logged in to make a payment')),
      );
      return;
    }

    final email = user.email!;
    final cartItemsSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .collection('cartItemsList')
        .get();

    final cartItemIds = cartItemsSnapshot.docs.map((doc) => doc.id).toList();
    final orderId = Uuid().v4(); // Generate a unique order ID
    final timestamp = FieldValue.serverTimestamp();

    final totalAmount = PriceCalculator(cartItemsSnapshot.docs).totalAmount;

    // Initiate Razorpay payment
    String paymentResult = 'success';

    if (paymentResult == 'success') {
      final selectedAddressData = addresses[_selectedAddress!];

      final orderData = {
        'cartItems': cartItemIds,
        'deliveryAddress': {
          'displayName': 'Delivery Address',
          'toDisplay': 1,
          'title': selectedAddressData['Title'],
          'address': selectedAddressData['Address'],
        },
        'orderId': {
          'displayName': 'Order ID',
          'toDisplay': 1,
          'value': orderId,
        },
        'orderTimestamp': timestamp,
        'totalAmount': {
          'displayName': 'Total Amount',
          'toDisplay': 1,
          'value': totalAmount.toString(),
        },
      };

      final orderDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .collection('processingOrderList')
          .doc(orderId);

      WriteBatch batch = FirebaseFirestore.instance.batch();

      // Add the order data
      batch.set(orderDocRef, orderData);

      // Delete all cart items
      for (var doc in cartItemsSnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order placed successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed. Please try again.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAddresses();
  }

  Future<void> _fetchAddresses() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You need to be logged in to view addresses')),
      );
      return;
    }

    final email = user.email;
    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(email);
    try {
      DocumentSnapshot userDoc = await userDocRef.get();
      int addressCount = userDoc['addressCount'] ?? 0;

      List<Map<String, dynamic>> fetchedAddresses = [];
      for (int i = 1; i <= addressCount; i++) {
        Map<String, dynamic> addressData = userDoc['address$i'];
        fetchedAddresses.add(addressData);
      }

      setState(() {
        addresses = fetchedAddresses;
        if (addresses.isNotEmpty) {
          _selectedAddress = 0; // Automatically select the first address
        }
      });
    } catch (e) {
      print('Error fetching addresses: $e');
    }
  }

  Future<void> _addNewAddress(String title, String address) async {
    if (title.isEmpty || address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Both title and address are required')),
      );
      return;
    }

    // Validate address format (should be in format: street, city, state, postal code)
    final addressParts = address.split(',');
    if (addressParts.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Address is incomplete or in incorrect format')),
      );
      return;
    }

    // Validate postal code (should be 6 digits for Indian postal codes)
    final postalCode = addressParts[3].trim();
    if (!RegExp(r'^\d{6}$').hasMatch(postalCode)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Invalid postal code format. Should be 6 digits')),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You need to be logged in to add an address')),
      );
      return;
    }

    final email = user.email;
    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(email);
    try {
      DocumentSnapshot userDoc = await userDocRef.get();
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      int addressCount =
          userData.containsKey('addressCount') ? userData['addressCount'] : 0;

      print('Adding new address: $title, $address'); // Debug print

      await userDocRef.update({
        'addressCount': addressCount + 1,
        'address${addressCount + 1}': {
          'Title': title,
          'Address': address,
          'isMainAddress': addressCount == 0 ? 1 : 0,
        },
      });

      print('Address added successfully'); // Debug print

      _fetchAddresses(); // Refresh the addresses list

      setState(() {
        _selectedAddress = addressCount; // Automatically select the new address
      });
    } catch (e) {
      print('Error adding new address: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add address: ${e.toString()}')),
      );
    }
  }

  Future<void> _editAddress(int index, String title, String address) async {
    if (title.isEmpty || address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Both title and address are required')),
      );
      return;
    }

    // Validate address format
    final addressParts = address.split(',');
    if (addressParts.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Address is incomplete or in incorrect format')),
      );
      return;
    }

    // Validate postal code
    final postalCode = addressParts[3].trim();
    if (!RegExp(r'^\d{6}$').hasMatch(postalCode)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Invalid postal code format. Should be 6 digits')),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You need to be logged in to edit an address')),
      );
      return;
    }

    final email = user.email;
    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(email);
    try {
      await userDocRef.update({
        'address${index + 1}': {
          'Title': title,
          'Address': address,
          'isMainAddress': addresses[index]['isMainAddress'],
        },
      });

      _fetchAddresses(); // Refresh the addresses list
    } catch (e) {
      print('Error editing address: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to edit address: ${e.toString()}')),
      );
    }
  }

  Future<void> _setMainAddress(int index) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('You need to be logged in to set a main address')),
      );
      return;
    }

    final email = user.email;
    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(email);
    WriteBatch batch = FirebaseFirestore.instance.batch();

    try {
      for (int i = 0; i < addresses.length; i++) {
        batch.update(userDocRef, {
          'address${i + 1}.isMainAddress': i == index ? 1 : 0,
        });
      }

      await batch.commit();
      _fetchAddresses(); // Refresh the addresses list
    } catch (e) {
      print('Error setting main address: $e');
    }
  }

  Future<void> _deleteAddress(int indexToDelete) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('You need to be logged in to delete an address')),
      );
      return;
    }

    final email = user.email;
    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(email);
    DocumentSnapshot userDoc = await userDocRef.get();
    int addressCount = userDoc['addressCount'];

    WriteBatch batch = FirebaseFirestore.instance.batch();

    // Delete the selected address and shift subsequent addresses
    for (int i = indexToDelete + 1; i <= addressCount; i++) {
      if (i == addressCount) {
        // Delete the last address field
        batch.update(userDocRef, {'address$i': FieldValue.delete()});
      } else {
        // Shift addresses
        var nextAddress = userDoc['address${i + 1}'];
        batch.update(userDocRef, {'address$i': nextAddress});
      }
    }

    // Update the address count
    batch.update(userDocRef, {'addressCount': addressCount - 1});

    // If the deleted address was the main address, assign a new main address randomly
    if (addresses[indexToDelete]['isMainAddress'] == 1 && addressCount > 1) {
      int newMainIndex =
          indexToDelete == 0 ? 1 : 0; // Simple logic to assign new main
      batch.update(userDocRef, {'address$newMainIndex.isMainAddress': 1});
    }

    await batch.commit();
    _fetchAddresses(); // Refresh the addresses list
  }

  void _showAddAddressDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddressDialog(
          title: 'Add New Address',
          onSave: (title, address) async {
            if (title.isEmpty || address.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('All fields are required')),
              );
              return;
            }
            await _addNewAddress(title, address);
            Navigator.of(context).pop();
            setState(() {}); // Refresh the UI
          },
        );
      },
    );
  }

  void _showEditAddressDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddressDialog(
          title: 'Edit Address',
          initialTitle: addresses[index]['Title'],
          initialAddress: addresses[index]['Address'],
          onSave: (title, address) async {
            if (title.isEmpty || address.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('All fields are required')),
              );
              return;
            }
            await _editAddress(index, title, address);
            Navigator.of(context).pop();
            setState(() {}); // Refresh the UI
          },
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Do you really want to delete this address?"),
          actions: <Widget>[
            TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _deleteAddress(index); // Proceed with deleting the address
              },
            ),
          ],
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> _fetchCartItems() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) {
      return [];
    }

    final email = user.email!;
    final cartItemsSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .collection('cartItemsList')
        .get();

    List<Map<String, dynamic>> items = [];

    for (var doc in cartItemsSnapshot.docs) {
      final data = doc.data();
      final priceMap = data['price'] as Map<String, dynamic>? ?? {'value': 0.0};
      final productNameMap =
          data['productName'] as Map<String, dynamic>? ?? {'value': 'Unknown'};

      final priceValue =
          Decimal.parse(priceMap['value'].toString()) ?? Decimal.zero;
      final productName = productNameMap['value'] ?? 'Unknown';

      items.add({
        'productName': productName,
        'price': priceValue,
      });
    }

    return items;
  }

  Future<Decimal> _calculateTax() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) {
      return Decimal.zero;
    }

    final email = user.email!;
    final cartItemsSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .collection('cartItemsList')
        .get();

    Decimal totalTax = Decimal.zero;

    for (var doc in cartItemsSnapshot.docs) {
      final data = doc.data();
      if (data.containsKey('tax') && data['tax'] is Map<String, dynamic>) {
        final taxMap = data['tax'] as Map<String, dynamic>;
        if (taxMap.containsKey('value')) {
          Decimal taxValue = Decimal.parse(taxMap['value'].toString());
          totalTax += taxValue;
        }
      }
    }

    return totalTax;
  }

  Future<String> _moveCartItemsToOrder() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) {
      throw Exception('User not logged in');
    }

    final email = user.email!;

    final now = DateTime.now();
    final randomNum =
        (100 + Random().nextInt(900)); // Random 3-digit number between 100-999
    final orderId =
        '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-'
        '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}-'
        '$randomNum';

    try {
      // Get all cart items
      final cartItemsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .collection('cartItemsList')
          .get();

      // Start a batch write
      WriteBatch batch = FirebaseFirestore.instance.batch();

      // For each cart item
      for (var doc in cartItemsSnapshot.docs) {
        // Create a reference to the new location
        final newDocRef = FirebaseFirestore.instance
            .collection('users')
            .doc(email)
            .collection('orders')
            .doc(orderId)
            .collection('items')
            .doc(doc.id);

        // Add the document to the new location
        batch.set(newDocRef, doc.data());

        // Delete the document from the cart
        batch.delete(doc.reference);
      }

      // Add order metadata
      final orderMetadataRef = FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .collection('orders')
          .doc(orderId);

      batch.set(orderMetadataRef, {
        'orderId': orderId,
        'orderDate': FieldValue.serverTimestamp(),
        'status': 'Pending',
        'totalItems': cartItemsSnapshot.docs.length,
        'totalAmount': {
          'displayName': 'Total Amount',
          'value':
              PriceCalculator(cartItemsSnapshot.docs).totalAmount.toString(),
          'prefix': 'Rs. ',
          'toDisplay': 1,
        }
      });

      // Commit the batch
      await batch.commit();

      return orderId;
    } catch (e) {
      print('Error moving cart items to order: $e');
      throw Exception('Failed to create order');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: genericAppbar(title: 'Payment Page'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Amount',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchCartItems(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final items = snapshot.data ?? [];
                Decimal subtotal = items.fold(
                    Decimal.zero, (sum, item) => sum + item['price']);

                return FutureBuilder<Decimal>(
                  future: _calculateTax(),
                  builder: (context, taxSnapshot) {
                    if (taxSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (taxSnapshot.hasError) {
                      return Center(child: Text('Error: ${taxSnapshot.error}'));
                    }

                    Decimal tax = taxSnapshot.data ?? Decimal.zero;
                    Decimal totalAmount = subtotal + tax;

                    return Container(
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.only(top: 8, bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.black87, // Blackish color
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Items',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white), // White text
                          ),
                          ...items.map((item) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${item['productName']}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white), // White text
                                ),
                                Text(
                                  'Rs. ${item['price'].toStringAsFixed(2)}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white), // White text
                                ),
                              ],
                            );
                          }).toList(),
                          Divider(color: Colors.white), // White divider
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Tax',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white), // White text
                              ),
                              Text(
                                'Rs. ${tax.toStringAsFixed(2)}',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white), // White text
                              ),
                            ],
                          ),
                          Divider(color: Colors.white), // White divider
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white), // White text
                              ),
                              Text(
                                'Rs. ${totalAmount.toStringAsFixed(2)}',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white), // White text
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Deliver To',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: _showAddAddressDialog,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    backgroundColor: Colors.black, // Button color
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    'Add New Address',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            Flexible(
              child: ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: addresses.length,
                itemBuilder: (context, index) {
                  final address = addresses[index];
                  bool isMain = address['isMainAddress'] == 1;
                  return AddressCard(
                    index: index,
                    name: address['Title'],
                    address: address['Address'],
                    isSelected: isMain,
                    onSelected: (idx) {
                      if (idx != null) {
                        setState(() {
                          _selectedAddress = idx;
                        });
                        _setMainAddress(idx);
                      }
                    },
                    onEdit: () => _showEditAddressDialog(index),
                    onDelete: () => _showDeleteConfirmationDialog(index),
                    onMainAddressChanged: (bool isMain) {
                      if (isMain) {
                        setState(() {
                          _selectedAddress = index;
                        });
                        _setMainAddress(index);
                      }
                    },
                  );
                },
              ),
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () => _moveCartItemsToOrder(),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  backgroundColor: addresses.isEmpty
                      ? Colors.white
                      : Colors.black, // Button color
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(
                  'Pay Now',
                  style: TextStyle(
                    color: addresses.isEmpty
                        ? Colors.black
                        : Colors.white, // Text color
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
