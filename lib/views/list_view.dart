import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/landmark_controller.dart';
import '../models/landmark.dart';
import '../theme/app_theme.dart';
import '../widgets/dialogs.dart';
import '../widgets/glass_card.dart';
import '../widgets/neon_loading.dart';
import 'form_view.dart';
import 'landmark_detail_sheet.dart';

/// List View: Shows landmarks as scrollable cards
class LandmarkListView extends StatefulWidget {
  const LandmarkListView({super.key});

  @override
  State<LandmarkListView> createState() => _LandmarkListViewState();
}

class _LandmarkListViewState extends State<LandmarkListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LandmarkController>().loadLandmarks();
    });
  }

  void _showLandmarkDetails(Landmark landmark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => LandmarkDetailSheet(landmark: landmark),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LandmarkController>(
      builder: (context, controller, _) {
        if (controller.isLoading && controller.landmarks.isEmpty) {
          return const NeonLoadingIndicator(
            message: 'Loading landmarks...',
          );
        }

        if (controller.landmarks.isEmpty) {
          return _buildEmptyState(context);
        }

        return RefreshIndicator(
          onRefresh: () => controller.loadLandmarks(forceRefresh: true),
          color: AppTheme.primaryNeon,
          backgroundColor: AppTheme.glassBlue,
          child: Column(
            children: [
              // Header with count
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${controller.landmarks.length} Landmarks',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    if (!controller.isOnline)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.glassBlue.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.orange,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.cloud_off,
                              size: 14,
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Offline',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              // List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.landmarks.length,
                  itemBuilder: (context, index) {
                    final landmark = controller.landmarks[index];
                    return Dismissible(
                      key: Key(landmark.id.toString()),
                      background: _buildSwipeBackground(
                        context,
                        alignment: Alignment.centerLeft,
                        icon: Icons.edit,
                        color: AppTheme.primaryNeon,
                      ),
                      secondaryBackground: _buildSwipeBackground(
                        context,
                        alignment: Alignment.centerRight,
                        icon: Icons.delete,
                        color: const Color(0xFFFF4444),
                      ),
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.startToEnd) {
                          // Edit
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FormView(
                                landmark: landmark,
                              ),
                            ),
                          );
                          return false;
                        } else {
                          // Delete
                          return await _confirmDelete(context, landmark);
                        }
                      },
                      child: LandmarkCard(
                        landmark: landmark,
                        onTap: () => _showLandmarkDetails(landmark),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off,
            size: 80,
            color: AppTheme.primaryNeon.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No landmarks found',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first landmark to get started',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildSwipeBackground(
    BuildContext context, {
    required Alignment alignment,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Icon(
        icon,
        color: color,
        size: 32,
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context, Landmark landmark) async {
    final confirmed = await showDialog<bool>(
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
      final controller = context.read<LandmarkController>();
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
      return success;
    }

    return false;
  }
}

/// Landmark Card Widget
class LandmarkCard extends StatelessWidget {
  final Landmark landmark;
  final VoidCallback onTap;

  const LandmarkCard({
    super.key,
    required this.landmark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: landmark.imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: landmark.imageUrl!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 80,
                      height: 80,
                      color: AppTheme.glassBlue,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.primaryNeon,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 80,
                      height: 80,
                      color: AppTheme.glassBlue,
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.white38,
                      ),
                    ),
                  )
                : Container(
                    width: 80,
                    height: 80,
                    color: AppTheme.glassBlue,
                    child: const Icon(
                      Icons.image,
                      color: Colors.white38,
                    ),
                  ),
          ),
          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  landmark.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 14,
                      color: AppTheme.primaryNeon,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${landmark.latitude.toStringAsFixed(4)}, ${landmark.longitude.toStringAsFixed(4)}',
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Arrow icon
          const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: AppTheme.primaryNeon,
          ),
        ],
      ),
    );
  }
}
