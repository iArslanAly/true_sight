import 'package:flutter/material.dart';
import 'package:true_sight/core/constants/colors.dart';
import 'package:true_sight/core/constants/sizes.dart';

class XFormDivider extends StatelessWidget {
  const XFormDivider({super.key, this.text});

  final String? text;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Divider(
            thickness: XSizes.dividerHeight,
            endIndent: XSizes.defaultSpace,
            indent: XSizes.d1,
            color: XColors.secondary,
          ),
        ),
        Text(
          text ?? '',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: XColors.secondary),
        ),
        Flexible(
          child: Divider(
            thickness: XSizes.dividerHeight,
            endIndent: XSizes.d1,
            indent: XSizes.defaultSpace,
            color: XColors.secondary,
          ),
        ),
      ],
    );
  }
}
