import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shine_schedule/commonProvider/userdetaiils_Provider.dart';
import 'package:shine_schedule/common_model.dart/services_model.dart';
import 'package:shine_schedule/config/router/route_names.dart';
import 'package:shine_schedule/payment/provider/booking_post.dart';
import 'package:shine_schedule/payment/provider/email_provider.dart';
import 'package:shine_schedule/utils/colors.dart';
import 'package:shine_schedule/widgets/appbar.dart';
import 'package:shine_schedule/widgets/custom_button.dart';
import 'package:shine_schedule/widgets/sizedbox.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shine_schedule/widgets/toast.dart';
import 'package:intl/intl.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  final ServicesModel service;
  final String date;
  final List<String> times;
  final String? image;

  const PaymentScreen(
      {super.key,
      required this.service,
      required this.date,
      required this.times,
      this.image});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  Map<String, dynamic>? paymentIntent;
  bool buttonActive = false;

  String? username;
  String? formattedDate;
  String date = "";
  int? tax;
  int? total;
  int? reservationFee;
  int? remaining;

  @override
  void initState() {
    super.initState();
    String date = dateConvert(widget.date);
    DateTime inputDate = DateTime.parse(date);
    setState(() {
      formattedDate = DateFormat('EEEE, MMMM d').format(inputDate);
      tax = (widget.service.price * 0.13).ceil();
      total = (widget.service.price + widget.service.price * 0.13).ceil();
      reservationFee = (total! * 0.45).ceil();
      remaining = (total! - reservationFee!).ceil();
    });
  }

  String dateConvert(String originalDateStr) {
    // Split the original date string by '-'
    List<String> parts = originalDateStr.split('-');

    // Ensure parts has exactly 3 elements (year, month, day)
    if (parts.length == 3) {
      // Extract year, month, and day
      String year = parts[0];
      String month = parts[1];
      String day = parts[2];

      // Format month and day with leading zeros if necessary
      String formattedDate =
          '$year-${month.padLeft(2, '0')}-${day.padLeft(2, '0')}';
      setState(() {
        date = formattedDate;
      });
      return formattedDate;
    }
    return date;
  }

  @override
  Widget build(BuildContext context) {
    final userAsyncValue = ref.watch(userDetailsProvider);
    ref.listen<AsyncValue<String?>>(postBookingInfoProvider, (previous, next) {
      if (next.hasError) {
        // Show error message
        setState(() {
          buttonActive = false;
        });
        toastWidget(context, Colors.red, next.error.toString());
      } else {
        toastWidget(context, Colors.blue, next.value.toString());
        userAsyncValue.when(
          data: (appUser) {
            username = "${appUser?.firstName}";
            ref.read(sendEmailProvider.notifier).sendEmail(
                receiverEmail: appUser?.email ?? "",
                userName: appUser?.firstName ?? "",
                serviceName: widget.service.name,
                date: date,
                time: widget.times,
                amount: reservationFee!.toDouble());
          },
          loading: () => null,
          error: (error, stackTrace) => null,
        );
      }
    });

    ref.listen<AsyncValue<String?>>(sendEmailProvider, (previous, next) {
      if (next.hasError) {
        // Show error message
        setState(() {
          buttonActive = false;
        });
        toastWidget(context, Colors.red, next.error.toString());
      } else {
        toastWidget(context, Colors.blue, next.value.toString());
        GoRouter.of(context).pushReplacementNamed(RouteNames.home);

        setState(() {
          buttonActive = false;
        });
      }
    });

    return Scaffold(
      appBar: CustomAppBar(
        isShowLeftIcon: true,
        pressedLeftIcon: () {
          GoRouter.of(context).pop();
        },
        pressedActionIcon3: () {},
        leftIcon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double maxWidth = constraints.maxWidth;
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: ShineColors.background,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Container(
                            width: maxWidth * 0.9,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Appointment Summary",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20,
                                        color: ShineColors.iconColor),
                                  ),
                                  space(height: 10, width: 0),
                                  textIcon(
                                    Icons.calendar_today_outlined,
                                    formattedDate ?? '',
                                  ),
                                  space(height: 5, width: 0),
                                  Row(
                                    children: [
                                      textIcon(Icons.alarm, widget.times.first),
                                      space(height: 0, width: 10),
                                      Text(
                                        "(Approx. ${widget.times.length} hour duration)",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                            color: ShineColors.iconColor),
                                      ),
                                    ],
                                  ),
                                  space(height: 20, width: 0),
                                  const Text(
                                    "Confirm your services",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        color: ShineColors.iconColor),
                                  ),
                                  Text(
                                    widget.service.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                        color: ShineColors.iconColor),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 10,
                                        child: Row(
                                          children: [
                                            const Icon(Icons.alarm,
                                                color: ShineColors.iconColor),
                                            space(height: 0, width: 5),
                                            Text(
                                              "Approx ${widget.service.duration} minutes",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14,
                                                  color: ShineColors.iconColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          "\$ ${widget.service.price}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              color: ShineColors.iconColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                  space(height: 20, width: 0),
                                  const Divider(
                                    height: 2,
                                    color: Colors.grey,
                                  ),
                                  space(height: 20, width: 0),
                                  Row(
                                    children: [
                                      const Expanded(
                                        flex: 10,
                                        child: Text(
                                          "Tax",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              color: ShineColors.iconColor),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          "\$ ${tax?.toStringAsFixed(2)}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              color: ShineColors.iconColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                  space(height: 20, width: 0),
                                  const Divider(
                                    height: 2,
                                    color: Colors.grey,
                                  ),
                                  space(height: 10, width: 0),
                                  Row(
                                    children: [
                                      const Expanded(
                                        flex: 10,
                                        child: Text(
                                          "Total",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                              color: ShineColors.iconColor),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          "\$ ${total?.toStringAsFixed(2)}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              color: ShineColors.iconColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                  space(height: 20, width: 0),
                                  Row(
                                    children: [
                                      const Expanded(
                                        flex: 2,
                                        child: Text(
                                          "",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                              color: ShineColors.iconColor),
                                        ),
                                      ),
                                      const Expanded(
                                        flex: 8,
                                        child: Text(
                                          "Reservation Fee",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              color: ShineColors.iconColor),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          "\$ ${reservationFee?.toStringAsFixed(2)}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              color: ShineColors.iconColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                  space(height: 10, width: 0),
                                  Row(
                                    children: [
                                      const Expanded(
                                        flex: 2,
                                        child: Text(
                                          "",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                              color: ShineColors.iconColor),
                                        ),
                                      ),
                                      const Expanded(
                                        flex: 8,
                                        child: Text(
                                          "Remaining payment at venue",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              color: ShineColors.iconColor),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          "\$ ${remaining?.toStringAsFixed(2)}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              color: ShineColors.iconColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2 + 10,
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: BoxDecoration(
                    color: ShineColors.whiteColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(1),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        space(height: 15, width: 0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Text(
                                    widget.service.category,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Text(
                                    widget.service.name,
                                    style: const TextStyle(
                                      color: ShineColors.titleColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 2),
                                      child: Text(
                                        "\$ $reservationFee",
                                        style: const TextStyle(
                                          color: ShineColors.lightGrey,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "Dur. ${widget.times.length} hr 00 min",
                                      style: TextStyle(
                                        color: ShineColors.lightGrey,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: CustomButton(
                                  label: "Pay",
                                  active: buttonActive,
                                  onTap: () async {
                                    if (buttonActive != true) {
                                      setState(() {
                                        buttonActive = true;
                                      });

                                      await makePayment();
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget textIcon(IconData iconData, String text) {
    return Row(
      children: [
        Icon(iconData, color: ShineColors.iconColor),
        space(height: 0, width: 10),
        Text(
          text,
          style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: ShineColors.iconColor),
        ),
      ],
    );
  }

  Future<void> makePayment() async {
    try {
      // Create payment intent data
      paymentIntent =
          await createPaymentIntent(reservationFee.toString(), 'USD');
      if (paymentIntent == null) {
        return;
      }

      // Initialise the payment sheet setup
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Client secret key from payment data
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          googlePay: const PaymentSheetGooglePay(
            buttonType: PlatformButtonType.book,
            testEnv: true,
            currencyCode: "USD",
            merchantCountryCode: "US",
          ),
          merchantDisplayName: 'Flutterwings',
        ),
      );

      // Display payment sheet
      await displayPaymentSheet();
    } catch (e) {
      if (e is StripeException) {
        toastWidget(context, Colors.red, "${e.error.localizedMessage}");
      } else {
        toastWidget(
            context, Colors.red, "An error occurred. Please try again.");
      }
      setState(() {
        buttonActive = false;
      });
    }
  }

  Future<void> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      toastWidget(context, Colors.blue, "Paid successfully");
      final userAsyncValue = ref.watch(userDetailsProvider);

      userAsyncValue.when(
        data: (appUser) {
          username = "${appUser?.firstName}";
          ref.read(postBookingInfoProvider.notifier).bookingInfo(
              serviceName: widget.service.name,
              date: date,
              time: widget.times,
              userName: "${appUser?.firstName}",
              paymentConfirmation: paymentIntent?['id'],
              email: appUser?.email ?? "",
              imagePath: widget.image,
              amount: reservationFee ?? 0,
              fullAmount: widget.service.price,
              createdBy: username ?? '',
              category: widget.service.category);
        },
        loading: () => null,
        error: (error, stackTrace) => null,
      );
      paymentIntent = null;
    } on StripeException catch (e) {
      print('StripeException in paymentIntent: ${e.error.localizedMessage}');
      setState(() {
        buttonActive = false;
      });
      toastWidget(context, Colors.red, "Payment Cancelled");
    } catch (e) {
      print('Error in displayPaymentSheet: $e');
      setState(() {
        buttonActive = false;
      });
    }
  }

  Future<Map<String, dynamic>?> createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': ((int.parse(amount)) * 100).toString(),
        'currency': currency,
        'payment_method_types[]': 'card',
      };

      var secretKey =
          "sk_test_51PYI46RqlQgUwELCrhx9OYu7xt2kAeF8C5yNJhGFnYyH6X5qKqVCTHB1Juv3DIyRaTOhs5qabXkk9WMTts4z5MPX0093SbisGu";
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );

      print('Payment Intent Body: ${response.body}');
      return jsonDecode(response.body);
    } catch (err) {
      print('Error charging user: $err');
      return null;
    }
  }
}
