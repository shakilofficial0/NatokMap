import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Show error dialog with futuristic design
void showErrorDialog(
  BuildContext context, {
  required String title,
  required String message,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: isDark ? AppTheme.glassBlue : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark 
              ? AppTheme.primaryNeon.withOpacity(0.3)
              : Colors.red.withOpacity(0.3),
          width: 1,
        ),
      ),
      title: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: Color(0xFFFF4444),
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'OK',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: isDark ? AppTheme.primaryNeon : const Color(0xFF0066FF),
                ),
          ),
        ),
      ],
    ),
  );
}

/// Show success snackbar
void showSuccessSnackbar(
  BuildContext context, {
  required String message,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final successColor = isDark ? AppTheme.accentNeon : const Color(0xFF03DAC6);
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: successColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: isDark ? AppTheme.glassBlue : Colors.white,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: successColor.withOpacity(0.5),
          width: 1,
        ),
      ),
      duration: const Duration(seconds: 3),
    ),
  );
}

/// Show info snackbar
void showInfoSnackbar(
  BuildContext context, {
  required String message,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final infoColor = isDark ? AppTheme.primaryNeon : const Color(0xFF0066FF);
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: infoColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: isDark ? AppTheme.glassBlue : Colors.white,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: infoColor.withOpacity(0.5),
          width: 1,
        ),
      ),
      duration: const Duration(seconds: 3),
    ),
  );
}
