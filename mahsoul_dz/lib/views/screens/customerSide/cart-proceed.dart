import 'package:flutter/material.dart';
import 'package:mahsoul_dz/l10n/app_localizations.dart';
import 'package:mahsoul_dz/views/screens/customerSide/order_confirmation_dialog.dart';
import 'package:mahsoul_dz/views/widgets/common/page_with_nav.dart';

/// Order Proceed Page - Shows customer information and order summary before confirmation
class OrderConfirmationPage extends StatelessWidget {
  const OrderConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return PageWithNav(
      currentIndex: 0, // Home tab
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.checkout,
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Customer Information Card
            _buildCustomerInfoCard(context, l10n),
            const SizedBox(height: 20),

            // Order Summary
            Text(
              l10n.orderSummary,
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
            _buildTotalSection(l10n),

            const SizedBox(height: 30),

            // Confirm Order Button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  // Show order confirmation dialog
                  OrderConfirmationDialog.show(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  l10n.confirmOrder,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      ), // PageWithNav
    );
  }

  Widget _buildCustomerInfoCard(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.personalInfo,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 20),
          _buildInfoRow(Icons.person_outline, l10n.fullName, "Sarah Johnson", l10n),
          const SizedBox(height: 18),
          _buildInfoRow(Icons.phone_outlined, l10n.phoneNumber, "+1 (555) 123-4567", l10n),
          const SizedBox(height: 18),
          _buildInfoRow(
            Icons.location_on_outlined,
            l10n.deliveryAddress,
            "1234 Oak Street, Apt 2B\nGreenville, CA 90210",
            l10n,
          ),
          const SizedBox(height: 18),
          _buildInfoRow(
            Icons.note_outlined,
            l10n.orderNotes,
            l10n.addNotes,
            l10n,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value, AppLocalizations l10n) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF4CAF50), size: 22),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF757575),
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(0xFF1A1A1A),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        Text(
          l10n.edit,
          style: TextStyle(
            color: const Color(0xFF4CAF50),
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
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

  Widget _buildTotalSection(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _TotalRow(l10n.subtotal, "\$55.50"),
          SizedBox(height: 12),
          _TotalRow(l10n.deliveryFee, l10n.free, isFree: true),
          SizedBox(height: 12),
          Divider(thickness: 1),
          SizedBox(height: 12),
          _TotalRow(l10n.total, "\$55.50", isBold: true),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final bool isFree;

  const _TotalRow(this.label, this.value,
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
