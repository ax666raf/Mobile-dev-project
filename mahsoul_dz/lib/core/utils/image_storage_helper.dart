import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:mahsoul_dz/core/api/api_client.dart';
import 'package:mahsoul_dz/core/api/api_endpoints.dart';
import 'package:mahsoul_dz/core/config/api_config.dart';
import 'package:mahsoul_dz/core/errors/api_exception.dart';

class ImageStorageHelper {
  // Save picked image to app's local storage (for now only , we will use firebase storage later)

  static Future<String?> saveImageToLocal(XFile pickedImage) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory(path.join(appDir.path, 'images'));

      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${path.basename(pickedImage.path)}';
      final savedPath = path.join(imagesDir.path, fileName);

      await File(pickedImage.path).copy(savedPath);

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

  /// Check if path is a server URL
  static bool isServerPath(String? imagePath) {
    if (imagePath == null) return false;
    return imagePath.startsWith('uploads/') ||
        imagePath.startsWith('http://') ||
        imagePath.startsWith('https://');
  }

  /// Upload image to server
  /// Returns the server path if successful, null otherwise
  static Future<String?> uploadImageToServer(
    File imageFile, {
    String type = 'product', // 'product' or 'profile'
  }) async {
    try {
      final apiClient = ApiClient();

      final response = await apiClient.uploadFile(
        ApiEndpoints.uploadImage,
        file: imageFile,
        fieldName: 'file',
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final imagePath = data['image_path'] as String?;
        print('[OK] Image uploaded successfully: $imagePath');
        return imagePath;
      } else {
        print('[ERROR] Upload failed: ${response.statusCode}');
        return null;
      }
    } on ApiException catch (e) {
      print('[ERROR] Upload error: ${e.message}');
      return null;
    } catch (e) {
      print('[ERROR] Unexpected upload error: $e');
      return null;
    }
  }

  /// Get full URL for server image
  static String getImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return '';

    // If already a full URL, return as is
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return imagePath;
    }

    // If it's a server path (uploads/...), construct full URL
    if (imagePath.startsWith('uploads/')) {
      final baseUrl = ApiConfig.baseUrl.replaceAll('/api', '');
      return '$baseUrl/$imagePath';
    }

    // Otherwise return as is (might be asset path or local path)
    return imagePath;
  }

  static Widget getImageWidget(
    String? imagePath, {
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
      // Asset image
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
    } else if (isServerPath(imagePath)) {
      // Server image - load from URL
      final imageUrl = getImageUrl(imagePath);
      return Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: width,
            height: height,
            color: Colors.grey[300],
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
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
      // Local file image
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
