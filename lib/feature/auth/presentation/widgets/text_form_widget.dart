import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TextFormWidget extends StatefulWidget {
  const TextFormWidget({
    super.key,
    this.controller,
    this.validator,
    this.hintText,
    required this.suffixIcon,
    required this.prefixIcon,
    this.obscureText = true,
    this.errorMaxLines = 4,
  });

  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? hintText;
  final String suffixIcon;
  final String prefixIcon;
  final bool obscureText;
  final int errorMaxLines;

  @override
  State<TextFormWidget> createState() => _TextFormWidgetState();
}

class _TextFormWidgetState extends State<TextFormWidget> {
  late bool isObscure;

  @override
  void initState() {
    super.initState();
    isObscure = widget.obscureText;
  }

  @override
  void dispose() {
    widget.controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      obscureText: isObscure,
      style: Theme.of(context).textTheme.titleSmall,
      autovalidateMode: AutovalidateMode.onUserInteraction, // <-- مهم
      decoration: InputDecoration(
        errorMaxLines: widget.errorMaxLines, // <-- عدد أسطر رسالة الخطأ
        suffixIcon: InkWell(
          onTap: () {
            setState(() {
              isObscure = !isObscure;
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 8),
            child: SizedBox(
              width: 20,
              height: 20,
              child: SvgPicture.asset(
                widget.suffixIcon,
                fit: BoxFit.contain,
                colorFilter: isObscure
                    ? null
                    : const ColorFilter.mode(AppColors.redOrange, BlendMode.srcIn),
              ),
            ),
          ),
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: SizedBox(
            width: 25,
            height: 25,
            child: SvgPicture.asset(
              widget.prefixIcon,
              fit: BoxFit.contain,
            ),
          ),
        ),
        hintText: widget.hintText,
      ),
    );
  }
}