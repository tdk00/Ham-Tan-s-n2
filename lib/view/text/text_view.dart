import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextView extends StatelessWidget {
  final String? textPaste;
  final double? textSize;
  final FontWeight? fontWeight;
  final Color? textColor;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextDecoration? textDecoration;
  final TextOverflow? overflow;

  const CustomTextView({
    Key? key,
    required this.textPaste,
    this.textSize,
    this.fontWeight,
    this.textColor,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.textDecoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      textPaste!,
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines,
      overflow: overflow,
      style: GoogleFonts.montserrat(
        textStyle: TextStyle(
          fontSize: textSize,
          decoration: textDecoration,
          fontWeight: fontWeight,
          color: textColor,
        ),
      ),
    );
  }
}
