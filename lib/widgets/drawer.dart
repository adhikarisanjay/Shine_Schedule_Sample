import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shine_schedule/commonProvider/userdetaiils_Provider.dart';
import 'package:shine_schedule/config/router/route_names.dart';
import 'package:shine_schedule/utils/colors.dart';
import 'package:shine_schedule/utils/shared_preferences.dart';

class DrawerWidget extends ConsumerWidget {
  DrawerWidget({super.key});
  final List<String> drawerItems = [
    'Booking',
    'Profile',
    'Rate Our Service',
    'Logout',
  ];

  final List<IconData> drawerIcons = [
    Icons.settings,
    Icons.verified_user,
    Icons.star,
    Icons.logout,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDetailsProvider);

    return Drawer(
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: drawerItems.length + 1, // +1 for last item without divider
        separatorBuilder: (context, index) {
          return const Divider(
            height: 1,
          );
        },
        itemBuilder: (context, index) {
          if (index == 0) {
            return DrawerHeader(
              decoration: const BoxDecoration(
                color: ShineColors.appMainColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person)),
                  user.when(
                      data: (appUser) => Text(
                            "${appUser?.firstName}  ",
                            textAlign: TextAlign.start,
                            // ignore: prefer_const_constructors
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: Colors.white),
                          ),
                      error: (object, stackTrace) => const Text(""),
                      loading: () => const Text("........"))
                ],
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListTile(
              leading: Icon(drawerIcons[index - 1]), // Set icon for each item
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(drawerItems[index - 1]),
              ),
              trailing: const Icon(
                  Icons.arrow_forward_ios), // Adjusted index for the items list
              onTap: () {
                // Navigation logic for different drawer items
                if (index == 1) {
                  GoRouter.of(context).pushNamed(RouteNames.bookingInfo);
                }
                if (index == 2) {
                  GoRouter.of(context).pushNamed(RouteNames.profile);
                }
                if (index == 3) {
                  GoRouter.of(context).pushNamed(RouteNames.reviewScreen);
                }
                if (index == 4) {
                  SharedPreferenced().removeLoginStatus();
                  GoRouter.of(context).pushNamed(RouteNames.signIn);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
