import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:threekm/utils/threekm_textstyles.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final Color? fillColor;
  final double? borderRadius;
  final String? hint;
  final String? Function(String?)? validator;
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final TextStyle? hintStyle;
  final bool? password;
  final FocusNode? focusNode;
  final TextStyle? style;
  final int? maxLines;
  final int? maxLength;
  final bool? valid;
  final double? height;
  final EdgeInsetsGeometry? contentPadding;
  final TextInputType? keyboardType;
  final bool? border;
  final Widget? prefix;
  final Widget? suffix;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlignVertical? textAlignVertical;
  CustomTextField(
      {this.fillColor,
      this.onChanged,
      this.borderRadius,
      this.hint,
      this.hintStyle,
      this.style,
      this.height,
      this.border,
      this.controller,
      this.textAlignVertical,
      this.inputFormatters,
      this.prefix,
      this.keyboardType,
      this.password,
      this.validator,
      this.maxLines,
      this.valid,
      this.onTap,
      this.focusNode,
      this.maxLength,
      this.suffix,
      this.contentPadding});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: height != null ? height! + 12 : height,
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(borderRadius ?? 5),
          ),
        ),
        Container(
          height: height != null ? height! + 12 : height,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(borderRadius ?? 5),
          ),
          child: TextFormField(
            onChanged: onChanged,
            focusNode: focusNode,
            onTap: onTap,
            obscureText: password ?? false,
            controller: controller,
            textAlignVertical: textAlignVertical ?? TextAlignVertical.top,
            validator: validator,
            expands: password != null ? !password! : true,
            keyboardType: keyboardType ?? TextInputType.name,
            maxLines: maxLines,
            maxLength: maxLength,
            buildCounter: (context,
                    {required currentLength, required isFocused, maxLength}) =>
                Container(
              height: 2,
            ),
            minLines: null,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              contentPadding: contentPadding,
              suffixIcon: suffix,
              errorStyle: hintStyle?.copyWith(color: ThreeKmTextConstants.red1),
              prefixIcon: prefix,
              fillColor: fillColor,
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 5),
                borderSide: BorderSide(color: ThreeKmTextConstants.red1),
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 5),
                  borderSide: border != null && border == true
                      ? BorderSide(
                          width: 2,
                          color: valid != null && valid!
                              ? Colors.blue
                              : valid != null && !valid!
                                  ? ThreeKmTextConstants.red1
                                  : Colors.grey.withOpacity(0.5))
                      : BorderSide.none),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 5),
                  borderSide: border != null && border == true
                      ? BorderSide(
                          color: valid != null && valid!
                              ? Colors.grey.withOpacity(0.5)
                              : valid != null && !valid!
                                  ? ThreeKmTextConstants.red1
                                  : Colors.grey.withOpacity(0.5))
                      : BorderSide.none),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 5),
                  borderSide: border != null && border == true
                      ? BorderSide(color: Color(0xFFDFE5EE))
                      : BorderSide.none),
              hintText: hint,
              hintStyle: hintStyle,
            ),
            style: style,
          ),
        ),
      ],
    );
  }
}

class CustomTextField2 extends StatelessWidget {
  final TextEditingController? controller;
  final Color? fillColor;
  final Color? borderColor;
  final double? borderRadius;
  final String? hint;
  final TextStyle? hintStyle;
  final bool? password;
  final TextStyle? style;
  final double? height;
  final TextInputType? keyboardType;
  final bool? border;
  final Widget? prefix;
  final TextAlignVertical? textAlignVertical;
  CustomTextField2(
      {this.fillColor,
      this.borderRadius,
      this.hint,
      this.hintStyle,
      this.style,
      this.height,
      this.border,
      this.controller,
      this.textAlignVertical,
      this.prefix,
      this.keyboardType,
      this.password,
      this.borderColor});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: height,
          margin: EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(borderRadius ?? 5),
          ),
        ),
        Container(
          height: height,
          child: TextField(
            obscureText: password ?? false,
            controller: controller,
            textAlignVertical: textAlignVertical ?? TextAlignVertical.top,
            expands: true,
            keyboardType: keyboardType ?? TextInputType.name,
            maxLines: null,
            minLines: null,
            decoration: InputDecoration(
              errorStyle: hintStyle?.copyWith(color: ThreeKmTextConstants.red1),
              prefixIcon: prefix,
              fillColor: fillColor,
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 5),
                borderSide: BorderSide(color: ThreeKmTextConstants.red1),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 5),
                borderSide: border != null && border == true
                    ? BorderSide(
                        color: borderColor ?? Color(0xFFDFE5EE),
                        width: 0.5,
                      )
                    : BorderSide.none,
              ),
              hintText: hint,
              hintStyle: hintStyle,
            ),
            style: style,
          ),
        ),
      ],
    );
  }
}
