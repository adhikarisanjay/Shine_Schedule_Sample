import 'package:flutter/material.dart';
import 'package:shine_schedule/utils/colors.dart';

class CustomButton extends StatelessWidget {
  final String? label;
  final Widget? icon;
  final double? iconGap;
  final Function? onTap;
  final Color? color;
  final Color? textColor;
  final double? padding;
  final double? radius;
  final Widget? trailing;
  final double? textSize;
  final double? width;
  final double? height;
  final bool? active;
  final bool? disable;

  const CustomButton(
      {super.key,
      this.label,
      this.icon,
      this.iconGap,
      this.onTap,
      this.color,
      this.textColor,
      this.padding,
      this.radius,
      this.trailing,
      this.textSize,
      this.width,
      this.height,
      this.active,
      this.disable = false});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        width: width ?? 130,
        height: height ?? 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius ?? 10),
            // color: color ?? theme.primaryColorLight,
            color: ShineColors.appMainColor),
        padding: EdgeInsets.all(padding ?? (icon != null ? 8.0 : 8.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon ?? const SizedBox.shrink(),
            icon != null
                ? SizedBox(width: iconGap ?? 20)
                : const SizedBox.shrink(),
            active == true
                ? Transform.scale(
                    scale: 0.8,
                    child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        ShineColors.whiteColor,
                      ),
                    ),
                  )
                : Text(
                    label ?? "Continue",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: textColor ?? ShineColors.whiteColor,
                        fontSize: 16),
                  ),
            trailing != null ? const Spacer() : const SizedBox.shrink(),
            trailing ?? const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
