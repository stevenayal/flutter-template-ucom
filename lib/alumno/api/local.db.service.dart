import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class LocalDBService {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/db.json');
  }

  Future<List<Map<String, dynamic>>> getAll(String collection) async {
    try {
      final file = await _localFile;
      if (!await file.exists()) {
        await file.writeAsString('{}');
      }
      final contents = await file.readAsString();
      final data = json.decode(contents) as Map<String, dynamic>;
      return (data[collection] as List?)?.cast<Map<String, dynamic>>() ?? [];
    } catch (e) {
      return [];
    }
  }

  Future<void> saveAll(String collection, List<Map<String, dynamic>> items) async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      final data = json.decode(contents) as Map<String, dynamic>;
      data[collection] = items;
      await file.writeAsString(json.encode(data));
    } catch (e) {
      print('Error saving data: $e');
    }
  }
} 