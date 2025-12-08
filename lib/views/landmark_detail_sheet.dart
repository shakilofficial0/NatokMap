import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/landmark_controller.dart';
import '../models/landmark.dart';
import '../theme/app_theme.dart';
import '../widgets/dialogs.dart';
import '../widgets/glass_card.dart';
import 'form_view.dart';

/// Bottom sheet for landmark details
class LandmarkDetailSheet extends StatelessWidget {
  final Landmark landmark;

  const LandmarkDetailSheet({
    super.key,
    required this.landmark,
  });

  void _editLandmark(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormView(landmark: landmark),
      ),
    );
  }

  void _deleteLandmark(BuildContext context) async {
    final controller = context.read<LandmarkController>();
    
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppTheme.glassBlue : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isDark 
                ? AppTheme.primaryNeon.withOpacity(0.3)
                : Colors.grey.withOpacity(0.3),
            width: 1,
          ),
        ),
        title: Text(
          'Delete Landmark',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Text(
          'Are you sure you want to delete "${landmark.title}"?',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Delete',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: const Color(0xFFFF4444),
                  ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      Navigator.pop(context);
      final success = await controller.deleteLandmark(landmark.id!);
      
      if (context.mounted) {
        if (success) {
          showSuccessSnackbar(
            context,
            message: 'Landmark deleted successfully',
          );
        } else {
          showErrorDialog(
            context,
            title: 'Error',
            message: controller.errorMessage ?? 'Failed to delete landmark',
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        gradient: isDark 
            ? AppTheme.navyGradient
            : const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Color(0xFFF5F5F5),
                ],
              ),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
        border: Border.all(
          color: isDark 
              ? AppTheme.primaryNeon.withOpacity(0.3)
              : Colors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark 
                      ? AppTheme.primaryNeon.withOpacity(0.3)
                      : Colors.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Image
            if (landmark.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: landmark.imageUrl!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 200,
                    color: AppTheme.glassBlue,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryNeon,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 200,
                    color: AppTheme.glassBlue,
                    child: const Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Colors.white38,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // Title
            Text(
              landmark.title,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 12),

            // Coordinates
            GlassCard(
              padding: const EdgeInsets.all(12),
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.my_location,
                        size: 20,
                        color: isDark ? AppTheme.primaryNeon : const Color(0xFF0066FF),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Latitude: ${landmark.latitude.toStringAsFixed(6)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 20,
                        color: isDark ? AppTheme.primaryNeon : const Color(0xFF0066FF),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Longitude: ${landmark.longitude.toStringAsFixed(6)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _editLandmark(context),
                    icon: const Icon(Icons.edit, size: 20),
                    label: const Text('Edit'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isDark ? AppTheme.primaryNeon : const Color(0xFF0066FF),
                      side: BorderSide(
                        color: isDark ? AppTheme.primaryNeon : const Color(0xFF0066FF),
                        width: 1,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _deleteLandmark(context),
                    icon: const Icon(Icons.delete, size: 20),
                    label: const Text('Delete'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFFF4444),
                      side: const BorderSide(
                        color: Color(0xFFFF4444),
                        width: 1,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            // Safe area padding
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}
