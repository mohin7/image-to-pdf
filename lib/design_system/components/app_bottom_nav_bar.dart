import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_typography.dart';

/// Tab item data for the custom bottom nav bar.
class AppTabItem {
  const AppTabItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
}

/// Professional frosted-glass bottom navigation bar with animated pill indicator.
///
/// Floats above content with a BackdropFilter blur and renders each tab item
/// with an animated selected-state pill. Provides haptic feedback on selection.
class AppBottomNavBar extends StatefulWidget {
  const AppBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<AppTabItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  State<AppBottomNavBar> createState() => _AppBottomNavBarState();
}

class _AppBottomNavBarState extends State<AppBottomNavBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _pillController;
  late Animation<double> _pillScale;

  @override
  void initState() {
    super.initState();
    _pillController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _pillScale = CurvedAnimation(
      parent: _pillController,
      curve: Curves.easeOutBack,
    );
    _pillController.forward();
  }

  @override
  void didUpdateWidget(AppBottomNavBar old) {
    super.didUpdateWidget(old);
    if (old.currentIndex != widget.currentIndex) {
      _pillController
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _pillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final accent = AppColors.accentRed.resolveFrom(context);
    final inactive = AppColors.labelTertiary.resolveFrom(context);

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.glassBarBackground.resolveFrom(context),
            border: Border(
              top: BorderSide(
                color: AppColors.separator
                    .resolveFrom(context)
                    .withValues(alpha: 0.5),
                width: 0.5,
              ),
            ),
          ),
          child: SizedBox(
            height: 56 + bottomPadding,
            child: Padding(
              padding: EdgeInsets.only(bottom: bottomPadding),
              child: Row(
                children: List.generate(widget.items.length, (i) {
                  final item = widget.items[i];
                  final isActive = i == widget.currentIndex;

                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        HapticFeedback.lightImpact();
                        widget.onTap(i);
                      },
                      child: SizedBox(
                        height: 56,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Icon with animated pill background
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              curve: Curves.easeInOut,
                              width: isActive ? 52 : 36,
                              height: 28,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? accent.withValues(alpha: 0.12)
                                    : CupertinoColors.transparent,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Center(
                                child: ScaleTransition(
                                  scale: isActive
                                      ? _pillScale
                                      : const AlwaysStoppedAnimation(1.0),
                                  child: Icon(
                                    isActive ? item.activeIcon : item.icon,
                                    size: 20,
                                    color: isActive ? accent : inactive,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 2),

                            // Label
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              style: AppTypography.caption2.copyWith(
                                color: isActive ? accent : inactive,
                                fontWeight: isActive
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                letterSpacing: isActive ? -0.1 : 0.07,
                              ),
                              child: Text(item.label),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
