import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pgagi_assign/constants/app_constants.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isOutlined) {
      return SizedBox(
        width: width?.w,
        height: height?.h ?? 48.h,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: textColor ?? theme.colorScheme.primary,
            padding: EdgeInsets.all(0),
          ),
          child:
              isLoading
                  ? SizedBox(
                    height: 20.sp,
                    width: 20.sp,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        textColor ?? theme.colorScheme.primary,
                      ),
                    ),
                  )
                  : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        icon!,
                        SizedBox(width: 8.w),
                      ],
                      Text(text),
                    ],
                  ),
        ),
      );
    }

    return SizedBox(
      width: width?.w,
      height: height?.h ?? 48.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
           padding: EdgeInsets.all(0),
        ),
        child:
            isLoading
                ? SizedBox(
                  height: 20.sp,
                  width: 20.sp,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      icon!,
                      SizedBox(width: 8.w),
                    ],
                    Text(text),
                  ],
                ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool enabled;
  final VoidCallback? onTap;
  final Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.keyboardType,
    this.obscureText = false,
    this.enabled = true,
    this.onTap,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.subtitle2.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          validator: validator,
          maxLines: maxLines,
          keyboardType: keyboardType,
          obscureText: obscureText,
          enabled: enabled,
          onTap: onTap,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(AppConstants.largeSpacing),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(
                    AppConstants.mediumRadius,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    if (message != null) ...[
                      const SizedBox(height: AppConstants.mediumSpacing),
                      Text(
                        message!,
                        style: AppTextStyles.body1,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ).animate().scale(duration: 300.ms),
            ),
          ),
      ],
    );
  }
}

class EmptyState extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onAction;
  final String? actionText;

  const EmptyState({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    this.onAction,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80.sp,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ).animate().scale(duration: 600.ms),
            SizedBox(height: 24.h),
            Text(
              title,
              style: AppTextStyles.heading2.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 24.sp,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 200.ms),
            SizedBox(height: 16.h),
            Text(
              message,
              style: AppTextStyles.body1.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                fontSize: 16.sp,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 400.ms),
            if (onAction != null && actionText != null) ...[
              SizedBox(height: 32.h),
              CustomButton(
                text: actionText!,
                onPressed: onAction,
                icon: Icon(Icons.add, size: 20.sp),
              ).animate().slideY(delay: 600.ms, begin: 0.3),
            ],
          ],
        ),
      ),
    );
  }
}
