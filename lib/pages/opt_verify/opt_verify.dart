import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shine_schedule/config/router/route_names.dart';
import 'package:shine_schedule/pages/opt_verify/provider/opt_provider.dart';

import 'package:shine_schedule/utils/colors.dart';
import 'package:shine_schedule/utils/shared_preferences.dart';
import 'package:shine_schedule/widgets/appbar.dart';
import 'package:shine_schedule/widgets/custom_button.dart';
import 'package:shine_schedule/widgets/sizedbox.dart';
import 'package:shine_schedule/widgets/toast.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String? email;
  const OtpVerificationScreen({
    this.email,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final textEditingController = TextEditingController();
  String currentText = "";
  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();
  bool buttonActive = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<String>>(optVerifyProvider, (previous, next) {
      if (next.hasError) {
        setState(() {
          buttonActive = false;
        });
        toastWidget(context, Colors.red, next.error.toString());
      } else if (next.hasValue) {
        setState(() {
          buttonActive = false;
        });
        if (next.value == "resendEmail") {
          toastWidget(context, Colors.blue,
              "Please check your email for verification code");
        }

        if (next.value == "OtpConfirmation") {
          SharedPreferenced().setLoginStatus(true);
          GoRouter.of(context).pushNamed(RouteNames.booking);
        }
      }
    });
    return Scaffold(
      backgroundColor: ShineColors.background,
      appBar: CustomAppBar(
        isShowLeftIcon: false,
        pressedLeftIcon: () {
          GoRouter.of(context).pop();
        },
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
          child: Column(
            children: [
              space(height: 18, width: 0),
              Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: const CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: FaIcon(
                      FontAwesomeIcons.userSecret,
                      color: ShineColors.appMainColor,
                      size: 100,
                    ),
                  )),
              space(height: 24, width: 0),
              const Text(
                'Verification',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              space(height: 10, width: 0),
              const Text(
                "Enter your OTP code number ",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                "${widget.email} ",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                ),
                textAlign: TextAlign.center,
              ),
              space(height: 10, width: 0),
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: PinCodeTextField(
                        appContext: context,
                        length: 6,
                        obscureText: false,
                        animationType: AnimationType.none,
                        pinTheme: PinTheme(
                            shape: PinCodeFieldShape.underline,
                            fieldHeight: 50,
                            fieldWidth: 40,
                            inactiveFillColor: ShineColors.background,
                            activeFillColor: ShineColors.background,
                            selectedFillColor:
                                const Color.fromARGB(255, 255, 255, 255)),
                        animationDuration: const Duration(milliseconds: 300),
                        enableActiveFill: true,
                        errorAnimationController: errorController,
                        enablePinAutofill: true,
                        controller: textEditingController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field cannot be empty.';
                          }
                        },
                        onCompleted: (v) {
                          print("Completed");
                        },
                        onChanged: (value) {
                          print(value);
                          setState(() {
                            currentText = value;
                          });
                        },
                        beforeTextPaste: (text) {
                          //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                          //but you can show anything you want here, like your pop up saying wrong paste format or etc
                          return true;
                        },
                      ),
                    ),
                    space(height: 18, width: 0),
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              _submit();
                            }
                          },
                          label: 'Verify'),
                    )
                  ],
                ),
              ),
              space(height: 10, width: 0),
              const Text(
                "Didn't you receive any code?",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                ),
                textAlign: TextAlign.center,
              ),
              space(height: 18, width: 0),
              GestureDetector(
                onTap: () {
                  ref.read(optVerifyProvider.notifier).resendOtp(
                        email: widget.email ?? "",
                      );
                },
                child: const Text(
                  "Resend New Code",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ShineColors.appMainColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    setState(() {
      buttonActive = true;
    });
    ref.read(optVerifyProvider.notifier).confirmOtp(
          email: widget.email ?? "",
          otp: textEditingController.text.trim(),
        );
  }
}
