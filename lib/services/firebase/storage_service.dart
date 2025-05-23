import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

class StorageService {
  bool useMock = true;
  
  // Mock storage for files
  final Map<String, List<int>> _mockStorage = {};

  Future<String> uploadFile(File file, String destination) async {
    if (useMock) {
      await Future.delayed(const Duration(seconds: 2));
      
      // Read file bytes
      final bytes = await file.readAsBytes();
      
      // Generate a unique path
      final fileName = path.basename(file.path);
      final uniquePath = 'mock_storage/$destination/$fileName';
      
      // Store in mock storage
      _mockStorage[uniquePath] = bytes;
      
      return uniquePath;
    }
    // TODO: Implement real Firebase Storage call
    throw UnimplementedError('Real Firebase Storage implementation not yet available');
  }

  Future<void> deleteFile(String filePath) async {
    if (useMock) {
      await Future.delayed(const Duration(seconds: 1));
      _mockStorage.remove(filePath);
      return;
    }
    // TODO: Implement real Firebase Storage call
    throw UnimplementedError('Real Firebase Storage implementation not yet available');
  }

  Future<String> getDownloadUrl(String filePath) async {
    if (useMock) {
      await Future.delayed(const Duration(seconds: 1));
      
      if (_mockStorage.containsKey(filePath)) {
        // Return a mock URL
        return 'https://mock-storage.example.com/$filePath';
      }
      
      throw Exception('File not found');
    }
    // TODO: Implement real Firebase Storage call
    throw UnimplementedError('Real Firebase Storage implementation not yet available');
  }

  Future<void> uploadProfileImage(File imageFile, String userId) async {
    if (useMock) {
      await Future.delayed(const Duration(seconds: 2));
      
      final destination = 'profile_images/$userId.jpg';
      await uploadFile(imageFile, destination);
      return;
    }
    // TODO: Implement real Firebase Storage call
    throw UnimplementedError('Real Firebase Storage implementation not yet available');
  }

  Future<void> uploadConversationAudio(File audioFile, String conversationId) async {
    if (useMock) {
      await Future.delayed(const Duration(seconds: 2));
      
      final destination = 'conversation_audio/$conversationId.mp3';
      await uploadFile(audioFile, destination);
      return;
    }
    // TODO: Implement real Firebase Storage call
    throw UnimplementedError('Real Firebase Storage implementation not yet available');
  }

  Future<void> clearMockStorage() async {
    if (useMock) {
      _mockStorage.clear();
      return;
    }
    // TODO: Implement real Firebase Storage call
    throw UnimplementedError('Real Firebase Storage implementation not yet available');
  }
} 