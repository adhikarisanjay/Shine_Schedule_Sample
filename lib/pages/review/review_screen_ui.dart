import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shine_schedule/config/router/route_names.dart';
import 'package:shine_schedule/pages/home/provider/review_fetch_provider.dart';
import 'package:shine_schedule/pages/review/provider/review_provider.dart';
import 'package:shine_schedule/utils/colors.dart';
import 'package:shine_schedule/widgets/appbar.dart';
import 'package:shine_schedule/widgets/custom_button.dart';
import 'package:shine_schedule/widgets/sizedbox.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:shine_schedule/pages/booking_details/provider/fetch_booking_details.dart';
import 'package:shine_schedule/widgets/toast.dart';

class ReviewScreen extends ConsumerStatefulWidget {
  const ReviewScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends ConsumerState<ReviewScreen> {
  String? serviceValue;
  double rating = 3.5;
  int starCount = 5;
  final description = TextEditingController();
  bool buttonActive = true;

  @override
  void initState() {
    super.initState();
  }

  void submitReview() async {
    if (serviceValue != null && description.text.isNotEmpty) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          buttonActive = false;
        });
        await ref.read(reviewServiceProvider.notifier).postReview(
              serviceName: serviceValue!,
              rating: rating,
              reviewDescription: description.text,
              userName: user.displayName ?? 'Anonymous',
              email: user.email ?? 'No email',
            );
      } else {
        toastWidget(context, Colors.red, 'User not signed in');
      }
    } else {
      toastWidget(context, Colors.red, 'Please complete all fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingDetailsAsyncValue = ref.watch(fetchBookingDetailsProvider);

    ref.listen<AsyncValue<String?>>(reviewServiceProvider, (previous, next) {
      if (next.hasError) {
        setState(() {
          buttonActive = true;
        });
        toastWidget(context, Colors.red, next.error.toString());
      } else if (next.hasValue) {
        setState(() {
          buttonActive = true;
        });
        ref.read(fetchReviewsProvider.notifier).fetchReviews();

        GoRouter.of(context).pushReplacementNamed(RouteNames.home);

        toastWidget(context, Colors.blue, next.value.toString());
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Align(
                alignment: Alignment.center,
                child: Text(
                  "What is your rate",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                ),
              ),
              space(height: 10, width: 0),
              Center(
                child: StarRating(
                  size: 40.0,
                  rating: rating,
                  color: Colors.orange,
                  borderColor: Colors.grey,
                  allowHalfRating: true,
                  starCount: starCount,
                  onRatingChanged: (rating) => setState(() {
                    this.rating = rating;
                  }),
                ),
              ),
              space(height: 10, width: 0),
              const Align(
                child: Text(
                  "Services you took",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                height: 60,
                child: bookingDetailsAsyncValue.when(
                  data: (bookings) {
                    if (bookings == null || bookings.isEmpty) {
                      return const Center(child: Text('No services found'));
                    }

                    final services =
                        bookings.map((b) => b.serviceName).toSet().toList();

                    return
                     DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(8),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0.0),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(0),
                          gapPadding: 4,
                        ),
                      ),
                      hint: const Text('Select a service'),
                      value: serviceValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          serviceValue = newValue!;
                        });
                      },
                      items: services
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) =>
                      Center(child: Text('Error: $error')),
                ),
              ),
              space(height: 10, width: 0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  maxLines: 10,
                  decoration: const InputDecoration(
                    hintText: "What is your opinion about our service?",
                    hintStyle: TextStyle(color: ShineColors.textColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                    labelStyle: TextStyle(color: ShineColors.appMainColor),
                  ),
                  controller: description,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Empty value";
                    }
                    return null;
                  },
                ),
              ),
              space(height: 10, width: 0),
              CustomButton(
                label: "Submit",
                onTap: buttonActive ? submitReview : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
