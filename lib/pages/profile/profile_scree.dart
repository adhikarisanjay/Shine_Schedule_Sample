import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shine_schedule/commonProvider/userdetaiils_Provider.dart';
import 'package:shine_schedule/common_model.dart/user_model.dart';
import 'package:shine_schedule/config/router/route_names.dart';
import 'package:shine_schedule/pages/profile/provider/profile_provider.dart';
import 'package:shine_schedule/pages/signup/provider/gmail_register.dart';
import 'package:shine_schedule/pages/signup/provider/register_provider.dart';
import 'package:shine_schedule/utils/assets.dart';
import 'package:shine_schedule/utils/colors.dart';
import 'package:shine_schedule/utils/shared_preferences.dart';
import 'package:shine_schedule/widgets/custom_button.dart';
import 'package:shine_schedule/widgets/custom_entry.dart';
import 'package:shine_schedule/widgets/sizedbox.dart';
import 'package:shine_schedule/widgets/toast.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();

  bool buttonActive = false;
  bool gmailActive = false;
  bool diactiveForm = true;

  String buttonText = "Edit";
  @override
  void initState() {
    super.initState();
    final user = ref.read(userDetailsProvider).value;
    if (user != null) {
      firstNameController.text = user.firstName ?? '';
      lastNameController.text = user.lastName ?? '';
      emailController.text = user.email ?? '';
      phoneController.text = user.phoneNumber ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userDetailsProvider);

    ref.listen<AsyncValue<String?>>(editProfileProvider, (previous, next) {
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

        toastWidget(context, Colors.blue, next.value.toString());

        GoRouter.of(context).pop();
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
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.vertical -
                AppBar().preferredSize.height,
            margin: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: user.when(
                data: (appUser) => Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: ShineColors.appMainColor,
                          radius: 40.0, // Increased radius
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: Text(
                              "${appUser?.firstName?.characters.first}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize: 50,
                              ),
                            ),
                          ),
                        ),
                        space(height: 20, width: 0),
                        EntryField(
                          label: 'First Name',
                          controller: firstNameController,
                          readOnly: diactiveForm,
                          textInputType: TextInputType.text,
                          validateEnum: ProfileValidateEnum.username,
                          prefixIcon: Icons.person,
                        ),
                        const SizedBox(height: 10),
                        EntryField(
                          label: 'Last Name',
                          readOnly: diactiveForm,
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
                          readOnly: true,
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
                          readOnly: diactiveForm,
                          controller: phoneController,
                          textInputType: TextInputType.phone,
                          prefixIcon: Icons.phone,
                        ),
                        const SizedBox(height: 10),
                        const SizedBox(height: 40),
                        CustomButton(
                          label: buttonText,
                          active: buttonActive,
                          onTap: () async {
                            if (buttonText == "Edit") {
                              diactiveForm = false;
                            } else {
                              FocusScope.of(context).unfocus();
                              if (_formKey.currentState!.validate()) {
                                _submit(context);
                              }
                            }
                            setState(() {
                              buttonText =
                                  buttonText == "Edit" ? "Submit" : "Edit";
                            });
                          },
                        ),
                      ],
                    )),
                error: (object, stackTrace) => const Center(child: Text("")),
                loading: () => const Center(child: Text("")),
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
      diactiveForm = diactiveForm == true ? false : true;
    });
    ref.read(editProfileProvider.notifier).editProfile(UserModel(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        phoneNumber: phoneController.text));
    ref.read(userDetailsProvider.notifier).userDetails();
  }
}
