import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dyota/components/generic_appbar.dart';
import 'package:dyota/components/shared/app_confirm_dialog.dart';
import 'package:dyota/pages/Select_Shipping_Address/Components/address_card.dart';
import 'package:dyota/pages/Select_Shipping_Address/Components/address_dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ShippingAddressesScreen extends StatefulWidget {
  @override
  _ShippingAddressesScreenState createState() =>
      _ShippingAddressesScreenState();
}

class _ShippingAddressesScreenState extends State<ShippingAddressesScreen> {
  int? _selectedAddress; // It can be null when no address is selected
  List<Map<String, dynamic>> addresses = [];

  @override
  void initState() {
    super.initState();
    _fetchAddresses();
  }

  void _toggleSelection(int? index) {
    setState(() {
      if (_selectedAddress == index) {
        _selectedAddress = null;
      } else {
        _selectedAddress = index;
      }
    });
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
      });
    } catch (e) {
      print('Error fetching addresses: $e');
    }
  }

  Future<void> _addNewAddress(String title, String address) async {
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
    } catch (e) {
      print('Error adding new address: $e');
    }
  }

  Future<void> _editAddress(int index, String title, String address) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: genericAppbar(title: 'Shipping Address'),
      body: ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: addresses.length,
        itemBuilder: (context, index) {
          final address = addresses[index];
          bool isMain = address['isMainAddress'] ==
              1; // Check if the address is marked as main
          return AddressCard(
            index: index,
            name: address['Title'],
            address: address['Address'],
            isSelected:
                isMain, // Use isMain to determine if the address is selected
            onSelected: (idx) {
              if (idx != null) {
                _setMainAddress(idx); // Ensure idx is not null before passing
              }
            },
            onEdit: () => _showEditAddressDialog(index),
            onDelete: () => _showDeleteConfirmationDialog(index),
            onMainAddressChanged: (bool isMain) {
              if (isMain) {
                _setMainAddress(index);
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddAddressDialog,
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _showAddAddressDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddressDialog(
          title: 'Add New Address',
          onSave: (title, address) async {
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
            await _editAddress(index, title, address);
            Navigator.of(context).pop();
            setState(() {}); // Refresh the UI
          },
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(int index) async {
    final confirmed = await showAppConfirmDialog(
      context,
      title: 'Confirm Delete',
      message: 'Do you really want to delete this address?',
    );
    if (confirmed) {
      _deleteAddress(index);
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
}
