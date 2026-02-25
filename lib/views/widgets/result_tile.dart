import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel_app/utils/app_theme.dart';

class ResultTile extends StatelessWidget {
  const ResultTile({
    super.key,
    required this.title,
    required this.value,
    this.color,
    this.isTotal = false,
  });
  final String title;
  final String value;
  final Color? color;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? AppTheme.of(context).textFieldColor,
        borderRadius: BorderRadius.circular(5.r),
        border: Border.all(
          color: AppTheme.of(context).primaryBackground,
          width: 2,
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 3.r, horizontal: 10.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(title, style: AppTheme.of(context).bodyLarge)),
          SizedBox(width: 30.w),
          Text("\$$value", style: AppTheme.of(context).bodyLarge.copyWith(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
