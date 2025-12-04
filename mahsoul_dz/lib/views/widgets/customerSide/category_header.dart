import 'package:flutter/material.dart';
import 'package:mahsoul_dz/l10n/app_localizations.dart';

class CategoryHeader extends StatelessWidget {
  final String categoryName;
  final AppLocalizations? l10n;

  const CategoryHeader({
    super.key,
    required this.categoryName,
    this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = l10n ?? AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          categoryName,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D5F3F),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          localizations.discoverFreshFromFarms(categoryName),
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
