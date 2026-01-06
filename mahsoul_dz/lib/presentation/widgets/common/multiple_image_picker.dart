import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mahsoul_dz/l10n/app_localizations.dart';
import 'package:mahsoul_dz/core/utils/image_storage_helper.dart';

class MultipleImagePicker extends StatefulWidget {
  final List<String>? initialImages; // List of image paths (server paths)
  final Function(List<String>)? onImagesChanged; // Callback with list of image paths
  final int maxImages;

  const MultipleImagePicker({
    super.key,
    this.initialImages,
    this.onImagesChanged,
    this.maxImages = 10,
  });

  @override
  State<MultipleImagePicker> createState() => _MultipleImagePickerState();
}

class _MultipleImagePickerState extends State<MultipleImagePicker> {
  final ImagePicker _picker = ImagePicker();
  List<String> _imagePaths = []; // Server paths
  List<XFile?> _localFiles = []; // Local files for preview
  Map<int, bool> _uploadingStates = {}; // Track which images are uploading

  @override
  void initState() {
    super.initState();
    if (widget.initialImages != null) {
      _imagePaths = List<String>.from(widget.initialImages!);
      // Initialize local files as null (we'll load from server paths)
      // Use growable list instead of fixed-length
      _localFiles = List<XFile?>.generate(_imagePaths.length, (index) => null, growable: true);
    }
  }

  Future<void> _pickImages() async {
    if (_imagePaths.length >= widget.maxImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Maximum ${widget.maxImages} images allowed'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final List<XFile>? pickedFiles = await _picker.pickMultiImage(
      imageQuality: 85,
    );

    if (pickedFiles == null || pickedFiles.isEmpty) return;

    // Limit to maxImages
    final remainingSlots = widget.maxImages - _imagePaths.length;
    final filesToProcess = pickedFiles.take(remainingSlots).toList();

    for (var file in filesToProcess) {
      final index = _imagePaths.length;
      setState(() {
        _localFiles.add(file);
        _uploadingStates[index] = true;
      });

      // Upload image to server
      final imageFile = File(file.path);
      final serverPath = await ImageStorageHelper.uploadImageToServer(
        imageFile,
        type: 'product',
      );

      if (!mounted) return;

      setState(() {
        _uploadingStates[index] = false;
        if (serverPath != null) {
          _imagePaths.add(serverPath);
          _localFiles[index] = file; // Keep local file for preview
        } else {
          _localFiles.removeAt(index);
          _uploadingStates.remove(index);
        }
      });

      // Notify parent
      widget.onImagesChanged?.call(_imagePaths);
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imagePaths.removeAt(index);
      _localFiles.removeAt(index);
      _uploadingStates.remove(index);
      // Reindex uploading states
      final newStates = <int, bool>{};
      _uploadingStates.forEach((key, value) {
        if (key > index) {
          newStates[key - 1] = value;
        } else if (key < index) {
          newStates[key] = value;
        }
      });
      _uploadingStates = newStates;
    });
    widget.onImagesChanged?.call(_imagePaths);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Padding(
          padding: const EdgeInsets.only(left: 10.0, bottom: 8.0),
          child: Text(
            '${l10n.productImages} (${_imagePaths.length}/${widget.maxImages})',
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
        ),
        
        // Add Images Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: ElevatedButton.icon(
            onPressed: _imagePaths.length >= widget.maxImages ? null : _pickImages,
            icon: const Icon(Icons.add_photo_alternate, size: 20),
            label: Text(
              _imagePaths.isEmpty ? l10n.addImages : l10n.addMoreImages,
              style: const TextStyle(fontSize: 14),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Image Grid
        if (_imagePaths.isEmpty && _localFiles.isEmpty)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                l10n.noImageSelected,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List.generate(
                _imagePaths.length + _localFiles.where((f) => f != null && !_imagePaths.contains(f?.path)).length,
                (index) {
                  final isUploading = _uploadingStates[index] ?? false;
                  
                  if (index < _imagePaths.length) {
                    // Display uploaded image (from server)
                    final imagePath = _imagePaths[index];
                    final isPrimary = index == 0;
                    
                    return Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isPrimary ? Colors.green : Colors.grey.shade300,
                              width: isPrimary ? 2 : 1,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: ImageStorageHelper.getImageWidget(
                              imagePath,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        if (isPrimary)
                          Positioned(
                            top: 4,
                            left: 4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                l10n.cover,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => _removeImage(index),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    // Display local file being uploaded
                    final localIndex = index - _imagePaths.length;
                    final localFile = _localFiles[localIndex];
                    
                    if (localFile == null) return const SizedBox.shrink();
                    
                    return Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: isUploading
                                ? Container(
                                    color: Colors.grey[200],
                                    child: const Center(
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                  )
                                : Image.file(
                                    File(localFile.path),
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        if (!isUploading)
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _localFiles.removeAt(localIndex);
                                  _uploadingStates.remove(index);
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
      ],
    );
  }
}

