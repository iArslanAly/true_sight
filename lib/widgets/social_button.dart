import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:true_sight/core/constants/colors.dart';
import 'package:true_sight/core/constants/sizes.dart';

class SocialButton extends StatelessWidget {
  const SocialButton({
    super.key,
    required this.imagePath,
    required this.buttonText,
    required this.onPressed,
  });

  final String imagePath;
  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: XSizes.d55,
        decoration: BoxDecoration(
          color: XColors.secondary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(width: 1, color: XColors.secondary),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                imagePath,
                width: XSizes.d34,
                height: XSizes.d34,

                fit: BoxFit.contain,
              ),
              const SizedBox(width: XSizes.spaceBtwItems),
              Text(
                buttonText,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: XColors.white,
                  fontSize: XSizes.fontSizeMd,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
