import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({
    super.key,
    this.indicatorType = Indicator.ballRotateChase,
    this.colors = const [Colors.white, Colors.black],
    this.size = 80,
  });

  final Indicator indicatorType;
  final List<Color> colors;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: LoadingIndicator(
          indicatorType: indicatorType,
          colors: colors,
          strokeWidth: 2,
        ),
      ),
    );
  }

  /// Show the loading dialog
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const LoadingDialog(),
    );
  }

  /// Hide the loading dialog if visible
  static void hide(BuildContext context) {
    if (Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}
