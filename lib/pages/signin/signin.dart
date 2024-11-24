import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shine_schedule/config/router/route_names.dart';
import 'package:shine_schedule/pages/opt_verify/provider/opt_provider.dart';
import 'package:shine_schedule/pages/signin/provider/login_provider.dart';
import 'package:shine_schedule/pages/signup/provider/gmail_register.dart';
import 'package:shine_schedule/utils/assets.dart';
import 'package:shine_schedule/utils/colors.dart';
import 'package:shine_schedule/utils/shared_preferences.dart';
import 'package:shine_schedule/widgets/custom_button.dart';
import 'package:shine_schedule/widgets/custom_entry.dart';
import 'package:go_router/go_router.dart';
import 'package:shine_schedule/widgets/toast.dart';

class SingInPage extends ConsumerStatefulWidget {
  const SingInPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SingInPageState();
}

class _SingInPageState extends ConsumerState<SingInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool buttonActive = false;
  bool gmailActive = false;

  @override
  Widget build(BuildContext adcontext) {
    ref.listen<AsyncValue<String?>>(loginActivityProvider, (previous, next) {
      if (next.hasError) {
        setState(() {
          buttonActive = false;
        });
        toastWidget(context, Colors.red, next.error.toString());
      } else if (next.hasValue) {
        setState(() {
          buttonActive = false;
        });

        if (next.value.toString() == "confirmSignUp") {
          ref.read(optVerifyProvider.notifier).resendOtp(
                email: emailController.text.trim(),
              );
          toastWidget(context, Colors.blue,
              "Please check your email for verification code and try again");
        } else {
          SharedPreferenced().setLoginStatus(true);
          GoRouter.of(context).pushReplacementNamed(RouteNames.home);
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

        toastWidget(context, Colors.blue, "User Logged in Successfully");
        GoRouter.of(context).pushReplacementNamed(RouteNames.home);
      }
    });

    return Scaffold(
      backgroundColor: ShineColors.background,
      body: LayoutBuilder(builder: (contex, BoxConstraints constraints) {
        if (constraints.maxWidth >= 900) {
          return web();
        } else {
          return mobile();
        }
      }),
    );
  }

  Widget web() {
    var theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        child: Container(
          width: 600,
          padding: const EdgeInsets.all(50),
          margin: const EdgeInsets.all(20),
          child: Card(
            elevation: 2,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
                    child: Image.asset(
                      Assets.logo,
                      height: 40,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  EntryField(
                    label: 'Email',
                    controller: emailController,
                    textInputType: TextInputType.emailAddress,
                    validateEnum: ProfileValidateEnum.email,
                    prefixIcon: Icons.email,
                  ),
                  const SizedBox(height: 20),
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
                  GestureDetector(
                    onTap: () {
                      GoRouter.of(context).pushNamed(RouteNames.fogot);
                    },
                    child: Text(
                      'Forgot Password',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontSize: 19,
                        color: ShineColors.titleColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  CustomButton(
                    label: 'Login',
                    active: buttonActive,
                    onTap: () async {
                      FocusScope.of(context).unfocus();

                      if (_formKey.currentState!.validate()) {
                        _submit();
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Don't have an account? ",
                    style: theme.textTheme.titleSmall!.copyWith(
                      fontSize: 14,
                      color: ShineColors.textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      GoRouter.of(context).pushNamed(RouteNames.signup);
                    },
                    child: Text(
                      'Register',
                      style: theme.textTheme.titleLarge!.copyWith(
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                        color: ShineColors.textColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    "OR ",
                    style: theme.textTheme.titleLarge!.copyWith(
                      fontSize: 14,
                      color: ShineColors.textColor,
                      fontWeight: FontWeight.w800,
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
                                  "Sign In with Google",
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

  Widget mobile() {
    var theme = Theme.of(context);

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 80,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
                child: Image.asset(
                  Assets.logo,
                  height: 40,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              EntryField(
                label: 'Email',
                controller: emailController,
                textInputType: TextInputType.emailAddress,
                validateEnum: ProfileValidateEnum.email,
                prefixIcon: Icons.email,
              ),
              const SizedBox(height: 20),
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
              GestureDetector(
                onTap: () {
                  GoRouter.of(context).pushNamed(RouteNames.fogot);
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 20, 0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Forgot Password',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontSize: 14,
                        color: ShineColors.titleColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              CustomButton(
                label: 'Login',
                active: buttonActive,
                onTap: () async {
                  FocusScope.of(context).unfocus();

                  if (_formKey.currentState!.validate()) {
                    _submit();
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Don't have an account? ",
                style: theme.textTheme.titleSmall!.copyWith(
                  fontSize: 14,
                  color: ShineColors.textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  GoRouter.of(context).pushNamed(RouteNames.signup);
                },
                child: Text(
                  'Register',
                  style: theme.textTheme.titleLarge!.copyWith(
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                    color: ShineColors.textColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                "OR ",
                style: theme.textTheme.titleLarge!.copyWith(
                  fontSize: 14,
                  color: ShineColors.textColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    gmailActive = true;
                  });
                  ref.read(gmailRegisterProvider.notifier).signInWithGoogle();
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
                              "Sign In with Google",
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
    );
  }

  void _submit() {
    setState(() {
      buttonActive = true;
    });
    ref.read(loginActivityProvider.notifier).login(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
  }
}
