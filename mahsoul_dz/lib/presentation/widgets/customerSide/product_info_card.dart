import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mahsoul_dz/presentation/themes/colors.dart';

/// Product Info Card Widget
/// Displays small info card with SVG icon and text
class ProductInfoCard extends StatelessWidget {
  final String svgPath;
  final String text;

  const ProductInfoCard({
    super.key,
    required this.svgPath,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: lightColor ?? Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: SvgPicture.asset(
                svgPath,
                width: 20,
                height: 20,
                fit: BoxFit.scaleDown,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              text,
              style: TextStyle(
                color: texColor ?? Colors.green[800],
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
