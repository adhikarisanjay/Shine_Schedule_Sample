// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shine_schedule/utils/assets.dart';
import 'package:shine_schedule/widgets/default_loading.dart';
import 'package:go_router/go_router.dart';
import 'package:shine_schedule/config/router/route_names.dart';
import 'package:shine_schedule/config/router/auth_provider/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    ref.read(authStatusProvider.notifier); // Ensure provider is initialized

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();

    // Navigate to next screen after the animation
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<bool?>>(authStatusProvider, (previous, next) {
      next.when(
        data: (authStatus) {
          Future.delayed(const Duration(seconds: 2), () {
            if (authStatus == true) {
              GoRouter.of(context).pushReplacementNamed(RouteNames.home);
            } else {
              GoRouter.of(context).pushReplacementNamed(RouteNames.signIn);
            }
          });
        },
        loading: () {
          // You can show a loading state here if needed
        },
        error: (error, stack) {
          GoRouter.of(context).pushReplacementNamed(RouteNames.signIn);
        },
      );
    });
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Image.asset(
                  Assets.logoBlack,
                  width: 180,
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Loading(
              width: 50,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
