import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shine_schedule/config/router/route_names.dart';
import 'package:shine_schedule/pages/signup/provider/gmail_register.dart';
import 'package:shine_schedule/pages/signup/provider/register_provider.dart';
import 'package:shine_schedule/utils/assets.dart';
import 'package:shine_schedule/utils/colors.dart';
import 'package:shine_schedule/utils/shared_preferences.dart';
import 'package:shine_schedule/widgets/custom_button.dart';
import 'package:shine_schedule/widgets/custom_entry.dart';
import 'package:shine_schedule/widgets/toast.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _obscureTextConfirm = true;

  final emailController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();

  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  bool buttonActive = false;
  bool gmailActive = false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    ref.listen<AsyncValue<String?>>(registerActivityProvider, (previous, next) {
      if (next.hasError) {
        // Show error message
        setState(() {
          buttonActive = false;
        });
        toastWidget(context, Colors.red, next.error.toString());
      } else if (next.hasValue) {
        setState(() {
          buttonActive = false;
        });
        if (next.value == "Email already exists.") {
          toastWidget(context, Colors.blue,
              "Email already exists. Please enter another email ");
        } else {
          toastWidget(context, Colors.blue,
              "Please check your email for verification ");

          GoRouter.of(context).pop();
        }
      }
    });

    ref.listen<AsyncValue<String?>>(gmailRegisterProvider, (previous, next) {
      if (next.hasError) {
        // Show error message
        setState(() {
          gmailActive = false;
        });
        toastWidget(context, Colors.red, next.error.toString());
      } else if (next.value != null) {
        setState(() {
          gmailActive = false;
        });
        SharedPreferenced().setLoginStatus(true);

        toastWidget(context, Colors.blue, "User Loggedin Successfully");
        GoRouter.of(context).pushReplacementNamed(RouteNames.home);
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
            margin: const EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height -
                200, // Adjust height dynamically
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Sign Up',
                    style: theme.textTheme.titleLarge!.copyWith(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Create an account',
                    style: theme.textTheme.titleLarge!.copyWith(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  EntryField(
                    label: 'First Name',
                    controller: firstNameController,
                    textInputType: TextInputType.text,
                    validateEnum: ProfileValidateEnum.username,
                    prefixIcon: Icons.person,
                  ),
                  const SizedBox(height: 10),
                  EntryField(
                    label: 'Last Name',
                    controller: lastNameController,
                    textInputType: TextInputType.text,
                    validateEnum: ProfileValidateEnum.username,
                    prefixIcon: Icons.person,
                  ),
                  const SizedBox(
                    height: 10,
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
                  EntryField(
                    label: 'Phone',
                    controller: phoneController,
                    textInputType: TextInputType.phone,
                    prefixIcon: Icons.phone,
                    validateEnum: ProfileValidateEnum.phone,
                  ),
                  const SizedBox(height: 10),
                  EntryField(
                    controller: passwordController,
                    obsuretext: _obscureText,
                    label: 'Password',
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      child: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                    ),
                    prefixIcon: Icons.lock,
                    onTap: () {},
                  ),
                  const SizedBox(height: 10),
                  EntryField(
                    controller: passwordConfirmController,
                    obsuretext: _obscureTextConfirm,
                    label: ' ConfirmPassword',
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureTextConfirm = !_obscureTextConfirm;
                        });
                      },
                      child: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                    ),
                    prefixIcon: Icons.lock,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password.';
                      }
                      if (value != passwordController.text) {
                        return 'Passwords do not match.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),
                  CustomButton(
                    label: 'Register',
                    active: buttonActive,
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      if (_formKey.currentState!.validate()) {
                        _submit(context);
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "OR ",
                    style: theme.textTheme.titleLarge!.copyWith(
                      fontSize: 14,
                      color: ShineColors.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        gmailActive = true;
                      });
                      ref
                          .read(gmailRegisterProvider.notifier)
                          .signInWithGoogle();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      margin: const EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0.0, 10.0),
                            blurRadius: 10.0,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            Assets.googleIcon,
                            height: 24,
                          ),
                          const SizedBox(width: 12),
                          gmailActive
                              ? Transform.scale(
                                  scale: 0.8,
                                  child: const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      ShineColors.appMainColor,
                                    ),
                                  ),
                                )
                              : Text(
                                  "Sign Up with Google",
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontSize: 16,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                        ],
                      ),
                    ),
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
    ref.read(registerActivityProvider.notifier).register(
          firstName: firstNameController.text.trim(),
          lastName: lastNameController.text.trim(),
          phoneNumber: phoneController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          context: context,
        );
  }
}
