import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class FileService {
  Future<String?> pickAndReadTextFile() async {
    try {
      if (!kIsWeb) {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['txt'],
          withData: true, // Load file bytes in memory
        );

        if (result != null) {
          if (result.files.single.bytes != null) {
            // Use bytes directly when available
            return String.fromCharCodes(result.files.single.bytes!);
          } else if (result.files.single.path != null) {
            // Fallback to path reading
            File file = File(result.files.single.path!);
            return await file.readAsString();
          }
        }
      } else {
        // Web platform handling
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['txt'],
          withData: true,
        );
        
        if (result != null && result.files.single.bytes != null) {
          return String.fromCharCodes(result.files.single.bytes!);
        }
      }
    } catch (e) {
      throw Exception('Error reading file: $e');
    }
    return null;
  }
}
