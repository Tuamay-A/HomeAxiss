
// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, unused_element_parameter, unused_field

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../shared/theme/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class FileType {
  static const FileType any = FileType._('any');
  static const FileType custom = FileType._('custom');

  final String _value;
  const FileType._(this._value);
}

class _PlatformFile {
  final String? path;

  const _PlatformFile({this.path});
}

class FilePickerResult {
  final List<_PlatformFile> files;

  const FilePickerResult(this.files);
}

class _FilePickerPlatform {
  Future<FilePickerResult?> pickFiles({
    FileType type = FileType.any,
    List<String>? allowedExtensions,
  }) async {
    return null;
  }
}

class FilePicker {
  static final _FilePickerPlatform platform = _FilePickerPlatform();
}

class ChatAttachmentPicker extends StatelessWidget {
  final Function(File?) onImageSelected;
  final Function(File?) onFileSelected;

  const ChatAttachmentPicker({
    super.key,
    required this.onImageSelected,
    required this.onFileSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondaryBlack,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.textDark,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildAttachmentOption(
                icon: Icons.camera_alt,
                label: 'Camera',
                onTap: () => _pickImage(context, ImageSource.camera),
              ),
              _buildAttachmentOption(
                icon: Icons.photo_library,
                label: 'Gallery',
                onTap: () => _pickImage(context, ImageSource.gallery),
              ),
              _buildAttachmentOption(
                icon: Icons.attach_file,
                label: 'File',
                onTap: () => _pickFile(context),
              ),
              _buildAttachmentOption(
                icon: Icons.close,
                label: 'Cancel',
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppColors.primaryGold,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: AppColors.textGray,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      Navigator.pop(context);
      onImageSelected(File(pickedFile.path));
    }
  }

  Future<void> _pickFile(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.isNotEmpty) {
      final file = File(result.files.single.path!);
      Navigator.pop(context);
      onFileSelected(file);
    }
  }
}