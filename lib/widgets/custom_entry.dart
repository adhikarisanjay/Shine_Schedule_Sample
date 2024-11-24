import 'package:flutter/material.dart';
import 'package:shine_schedule/utils/colors.dart';
import 'package:email_validator/email_validator.dart';

enum ProfileValidateEnum { username, email, phone }

class EntryField extends StatelessWidget {
  EntryField({
    Key? key,
    this.hint,
    this.prefixIcon,
    this.color,
    this.controller,
    this.initialValue,
    this.readOnly,
    this.textAlign,
    this.suffixIcon,
    this.textInputType,
    this.label,
    this.maxLines = 1,
    this.minLines,
    this.onTap,
    this.suffix,
    this.obsuretext,
    this.validateEnum,
    this.disabled,
    this.validator,
  }) : super(key: key);

  final String? hint;
  final IconData? prefixIcon;
  final Color? color;
  final TextEditingController? controller;
  final String? initialValue;
  final bool? readOnly;
  final TextAlign? textAlign;
  final Widget? suffixIcon;
  final TextInputType? textInputType;
  final String? label;
  final int? maxLines;
  final int? minLines;
  final Function? onTap;
  final IconData? suffix;
  final bool? obsuretext;
  bool? validationbool;
  bool? disabled = false;
  final String? Function(String?)? validator;

  final ProfileValidateEnum? validateEnum;

  Function? getValidatorForField(ProfileValidateEnum field) {
    if (validateEnum == ProfileValidateEnum.email) {
      return (value) {
        if (!EmailValidator.validate(value)) {
          return "Please enter a valid Email.";
        }
      };
    }
    if (validateEnum == ProfileValidateEnum.phone) {
      return (value) {
        String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
        RegExp regExp = RegExp(pattern);
        if (value.length == 0) {
          return 'Please enter mobile number';
        } else if (!regExp.hasMatch(value)) {
          return 'Please enter valid mobile number';
        }
        return null;
      };
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
          margin: const EdgeInsets.only(
              top: 12), // Add margin to space out from top
          width: MediaQuery.of(context).size.width * 0.9,
          child: TextFormField(
            controller: controller,
            initialValue: initialValue,
            readOnly: readOnly ?? false,
            maxLines: maxLines ?? 1,
            minLines: minLines,
            obscureText: obsuretext ?? false,
            textAlign: textAlign ?? TextAlign.left,
            keyboardType: textInputType,
            decoration: InputDecoration(
              errorStyle: const TextStyle(color: Colors.red),
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 16.0, horizontal: 20.0), // Adjust padding
              prefixIcon: prefixIcon == null
                  ? null
                  : Icon(
                      prefixIcon,
                      color: Colors.grey,
                      size: 20,
                    ),
              suffixIcon: suffixIcon,
              hintText: hint,
              hintStyle:
                  const TextStyle(fontSize: 12, color: ShineColors.textColor),
              filled: true,
              fillColor: readOnly == true
                  ? Colors.green[50]
                  : color ?? Theme.of(context).bottomAppBarTheme.color,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
                gapPadding: 5,
              ),
              isDense: true,
              labelText: label,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              labelStyle: TextStyle(
                color: Theme.of(context).hintColor,
                fontSize: 16,
              ),
            ),
            validator: validator ??
                (value) {
                  if (validationbool != false) {
                    if (value == null || value.isEmpty) {
                      return 'This field cannot be empty.';
                    }
                    if (validateEnum != null) {
                      var validator = getValidatorForField(validateEnum!);
                      if (validator != null) {
                        var res = validator(value);
                        if (res != null) {
                          return res;
                        }
                      }
                    }
                  }
                  return null;
                },
          ),
        ),
      ],
    );
  }
}
