import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWidget extends StatefulWidget {
  final String name;
  final IconData prefixIcon;
  final String hintText;
  final TextEditingController controller;
  final String? info;
  final bool obscured;
  final TextInputFormatter? formatter;
  final TextInputType? keyboardType;
  final Function? validate;
  final String? email;
  const TextFieldWidget({
    this.obscured = false,
    this.email,
    this.validate,
    super.key,
    this.keyboardType,
    this.info,
    this.formatter,
    required this.name,
    required this.hintText,
    required this.prefixIcon,
    required this.controller,
  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  bool obscuredT = true;
  @override
  Widget build(BuildContext context) {
    final heightB = MediaQuery.of(context).size.height;
    final widthB = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.name,
          style: Theme.of(
            context,
          ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w500),
        ),
        SizedBox(height: heightB * 0.01),
        TextFormField(
          validator: (value) {
            if (widget.validate != null) {
              return widget.validate!(value);
            } else {
              return value == null || value.isEmpty
                  ? 'Please enter your ${widget.name}'
                  : null;
            }
          },
          obscureText: widget.obscured ? obscuredT : false,
          inputFormatters: widget.formatter != null ? [widget.formatter!] : [],
          keyboardType: widget.keyboardType,
          controller: widget.controller,
          decoration: InputDecoration(
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widthB * 0.05),
              borderSide: const BorderSide(color: Colors.red),
            ),
            suffixIcon: widget.info != null
                ? Tooltip(
                    triggerMode: TooltipTriggerMode.tap,
                    showDuration: Duration(seconds: 5),
                    message: widget.info!,
                    padding: EdgeInsets.symmetric(
                      horizontal: widthB * 0.3,
                      vertical: heightB * 0.01,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(10),
                      shape: BoxShape.rectangle,
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    textStyle: Theme.of(
                      context,
                    ).textTheme.labelLarge!.copyWith(color: Colors.black),
                    child: Icon(
                      CupertinoIcons.info_circle,
                      color: Colors.grey[700],
                    ),
                  )
                : widget.obscured
                ? IconButton(
                    icon: Icon(
                      obscuredT ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
                    ),
                    color: Colors.grey[500],
                    onPressed: () {
                      setState(() {
                        obscuredT = !obscuredT;
                      });
                    },
                  )
                : null,

            prefixIcon: Icon(widget.prefixIcon, color: Colors.grey.shade500),
            hintText: widget.hintText,
            hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w300,
            ),
            fillColor: Colors.grey.shade100,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widthB * 0.05),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
