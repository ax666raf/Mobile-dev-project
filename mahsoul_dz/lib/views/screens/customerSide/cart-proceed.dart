import 'package:flutter/material.dart';

class OrderConfirmationPage extends StatelessWidget {
  const OrderConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: const Text(
          "Proceed with Your Order",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Customer Information Card
            _buildCustomerInfoCard(),
            const SizedBox(height: 20),

            // Order Summary
            const Text(
              "Order Summary",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87),
            ),
            const SizedBox(height: 10),
            _buildOrderItem(
                title: "Organic Tomatoes",
                subtitle: "Green Valley Farm",
                quantity: "10 kg",
                price: "\$28.50"),
            _buildOrderItem(
                title: "Organic Carrots",
                subtitle: "Healthy Roots",
                quantity: "10 kg",
                price: "\$27.00"),
            const SizedBox(height: 20),

            // Totals
            _buildTotalSection(),

            const SizedBox(height: 30),

            // Confirm Order Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "Confirm Order",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Customer Information",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 20),
          _buildInfoRow(Icons.person, "Full Name", "Sarah Johnson"),
          const SizedBox(height: 20),
          _buildInfoRow(Icons.phone, "Phone Number", "+1 (555) 123-4567"),
          const SizedBox(height: 20),
          _buildInfoRow(Icons.location_on, "Delivery Address",
              "1234 Oak Street, Apt 2B\nGreenville, CA 90210"),
          const SizedBox(height: 20),
          _buildInfoRow(Icons.note, "Additional Notes (Optional)",
              "e.g., leave at the gate"),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.green, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 12, color: Colors.black54, height: 1.5)),
              Text(value,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.3)),
            ],
          ),
        ),
        Text("Edit",
            style: TextStyle(
                color: Colors.green.shade700,
                fontWeight: FontWeight.w500,
                fontSize: 13)),
      ],
    );
  }

  Widget _buildOrderItem({
    required String title,
    required String subtitle,
    required String quantity,
    required String price,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          // Placeholder for image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child:  Center(
              child:Image.asset(
              'lib/assets/carrot.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.shopping_bag,
                  color: Colors.white,
                  size: 30, // Smaller icon
                );
              },
            ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                Text(subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.black54)),
                Text(quantity,
                    style: const TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ),
          Text(price,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildTotalSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: const [
          _buildTotalRow("Subtotal", "\$55.50"),
          SizedBox(height: 8),
          _buildTotalRow("Delivery Fee", "FREE", isFree: true),
          Divider(),
          _buildTotalRow("Total", "\$55.50", isBold: true),
        ],
      ),
    );
  }
}

class _buildTotalRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final bool isFree;

  const _buildTotalRow(this.label, this.value,
      {this.isBold = false, this.isFree = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        Text(value,
            style: TextStyle(
              fontSize: 14,
              color: isFree ? Colors.green : Colors.black87,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            )),
      ],
    );
  }
}