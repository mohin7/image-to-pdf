import 'package:flutter/cupertino.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_typography.dart';

/// Flat white navigation bar — replaces AppBarGlass for PDFlex design.
/// Respects Dynamic Island via MediaQuery.padding.top automatically
/// through CupertinoNavigationBar's built-in safe area handling.
class FlatNavBar extends StatelessWidget implements ObstructingPreferredSizeWidget {
  const FlatNavBar({
    super.key,
    this.title,
    this.leading,
    this.trailing,
    this.previousPageTitle,
    this.border = const Border(
      bottom: BorderSide(color: Color(0x00000000), width: 0),
    ),
  });

  final String? title;
  final Widget? leading;
  final Widget? trailing;
  final String? previousPageTitle;
  final Border? border;

  @override
  Widget build(BuildContext context) {
    return CupertinoNavigationBar(
      backgroundColor: AppColors.tabBarBackground.resolveFrom(context),
      border: border,
      previousPageTitle: previousPageTitle,
      leading: leading,
      middle: title != null
          ? Text(
              title!,
              style: AppTypography.headline.copyWith(
                color: AppColors.labelPrimary.resolveFrom(context),
              ),
            )
          : null,
      trailing: trailing,
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kMinInteractiveDimensionCupertino);

  @override
  bool shouldFullyObstruct(BuildContext context) => true;
}
