import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';

class ImageStorageHelper {
  // Save picked image to app's local storage (for now only , we will use firebase storage later)
  
  static Future<String?> saveImageToLocal(XFile pickedImage) async {
    try {
  
      final appDir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory(path.join(appDir.path, 'images'));
      
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }
      
  
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${path.basename(pickedImage.path)}';
      final savedPath = path.join(imagesDir.path, fileName);
      
   
      final savedFile = await File(pickedImage.path).copy(savedPath);
      
   
      return 'images/$fileName';
    } catch (e) {
      print('Error saving image: $e');
      return null;
    }
  }

 
  static Future<File?> getImageFile(String storedPath) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final fullPath = path.join(appDir.path, storedPath);
      final file = File(fullPath);
      
      if (await file.exists()) {
        return file;
      }
      return null;
    } catch (e) {
      print('Error getting image file: $e');
      return null;
    }
  }

 
  static Future<bool> deleteImage(String storedPath) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final fullPath = path.join(appDir.path, storedPath);
      final file = File(fullPath);
      
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      print('Error deleting image: $e');
      return false;
    }
  }

 
  static bool isAssetPath(String? path) {
    if (path == null) return false;
    return path.startsWith('lib/assets/');
  }

 
  static Widget getImageWidget(String? imagePath, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    if (imagePath == null || imagePath.isEmpty) {
      return Container(
        width: width,
        height: height,
        color: Colors.grey[300],
        child: const Icon(Icons.image, color: Colors.grey),
      );
    }

    if (isAssetPath(imagePath)) {
   
      return Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            color: Colors.grey[300],
            child: const Icon(Icons.broken_image, color: Colors.grey),
          );
        },
      );
    } else {
   
      return FutureBuilder<File?>(
        future: ImageStorageHelper.getImageFile(imagePath),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              width: width,
              height: height,
              color: Colors.grey[300],
              child: const CircularProgressIndicator(),
            );
          }
          
          if (snapshot.hasData && snapshot.data != null) {
            return Image.file(
              snapshot.data!,
              width: width,
              height: height,
              fit: fit,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: width,
                  height: height,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                );
              },
            );
          }
          
          return Container(
            width: width,
            height: height,
            color: Colors.grey[300],
            child: const Icon(Icons.image_not_supported, color: Colors.grey),
          );
        },
      );
    }
  }
}

