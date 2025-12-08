import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../controllers/landmark_controller.dart';
import '../models/landmark.dart';
import '../theme/app_theme.dart';
import '../widgets/neon_loading.dart';
import 'landmark_detail_sheet.dart';

/// Map View: Shows landmarks on OpenStreetMap
class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final MapController _mapController = MapController();
  static const LatLng bangladeshCenter = LatLng(23.6850, 90.3563);
  Landmark? _selectedLandmark;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LandmarkController>().loadLandmarks();
    });
  }

  void _showLandmarkDetails(Landmark landmark) {
    setState(() {
      _selectedLandmark = landmark;
    });
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => LandmarkDetailSheet(landmark: landmark),
    );
  }

  List<Marker> _buildMarkers(List<Landmark> landmarks) {
    return landmarks.map((landmark) {
      return Marker(
        point: LatLng(landmark.latitude, landmark.longitude),
        width: 40,
        height: 40,
        child: GestureDetector(
          onTap: () => _showLandmarkDetails(landmark),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.primaryNeon,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryNeon.withOpacity(0.6),
                  blurRadius: 15,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: const Icon(
              Icons.location_on,
              color: Colors.black,
              size: 28,
            ),
          ),
        ),
      );
    }).toList();
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

        return Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: bangladeshCenter,
                initialZoom: 7.0,
                minZoom: 5.0,
                maxZoom: 18.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/{z}/{x}/{y}{r}.png',
                  userAgentPackageName: 'com.shakil.map.natok_map',
                  maxZoom: 20,
                ),
                MarkerLayer(
                  markers: _buildMarkers(controller.landmarks),
                ),
              ],
            ),
            
            // Online/Offline indicator
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.glassBlue.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: controller.isOnline
                        ? AppTheme.accentNeon
                        : Colors.orange,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      controller.isOnline
                          ? Icons.cloud_done
                          : Icons.cloud_off,
                      size: 16,
                      color: controller.isOnline
                          ? AppTheme.accentNeon
                          : Colors.orange,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      controller.isOnline ? 'Online' : 'Offline',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),

            // Refresh button
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton(
                onPressed: () {
                  controller.loadLandmarks(forceRefresh: true);
                },
                backgroundColor: AppTheme.primaryNeon,
                child: const Icon(
                  Icons.refresh,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
