import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shine_schedule/pages/forgot_password/provider/reset_provider.dart';
import 'package:shine_schedule/utils/colors.dart';
import 'package:shine_schedule/widgets/custom_button.dart';
import 'package:shine_schedule/widgets/custom_entry.dart';
import 'package:shine_schedule/widgets/toast.dart';

class ForgotPasswordWidget extends ConsumerStatefulWidget {
  const ForgotPasswordWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ForgotPasswordWidgetState();
}

class _ForgotPasswordWidgetState extends ConsumerState<ForgotPasswordWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  bool buttonActive = false;
  bool gmailActive = false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    ref.listen<AsyncValue<String?>>(resetActivityProvider, (previous, next) {
      if (next.hasError) {
        setState(() {
          buttonActive = false;
        });
        toastWidget(context, Colors.red, next.error.toString());
      } else if (next.hasValue) {
        setState(() {
          buttonActive = false;
        });
        if (next.value == "Email does not exist.") {
          toastWidget(context, Colors.red, next.value.toString());
        } else {
          toastWidget(context, Colors.blue, next.value.toString());

          GoRouter.of(context).pop();
        }
      }
    });

    return SafeArea(
      child: Scaffold(
        backgroundColor: ShineColors.background,
        appBar: AppBar(
          backgroundColor: ShineColors.background,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
                Icons.arrow_back_ios), // Different icon for back button
            onPressed: () {
              GoRouter.of(context).pop();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.vertical -
                AppBar().preferredSize.height,
            margin: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Forgot Password',
                    style: theme.textTheme.titleLarge!.copyWith(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '',
                    style: theme.textTheme.titleLarge!.copyWith(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  EntryField(
                    label: 'Email',
                    controller: emailController,
                    textInputType: TextInputType.emailAddress,
                    validateEnum: ProfileValidateEnum.email,
                    prefixIcon: Icons.email,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                    label: 'Send',
                    active: buttonActive,
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      if (_formKey.currentState!.validate()) {
                        _submit(context);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submit(BuildContext context) {
    setState(() {
      buttonActive = true;
    });
    ref.read(resetActivityProvider.notifier).fogotPassword(
          email: emailController.text.trim(),
        );
  }
}
