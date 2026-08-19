import 'package:flutter/material.dart';
import 'package:sahaara/app/core/constants/app_colors.dart';

class ChatScreen extends StatelessWidget {
  final String? chatId;
  final String? partnerId;
  final String? partnerName;
  final String? partnerImage;
  final double? keyboardInset;

  const ChatScreen({
    super.key,
    this.chatId,
    this.partnerId,
    this.partnerName,
    this.partnerImage,
    this.keyboardInset,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(partnerName ?? 'Caregiver Chat'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text('Chat room with ${partnerName ?? "care partner"}.'),
      ),
    );
  }
}
