import 'package:flutter/material.dart';
import 'package:spinovo_app/widget/text_widget.dart';

class ContinueButton extends StatelessWidget {
  final double? height;
  final double? width;

  final String text;
  final bool isValid;
  final Function() onTap;
  final Color? bgColor;
  final Color? textColor;
  final BoxBorder? border;
  final bool isLoading;
  final double? textSize;

  const ContinueButton({
    super.key,
    required this.text,
    required this.isValid,
    required this.onTap,
    this.bgColor = const Color(0xFF33C362),
    this.border,
    this.textColor = Colors.white,
    this.isLoading = false,
    this.height = 48,
    this.width = double.infinity, this.textSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              border: border,
              color: isValid ? bgColor : const Color(0xFFEAEAF1),
              borderRadius: BorderRadius.circular(8)),
          child: Center(
              child: isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : SmallText(
                      text: text,
                      color: isValid ? textColor : const Color(0xFFBCBCCD),
                      size: textSize,
                      fontweights: FontWeight.w400,
                    ))),
    );
  }
}
