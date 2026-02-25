import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel_app/utils/app_theme.dart';

class CustomDropdown<T> extends StatefulWidget {
  const CustomDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    required this.value,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.validator,
    this.fillColor,
    this.displayStringForOption,
  });

  final List<T> items;
  final void Function(T?) onChanged;
  final T? value;
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final String? Function(T?)? validator;
  final Color? fillColor;
  final String Function(T)? displayStringForOption;

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  @override
  Widget build(BuildContext context) {
    var inputBorder = OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0x00000000)),
      borderRadius: BorderRadius.circular(10.0.r),
    );
    var errorBorder = OutlineInputBorder(
      borderSide: BorderSide(color: AppTheme.of(context).error),
      borderRadius: BorderRadius.circular(10.0.r),
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
        DropdownButtonFormField<T>(
          value: widget.value,
          items: widget.items
              .map(
                (e) => DropdownMenuItem<T>(
                  value: e,
                  child: Text(
                    widget.displayStringForOption?.call(e) ?? e.toString(),
                  ),
                ),
              )
              .toList(),
          onChanged: widget.onChanged,
          validator: widget.validator,
          decoration: InputDecoration(
            isDense: true,
            hintText: widget.hintText,
            border: inputBorder,
            focusedBorder: inputBorder,
            enabledBorder: inputBorder,
            errorBorder: errorBorder,
            focusedErrorBorder: errorBorder,
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon, color: const Color(0xFF565D6D))
                : null,
            filled: true,
            fillColor: widget.fillColor ?? AppTheme.of(context).textFieldColor,
          ),
          dropdownColor:
              widget.fillColor ?? AppTheme.of(context).textFieldColor,
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF565D6D)),
          isExpanded: true,
          style: AppTheme.of(context).bodyMedium,
        ),
      ],
    );
  }
}
