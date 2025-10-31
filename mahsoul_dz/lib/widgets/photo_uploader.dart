import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mahsoul_dz/themes/colors.dart';

class GalleryPickerField extends StatefulWidget {
  const GalleryPickerField({super.key});

  @override
  State<GalleryPickerField> createState() => _GalleryPickerFieldState();
}

class _GalleryPickerFieldState extends State<GalleryPickerField> {
  final ImagePicker _picker = ImagePicker();
  XFile? _picked;

  Future<void> _pick() async {
    final file = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (!mounted) return;
    setState(() => _picked = file);
  }

  void _clear() => setState(() => _picked = null);

  @override
  Widget build(BuildContext context) {
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
              child: const Text('Choose Photo', 
            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),)),
            const SizedBox(width: 12),
            if (_picked != null) TextButton(onPressed: _clear, child: const Text('Remove')),
          ]),
          const SizedBox(height: 12),
          if (_picked == null)
            Container(
              height: 160, width: double.infinity, alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('No image selected'),
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