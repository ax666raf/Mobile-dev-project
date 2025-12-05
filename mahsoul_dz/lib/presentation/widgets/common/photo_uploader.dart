import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mahsoul_dz/l10n/app_localizations.dart';
import 'package:mahsoul_dz/presentation/themes/colors.dart';
import 'package:mahsoul_dz/core/utils/image_storage_helper.dart';

class GalleryPickerField extends StatefulWidget {
  final Function(String?)? onImageSaved;
  
  const GalleryPickerField({super.key, this.onImageSaved});

  @override
  State<GalleryPickerField> createState() => _GalleryPickerFieldState();
}

class _GalleryPickerFieldState extends State<GalleryPickerField> {
  final ImagePicker _picker = ImagePicker();
  XFile? _picked;
  String? _savedPath;
  bool _isSaving = false;

  Future<void> _pick() async {
    final file = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (!mounted || file == null) return;
    
    setState(() {
      _picked = file;
      _isSaving = true;
    });
    
    // Save image to local storage
    final savedPath = await ImageStorageHelper.saveImageToLocal(file);
    if (!mounted) return;
    
    setState(() {
      _savedPath = savedPath;
      _isSaving = false;
    });
    
    widget.onImageSaved?.call(savedPath);
  }

  void _clear() async {
    if (_savedPath != null) {
      await ImageStorageHelper.deleteImage(_savedPath!);
    }
    setState(() {
      _picked = null;
      _savedPath = null;
    });
    widget.onImageSaved?.call(null);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center, 
            children: [
            ElevatedButton(
              onPressed: _pick,
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
              child: Text(l10n.choosePhoto, 
            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold))),
            const SizedBox(width: 12),
            if (_picked != null) TextButton(onPressed: _clear, child: Text(l10n.remove)),
          ]),
          const SizedBox(height: 12),
          if (_picked == null)
            Container(
              height: 160, width: double.infinity, alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(l10n.noImageSelected),
            )
          else if (_isSaving)
            Container(
              height: 160, width: double.infinity, alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const CircularProgressIndicator(),
            )
          else
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(File(_picked!.path), height: 160, width: double.infinity, fit: BoxFit.cover),
            ),
        ],
      ),
    );
  }
}