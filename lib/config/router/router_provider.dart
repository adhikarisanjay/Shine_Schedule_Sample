import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shine_schedule/common_model.dart/services_model.dart';
import 'package:shine_schedule/config/router/route_names.dart';
import 'package:shine_schedule/pages/booking/booking_ui.dart';
import 'package:shine_schedule/pages/booking_details/booking_details_ui.dart';
import 'package:shine_schedule/pages/booking_details/model/booking_details.dart';
import 'package:shine_schedule/pages/deepar/cameraScreen.dart';
import 'package:shine_schedule/pages/edit_appointments/edit_appointment_ui.dart';
import 'package:shine_schedule/pages/forgot_password/forgot_password_screen.dart';
import 'package:shine_schedule/pages/home/home.dart';
import 'package:shine_schedule/pages/opt_verify/opt_verify.dart';
import 'package:shine_schedule/pages/profile/profile_scree.dart';
import 'package:shine_schedule/pages/review/review_screen_ui.dart';
import 'package:shine_schedule/pages/services/services_ui.dart';
import 'package:shine_schedule/pages/signin/signin.dart';
import 'package:shine_schedule/pages/signup/signup.dart';
import 'package:shine_schedule/pages/splash/splash_screen.dart';
import 'package:shine_schedule/payment/payment_screen.dart';
part 'router_provider.g.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
@riverpod
GoRouter route(RouteRef ref) {
  return GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: '/splashScreen',
      routes: [
        GoRoute(
          path: '/home',
          name: RouteNames.home,
          builder: (BuildContext context, GoRouterState state) {
            return const MyHomePage();
          },
        ),
        GoRoute(
          path: '/signin',
          name: RouteNames.signIn,
          builder: (context, state) {
            return const SingInPage();
          },
        ),
        GoRoute(
          path: '/signup',
          name: RouteNames.signup,
          builder: (context, state) {
            return const SignUpPage();
          },
        ),
        GoRoute(
            path: '/booking',
            name: RouteNames.booking,
            builder: (context, state) {
              dynamic extra = state.extra!;

              final selectedService = extra["service"] as ServicesModel;
              final String image = extra['image'] as String;
              return BookingScreen(
                service: selectedService,
                image: image,
              );
            }),
        GoRoute(
          path: '/otpVerify/:email',
          name: RouteNames.otpVerify,
          builder: (context, state) {
            return OtpVerificationScreen(email: state.pathParameters['email']);
          },
        ),
        GoRoute(
          path: '/services/:catName',
          name: RouteNames.services,
          builder: (context, state) {
            return ServicesPage(
              categoryName: state.pathParameters['catName'] ?? '',
            );
          },
        ),
        GoRoute(
          path: '/splashScreen',
          name: RouteNames.splashscreen,
          builder: (context, state) {
            return const SplashScreen();
          },
        ),
        GoRoute(
          path: '/forgotPassword',
          name: RouteNames.fogot,
          builder: (context, state) {
            return const ForgotPasswordWidget();
          },
        ),
        GoRoute(
          path: '/profileScreen',
          name: RouteNames.profile,
          builder: (context, state) {
            return const ProfileScreen();
          },
        ),
        GoRoute(
          path: '/bookingInfoScreen',
          name: RouteNames.bookingInfo,
          builder: (context, state) {
            return const BookingScreenUI();
          },
        ),
        GoRoute(
          path: '/deepARScreen',
          name: RouteNames.deepAr,
          builder: (context, state) {
            final selectedService = state.extra! as ServicesModel;
            return DeepARCameraScreen(
              service: selectedService,
            );
          },
        ),
        GoRoute(
          path: '/reviewScreen',
          name: RouteNames.reviewScreen,
          builder: (context, state) {
            return const ReviewScreen();
          },
        ),
        GoRoute(
            path: '/bookingEditScreen',
            name: RouteNames.bookingEditUi,
            builder: (context, state) {
              final bookingDetails = state.extra! as BookingDetails;
              return BookingEditScreen(
                bookingDetails: bookingDetails,
              );
            }),
        GoRoute(
          path: '/paymentScreen',
          name: RouteNames.payment,
          builder: (context, state) {
            dynamic extra = state.extra!;
            final selectedService = extra["service"] as ServicesModel;
            final selectedTime =
                extra['times'] as List<String>; // Split comma-separated times
            final String image =
                extra['image'] as String; // Split comma-separated times
            final selectedDate = extra['date'] as String;

            return PaymentScreen(
              service: selectedService,
              date: selectedDate,
              times: selectedTime,
              image: image,
            );
          },
        ),
      ]);
}
