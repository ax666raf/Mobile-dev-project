import 'package:flutter/material.dart';
import 'package:mahsoul_dz/l10n/app_localizations.dart';

class ProductDetailsCard extends StatelessWidget {
  final String origin;
  final String harvestDate;
  final bool isOrganic;
  final String storage;

  const ProductDetailsCard({
    super.key,
    required this.origin,
    required this.harvestDate,
    this.isOrganic = false,
    required this.storage,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.productDetails,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _detailRow(
            context,
            l10n.originLabel,
            origin,
            Icons.location_on_outlined,
          ),
          _detailRow(
            context,
            l10n.harvestDateLabel,
            harvestDate,
            Icons.calendar_today_outlined,
          ),
          _detailRow(
            context,
            l10n.organicLabel,
            isOrganic ? l10n.yesCertified : l10n.no,
            Icons.eco_outlined,
          ),
          _detailRow(
            context,
            l10n.storageLabel,
            storage,
            Icons.thermostat_outlined,
          ),
        ],
      ),
    );
  }

  Widget _detailRow(BuildContext context, String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
