import 'package:dyota/components/generic_appbar.dart';
import 'package:dyota/pages/Select_Shipping_Address/Components/address_card.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shipping Addresses',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ShippingAddressesScreen(),
    );
  }
}

class ShippingAddressesScreen extends StatefulWidget {
  @override
  _ShippingAddressesScreenState createState() =>
      _ShippingAddressesScreenState();
}

class _ShippingAddressesScreenState extends State<ShippingAddressesScreen> {
  int? _selectedAddress; // It can be null when no address is selected

  void _toggleSelection(int? index) {
    setState(() {
      if (_selectedAddress == index) {
        // Unselect if the same address was selected again
        _selectedAddress = null;
      } else {
        // Select the tapped address
        _selectedAddress = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: genericAppbar(title: 'Shipping Address'),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: <Widget>[
          AddressCard(
            index: 0,
            name: 'Jane Doe',
            address: '3 Newbridge Court\nChino Hills, CA 91709, United States',
            isSelected: _selectedAddress == 0,
            onSelected: _toggleSelection,
            onEdit: () {
              // TODO: Implement edit address logic
            },
          ),
          // Repeat AddressCard for other addresses with unique indexes...
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement add new address logic
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.black,
      ),
    );
  }
}
