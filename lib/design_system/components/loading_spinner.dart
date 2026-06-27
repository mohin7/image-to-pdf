import 'package:flutter/cupertino.dart';
import '../tokens/app_colors.dart';

enum SpinnerSize { small, medium, large }

class LoadingSpinner extends StatelessWidget {
  const LoadingSpinner({
    super.key,
    this.size = SpinnerSize.medium,
    this.color,
  });

  final SpinnerSize size;
  final Color? color;

  double get _radius => switch (size) {
        SpinnerSize.small => 8.0,
        SpinnerSize.medium => 12.0,
        SpinnerSize.large => 18.0,
      };

  @override
  Widget build(BuildContext context) {
    return CupertinoActivityIndicator(
      radius: _radius,
      color: color ?? AppColors.labelSecondary.resolveFrom(context),
    );
  }
}
