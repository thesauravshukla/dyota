import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dyota/pages/Select_Shipping_Address/Components/address_dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddressManager {
  int? selectedAddress; // It can be null when no address is selected
  List<Map<String, dynamic>> addresses = [];

  Future<void> fetchAddresses(BuildContext context) async {
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

      addresses = fetchedAddresses;
      if (addresses.isNotEmpty) {
        selectedAddress = 0; // Automatically select the first address
      }
    } catch (e) {
      print('Error fetching addresses: $e');
    }
  }

  Future<void> addNewAddress(
      BuildContext context, String title, String address) async {
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

      await userDocRef.update({
        'addressCount': addressCount + 1,
        'address${addressCount + 1}': {
          'Title': title,
          'Address': address,
          'isMainAddress': addressCount == 0 ? 1 : 0,
        },
      });

      fetchAddresses(context); // Refresh the addresses list
      selectedAddress = addressCount; // Automatically select the new address
    } catch (e) {
      print('Error adding new address: $e');
    }
  }

  Future<void> editAddress(
      BuildContext context, int index, String title, String address) async {
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

      fetchAddresses(context); // Refresh the addresses list
    } catch (e) {
      print('Error editing address: $e');
    }
  }

  Future<void> setMainAddress(BuildContext context, int index) async {
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
      fetchAddresses(context); // Refresh the addresses list
    } catch (e) {
      print('Error setting main address: $e');
    }
  }

  Future<void> deleteAddress(BuildContext context, int indexToDelete) async {
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
    fetchAddresses(context); // Refresh the addresses list
  }

  void showAddAddressDialog(BuildContext context) {
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
            await addNewAddress(context, title, address);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void showEditAddressDialog(BuildContext context, int index) {
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
            await editAddress(context, index, title, address);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void showDeleteConfirmationDialog(BuildContext context, int index) {
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
                deleteAddress(
                    context, index); // Proceed with deleting the address
              },
            ),
          ],
        );
      },
    );
  }

  void handlePay(BuildContext context) {
    if (addresses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Select at least one address')),
      );
      return;
    }
    // Implement your payment logic here
  }
}
