import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Show error dialog with futuristic design
void showErrorDialog(
  BuildContext context, {
  required String title,
  required String message,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppTheme.glassBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppTheme.primaryNeon.withOpacity(0.3),
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
                  color: AppTheme.primaryNeon,
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
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: AppTheme.accentNeon,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
      backgroundColor: AppTheme.glassBlue,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppTheme.accentNeon.withOpacity(0.5),
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
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(
            Icons.info_outline,
            color: AppTheme.primaryNeon,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
      backgroundColor: AppTheme.glassBlue,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppTheme.primaryNeon.withOpacity(0.5),
          width: 1,
        ),
      ),
      duration: const Duration(seconds: 3),
    ),
  );
}
