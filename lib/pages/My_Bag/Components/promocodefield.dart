import 'package:dyota/pages/My_Bag/Components/promocodemodal.dart';
import 'package:flutter/material.dart';

class PromoCodeField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: InkWell(
        onTap: () => _showPromoCodeModal(context),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Enter your promo code',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16.0,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black, // Background color for the circle
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(1), // The size of the circle
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPromoCodeModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return PromoCodeModal();
      },
      shape: RoundedRectangleBorder(
        // This provides the rounded corners for the modal.
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20), // Adjust the radius as needed
        ),
      ),
    );
  }
}
