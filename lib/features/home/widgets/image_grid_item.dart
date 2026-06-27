import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../design_system/tokens/app_colors.dart';
import '../../../design_system/tokens/app_radius.dart';
import '../../../design_system/tokens/app_typography.dart';
import '../../../shared/models/image_item.dart';

class ImageGridItem extends StatelessWidget {
  const ImageGridItem({
    super.key,
    required this.item,
    required this.onRemove,
    required this.index,
    this.isDragging = false,
  });

  final ImageItem item;
  final VoidCallback onRemove;
  final int index;
  final bool isDragging;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isDragging ? 1.05 : 1.0,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      child: AnimatedOpacity(
        opacity: isDragging ? 0.85 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: ClipRRect(
          borderRadius: AppRadius.radiusMD,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.file(
                File(item.path),
                fit: BoxFit.cover,
                cacheWidth: 400,
                errorBuilder: (_, __, ___) => ColoredBox(
                  color: AppColors.surfaceTertiary.resolveFrom(context),
                  child: Icon(
                    CupertinoIcons.photo,
                    color: AppColors.labelTertiary.resolveFrom(context),
                    size: 32,
                  ),
                ),
              ),

              // Remove button — 44×44 invisible touch area for HIG compliance
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onRemove();
                  },
                  child: SizedBox(
                    width: 44,
                    height: 44,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: AppColors.accentRed.resolveFrom(context),
                            shape: BoxShape.circle,
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x44000000),
                                blurRadius: 4,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: const SizedBox(
                            width: 22,
                            height: 22,
                            child: Icon(
                              CupertinoIcons.xmark,
                              color: CupertinoColors.white,
                              size: 11,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Order number badge — bottom-left dark pill
              Positioned(
                bottom: 6,
                left: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: CupertinoColors.black.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${index + 1}',
                    style: AppTypography.caption2Medium.copyWith(
                      color: CupertinoColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
  }
}
