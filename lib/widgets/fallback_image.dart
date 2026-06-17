import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FallbackImage extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const FallbackImage({
    Key? key,
    this.width = double.infinity,
    this.height = double.infinity,
    this.borderRadius = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.landscape, size: 40, color: AppTheme.textSecondary.withOpacity(0.5)),
            const SizedBox(height: 8),
            Text(
              'Aucune image',
              style: TextStyle(
                color: AppTheme.textSecondary.withOpacity(0.8),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
