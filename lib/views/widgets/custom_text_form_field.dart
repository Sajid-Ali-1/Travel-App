import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel_app/utils/app_theme.dart';

// ignore: must_be_immutable
class CustomTextFormField extends StatefulWidget {
  CustomTextFormField({
    super.key,
    required this.controller,
    required this.validator,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.keyboardType,
    this.isPassword = false,
    this.fillColor,
    this.minLines,
    this.textCapitalization,
    this.textInputAction,
    this.onChanged,
  });

  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final bool isPassword;
  bool obscureText = true;
  final Color? fillColor;
  final int? minLines;
  final TextCapitalization? textCapitalization;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;
  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    if (!widget.isPassword) {
      widget.obscureText = false;
    }
    var inputBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Color(0x00000000)),
      borderRadius: BorderRadius.circular(5.0.r),
    );
    var errorBorder = OutlineInputBorder(
      borderSide: BorderSide(color: AppTheme.of(context).error),
      borderRadius: BorderRadius.circular(5.0.r),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style: AppTheme.of(
              context,
            ).bodySmall.copyWith(color: AppTheme.of(context).primaryText),
          ),
          SizedBox(height: 5.h),
        ],
        TextFormField(
          onChanged: widget.onChanged,
          textInputAction: widget.textInputAction ?? TextInputAction.next,
          textCapitalization:
              widget.textCapitalization ?? TextCapitalization.none,
          maxLines: widget.isPassword ? 1 : null,
          minLines: widget.isPassword ? null : widget.minLines ?? 1,
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
          decoration: InputDecoration(
            isDense: true,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: widget.obscureText
                        ? Icon(Icons.visibility_off, color: Color(0xFF565D6D))
                        : Icon(
                            Icons.visibility,
                            color: AppTheme.of(context).primaryText,
                          ),
                    onPressed: () => setState(() {
                      widget.obscureText = !widget.obscureText;
                    }),
                  )
                : null,
            // hintText: widget.labelText,
            // hintStyle: Theme.of(context).textTheme.titleSmall,
            // hintText: widget.hintText,
            // hintStyle: Theme.of(context).textTheme.labelLarge,
            border: inputBorder,
            focusedBorder: inputBorder,
            enabledBorder: inputBorder,
            errorBorder: errorBorder,
            focusedErrorBorder: errorBorder,
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon, color: Color(0xFF565D6D))
                : null,

            filled: true,
            fillColor: widget.fillColor ?? AppTheme.of(context).textFieldColor,
          ),
          cursorColor: AppTheme.of(context).accent1,
          validator: widget.validator,
          controller: widget.controller,
        ),
      ],
    );
  }
}
