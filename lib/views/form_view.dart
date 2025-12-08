import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/landmark_controller.dart';
import '../models/landmark.dart';
import '../theme/app_theme.dart';
import '../widgets/dialogs.dart';
import '../widgets/glass_card.dart';
import '../widgets/neon_button.dart';

/// Form View: Add or edit landmarks
class FormView extends StatefulWidget {
  final Landmark? landmark;

  const FormView({
    super.key,
    this.landmark,
  });

  @override
  State<FormView> createState() => _FormViewState();
}

class _FormViewState extends State<FormView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  
  File? _selectedImage;
  bool _isLoading = false;
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.landmark != null;
    
    if (_isEditMode) {
      _titleController.text = widget.landmark!.title;
      _latitudeController.text = widget.landmark!.latitude.toString();
      _longitudeController.text = widget.landmark!.longitude.toString();
    } else {
      _loadCurrentLocation();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentLocation() async {
    final controller = context.read<LandmarkController>();
    final location = await controller.getCurrentLocation();
    
    if (location != null && mounted) {
      _latitudeController.text = location['latitude']!.toStringAsFixed(6);
      _longitudeController.text = location['longitude']!.toStringAsFixed(6);
      
      showInfoSnackbar(
        context,
        message: 'Current location detected',
      );
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final controller = context.read<LandmarkController>();
    File? image;
    
    if (source == ImageSource.gallery) {
      image = await controller.pickImageFromGallery();
    } else {
      image = await controller.takePhoto();
    }
    
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          gradient: AppTheme.navyGradient,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24),
          ),
          border: Border.all(
            color: AppTheme.primaryNeon.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryNeon.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Select Image Source',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(
                    Icons.photo_library,
                    color: AppTheme.primaryNeon,
                  ),
                  title: Text(
                    'Gallery',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.camera_alt,
                    color: AppTheme.primaryNeon,
                  ),
                  title: Text(
                    'Camera',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_isEditMode && _selectedImage == null) {
      showErrorDialog(
        context,
        title: 'Image Required',
        message: 'Please select an image for the landmark',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final controller = context.read<LandmarkController>();
    final title = _titleController.text.trim();
    final latitude = double.parse(_latitudeController.text.trim());
    final longitude = double.parse(_longitudeController.text.trim());

    bool success;
    if (_isEditMode) {
      success = await controller.updateLandmark(
        id: widget.landmark!.id!,
        title: title,
        latitude: latitude,
        longitude: longitude,
        imageFile: _selectedImage,
      );
    } else {
      success = await controller.createLandmark(
        title: title,
        latitude: latitude,
        longitude: longitude,
        imageFile: _selectedImage!,
      );
    }

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      if (success) {
        showSuccessSnackbar(
          context,
          message: _isEditMode
              ? 'Landmark updated successfully'
              : 'Landmark created successfully',
        );
        Navigator.pop(context);
      } else {
        showErrorDialog(
          context,
          title: 'Error',
          message: controller.errorMessage ?? 
              (_isEditMode 
                  ? 'Failed to update landmark'
                  : 'Failed to create landmark'),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark 
              ? AppTheme.navyGradient
              : const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFF5F5F5),
                    Color(0xFFE8E8E8),
                  ],
                ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    if (_isEditMode)
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.arrow_back,
                          color: isDark ? AppTheme.primaryNeon : const Color(0xFF0066FF),
                        ),
                      ),
                    if (_isEditMode) const SizedBox(width: 8),
                    Text(
                      _isEditMode ? 'Edit Landmark' : 'New Landmark',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ],
                ),
              ),

              // Form
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Image picker
                        GlassCard(
                          onTap: _showImageSourceDialog,
                          child: _selectedImage != null
                              ? Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(
                                        _selectedImage!,
                                        height: 200,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: isDark ? AppTheme.glassBlue : Colors.white,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: isDark ? AppTheme.primaryNeon : const Color(0xFF0066FF),
                                            width: 1,
                                          ),
                                        ),
                                        child: IconButton(
                                          onPressed: _showImageSourceDialog,
                                          icon: Icon(
                                            Icons.edit,
                                            color: isDark ? AppTheme.primaryNeon : const Color(0xFF0066FF),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    Icon(
                                      Icons.add_photo_alternate,
                                      size: 80,
                                      color: isDark 
                                          ? AppTheme.primaryNeon.withOpacity(0.5)
                                          : const Color(0xFF0066FF).withOpacity(0.5),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Tap to select image',
                                      style: Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Image will be resized to 800x600',
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                        ),
                        const SizedBox(height: 20),

                        // Title field
                        TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            labelText: 'Title',
                            hintText: 'Enter landmark title',
                            prefixIcon: Icon(
                              Icons.title,
                              color: isDark ? AppTheme.primaryNeon : const Color(0xFF0066FF),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Title is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Latitude field
                        TextFormField(
                          controller: _latitudeController,
                          decoration: InputDecoration(
                            labelText: 'Latitude',
                            hintText: 'Enter latitude',
                            prefixIcon: Icon(
                              Icons.my_location,
                              color: isDark ? AppTheme.primaryNeon : const Color(0xFF0066FF),
                            ),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: true,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Latitude is required';
                            }
                            final lat = double.tryParse(value.trim());
                            if (lat == null) {
                              return 'Invalid latitude';
                            }
                            if (lat < -90 || lat > 90) {
                              return 'Latitude must be between -90 and 90';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Longitude field
                        TextFormField(
                          controller: _longitudeController,
                          decoration: InputDecoration(
                            labelText: 'Longitude',
                            hintText: 'Enter longitude',
                            prefixIcon: Icon(
                              Icons.location_on,
                              color: isDark ? AppTheme.primaryNeon : const Color(0xFF0066FF),
                            ),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: true,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Longitude is required';
                            }
                            final lon = double.tryParse(value.trim());
                            if (lon == null) {
                              return 'Invalid longitude';
                            }
                            if (lon < -180 || lon > 180) {
                              return 'Longitude must be between -180 and 180';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),

                        // Get current location button
                        if (!_isEditMode)
                          OutlinedButton.icon(
                            onPressed: _loadCurrentLocation,
                            icon: const Icon(
                              Icons.gps_fixed,
                              size: 20,
                            ),
                            label: const Text('Use Current Location'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: isDark ? AppTheme.accentNeon : const Color(0xFF03DAC6),
                              side: BorderSide(
                                color: isDark ? AppTheme.accentNeon : const Color(0xFF03DAC6),
                                width: 1,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        const SizedBox(height: 32),

                        // Submit button
                        NeonButton(
                          text: _isEditMode ? 'Update Landmark' : 'Create Landmark',
                          onPressed: _submitForm,
                          isLoading: _isLoading,
                          icon: _isEditMode ? Icons.save : Icons.add_location,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum ImageSource {
  gallery,
  camera,
}
