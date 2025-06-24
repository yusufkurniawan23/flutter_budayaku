import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/seniman.dart';

class SenimanImageWidget extends StatelessWidget {
  final Seniman seniman;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final bool showLoadingProgress;
  final bool isDetailView;

  const SenimanImageWidget({
    super.key,
    required this.seniman,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
    this.showLoadingProgress = true,
    this.isDetailView = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!seniman.hasPhoto) {
      return _buildPlaceholder();
    }

    final imageUrl = seniman.getFullImageUrl()!;
    print('🖼️ SenimanImageWidget loading: $imageUrl');

    Widget imageWidget = Image.network(
      imageUrl,
      fit: fit,
      width: width,
      height: height,
      headers: _getImageHeaders(),
      loadingBuilder: showLoadingProgress ? _buildLoadingWidget : null,
      errorBuilder: (context, error, stackTrace) {
        print('❌ SenimanImageWidget error: $imageUrl');
        print('❌ Error: $error');
        
        if (imageUrl.contains('127.0.0.1') && kIsWeb) {
          final correctedUrl = imageUrl.replaceAll('127.0.0.1', 'localhost');
          print('🔄 Trying corrected URL: $correctedUrl');
          
          return Image.network(
            correctedUrl,
            fit: fit,
            width: width,
            height: height,
            headers: _getImageHeaders(),
            loadingBuilder: showLoadingProgress ? _buildLoadingWidget : null,
            errorBuilder: (context, error2, stackTrace2) {
              print('❌ Corrected URL also failed: $correctedUrl');
              return _buildPlaceholder();
            },
          );
        }
        
        return _buildPlaceholder();
      },
    );

    if (borderRadius != null) {
      imageWidget = ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Map<String, String> _getImageHeaders() {
    if (kIsWeb) {
      return {
        'Accept': 'image/*',
        'User-Agent': 'BudayakuApp/1.0',
      };
    } else {
      return {
        'Accept': 'image/*',
        'User-Agent': 'BudayakuApp/1.0',
        'Connection': 'keep-alive',
      };
    }
  }

  Widget _buildLoadingWidget(BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
    if (loadingProgress == null) {
      print('✅ Seniman image loaded successfully: ${seniman.getFullImageUrl()}');
      return child;
    }

    final progress = loadingProgress.expectedTotalBytes != null
        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
        : null;

    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              value: progress,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.brown[700]!),
              strokeWidth: 2,
            ),
            if (showLoadingProgress) ...[
              const SizedBox(height: 8),
              Text(
                progress != null 
                    ? 'Memuat ${(progress * 100).toInt()}%'
                    : 'Memuat foto...',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    Widget placeholderWidget = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.brown[200]!, Colors.brown[400]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: isDetailView 
          ? _buildDetailPlaceholder()
          : _buildListPlaceholder(),
    );

    if (borderRadius != null) {
      placeholderWidget = ClipRRect(
        borderRadius: borderRadius!,
        child: placeholderWidget,
      );
    }

    return placeholderWidget;
  }

  Widget _buildDetailPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.person_outline,
            size: 80,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Foto Seniman\nSegera Hadir',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Circle with initials
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.brown[600]!,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              seniman.nameInitials,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.brown[700],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Label
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'Foto Seniman',
            style: TextStyle(
              fontSize: 10,
              color: Colors.brown[700],
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}