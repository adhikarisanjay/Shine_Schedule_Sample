import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shine_schedule/commonProvider/userdetaiils_Provider.dart';
import 'package:shine_schedule/config/router/messaging.dart';
import 'package:shine_schedule/config/router/route_names.dart';
import 'package:shine_schedule/pages/home/provider/review_fetch_provider.dart';
import 'package:shine_schedule/pages/review/model/review_model.dart';
import 'package:shine_schedule/utils/assets.dart';
import 'package:shine_schedule/utils/colors.dart';
import 'package:shine_schedule/widgets/appbar.dart';
import 'package:shine_schedule/widgets/drawer.dart';
import 'package:shine_schedule/widgets/sizedbox.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:rating_summary/rating_summary.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  final CarouselController _controller = CarouselController();
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final MessagingService _messagingService = MessagingService();

  @override
  void initState() {
    super.initState();
    getToken();
    _messagingService.initialize();
  }

  void getToken() {
    if (Platform.isAndroid) {
      FirebaseMessaging.instance.getToken().then((value) {
        if (value != null) {
          ref.read(userDetailsProvider.notifier).updateDeviceToken(value);
        }
      });
    }
    if (Platform.isIOS) {
      FirebaseMessaging.instance.getAPNSToken().then((apnsToken) {
        if (apnsToken != null) {
          ref.read(userDetailsProvider.notifier).updateDeviceToken(apnsToken);
          // You can handle the APNs token here
        }
      });
    }
  }

  double calculateAverageRating(List<ReviewModel> reviews) {
    if (reviews.isEmpty) return 0.0;
    double sum = reviews.map((r) => r.rating).reduce((a, b) => a + b);
    return sum / reviews.length;
  }

  Map<int, int> calculateStarDistribution(List<ReviewModel> reviews) {
    Map<int, int> distribution = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (var review in reviews) {
      int rating = review.rating.toInt();
      if (distribution.containsKey(rating)) {
        distribution[rating] = distribution[rating]! + 1;
      }
    }
    return distribution;
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userDetailsProvider);
    final reviewsAsyncValue = ref.watch(fetchReviewsProvider);
    final size = MediaQuery.of(context).size;
    final isPortrait = size.height > size.width;

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: DrawerWidget(),
      backgroundColor: ShineColors.background,
      appBar: CustomAppBar(
        isShowActionIcon3: true,
        pressedLeftIcon: () {
          GoRouter.of(context).pop();
        },
        pressedActionIcon3: () {
          _scaffoldKey.currentState?.openEndDrawer();
        },
        actionIcon3: const Icon(
          Icons.menu,
          color: Colors.white,
        ),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: SingleChildScrollView(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double width = constraints.maxWidth;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      space(height: 10, width: 0),
                      Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                "Welcome back, ",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 16),
                              ),
                              user.when(
                                  data: (appUser) => Text(
                                        "${appUser?.firstName}!",
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16),
                                      ),
                                  error: (object, stackTrace) => const Text(""),
                                  loading: () => const Text("........")),
                              space(height: 0, width: 10)
                            ],
                          )),
                      space(height: 10, width: 0),
                      Image.asset(
                        filterQuality: FilterQuality.high,
                        Assets.banner,
                        width: width,
                        fit: BoxFit.fill,
                      ),
                      space(height: 20, width: 0),
                      const Text(
                        "Categories",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Color.fromARGB(255, 51, 51, 51)),
                      ),
                      space(height: 10, width: 0),
                      Column(
                        children: [
                          CarouselSlider(
                            items: [
                              categorySliderCard(
                                  width, "Eyebrow", Assets.eybrowCat),
                              categorySliderCard(width, "Eyelash Extension",
                                  Assets.eyeLashCategory),
                              categorySliderCard(
                                  width, "Natural Lips", Assets.lipsCategory),
                              categorySliderCard(
                                  width, "Makeup", Assets.makeupCategory),
                            ],
                            carouselController: _controller,
                            options: CarouselOptions(
                              reverse: false,
                              height: isPortrait ? 170.0 : 120.0,
                              enlargeCenterPage: false,
                              autoPlay: false,
                              aspectRatio: 1,
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enableInfiniteScroll: true,
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 800),
                              viewportFraction: isPortrait ? 0.46 : 0.3,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _currentIndex = index;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          AnimatedSmoothIndicator(
                            activeIndex: _currentIndex,
                            count: 4,
                            effect: const ScrollingDotsEffect(
                              activeDotColor: ShineColors.appMainColor,
                              dotColor: Colors.grey,
                              dotHeight: 8.0,
                              dotWidth: 8.0,
                            ),
                            onDotClicked: (index) {
                              _controller.animateToPage(index);
                            },
                          ),
                        ],
                      ),
                      space(height: 20, width: 0),
                      const Text(
                        "Photo Gallery ",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Color.fromARGB(255, 51, 51, 51)),
                      ),
                      space(height: 20, width: 0),
                      Column(
                        children: [
                          CarouselSlider(
                            items: [
                              imageSlider(Assets.rectangleOne),
                              imageSlider(Assets.rectangleTwo),
                              imageSlider(Assets.rectangleThree),
                              imageSlider(Assets.eybrowCat),
                              imageSlider(Assets.lipsCategory),
                              imageSlider(Assets.eyelashImage),
                              imageSlider(Assets.slider5),
                            ],
                            carouselController: _controller,
                            options: CarouselOptions(
                              reverse: false,
                              height: isPortrait ? 200.0 : 120.0,
                              enlargeCenterPage: true,
                              autoPlay: true,
                              autoPlayCurve: Curves.slowMiddle,
                              enableInfiniteScroll: true,
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 400),
                              viewportFraction: isPortrait ? 0.35 : 0.2,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _currentIndex = index;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          AnimatedSmoothIndicator(
                            activeIndex: _currentIndex,
                            count: 4,
                            effect: const ScrollingDotsEffect(
                              activeDotColor: ShineColors.appMainColor,
                              dotColor: Colors.grey,
                              dotHeight: 8.0,
                              dotWidth: 8.0,
                            ),
                            onDotClicked: (index) {
                              _controller.animateToPage(index);
                            },
                          ),
                        ],
                      ),
                      space(height: 10, width: 0),
                      const Text(
                        "Reviews",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Color.fromARGB(255, 51, 51, 51)),
                      ),
                      space(height: 10, width: 0),
                      reviewsAsyncValue.when(
                        data: (reviews) {
                          if (reviews == null || reviews.isEmpty) {
                            return const Text("No reviews available");
                          }

                          double averageRating =
                              calculateAverageRating(reviews);
                          Map<int, int> starDistribution =
                              calculateStarDistribution(reviews);

                          return Column(
                            children: [
                              RatingSummary(
                                counter: reviews.length,
                                average: averageRating,
                                showAverage: true,
                                counterFiveStars: starDistribution[5] ?? 0,
                                counterFourStars: starDistribution[4] ?? 0,
                                counterThreeStars: starDistribution[3] ?? 0,
                                counterTwoStars: starDistribution[2] ?? 0,
                                counterOneStars: starDistribution[1] ?? 0,
                              ),
                              ...reviews
                                  .map((review) => reviewCard(context, review))
                                  .toList(),
                            ],
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (error, stackTrace) =>
                            Center(child: Text('Error: $error')),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget categorySliderCard(double width, String name, String image) {
    return GestureDetector(
      onTap: () {
        DateTime today = DateTime.now();
        List<String> times = ['18:00PM', '11:00PM', '17:00PM'];
        GoRouter.of(context).pushNamed(RouteNames.services, pathParameters: {
          'catName': name,
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            SizedBox(
              width: width * 0.4,
              height: MediaQuery.of(context).size.height * 0.4,
              child: Card(
                color: Colors.white,
                elevation: 5,
                child: Column(
                  children: [
                    Container(
                        width: width,
                        height: 90,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(image),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                              bottomLeft: Radius.circular(50),
                            ))),
                    space(height: 10, width: 0),
                    Text(
                      name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 14),
                    ),
                    space(height: 5, width: 0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget imageSlider(String image) {
    return Container(
        width: 400,
        height: 500,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
            ),
          ],
        ),
        child: Image.asset(
          filterQuality: FilterQuality.high,
          image,
          fit: BoxFit.fitHeight,
        ));
  }

  Widget reviewCard(BuildContext context, ReviewModel review) {
    return Stack(
      children: <Widget>[
        Card(
          margin: const EdgeInsets.only(top: 20.0, bottom: 20),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 45.0), // Space for the avatar
                  Text(
                    review.userName,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    review.serviceName,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        5,
                        (index) => Icon(
                          index < review.rating
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      review.reviewDescription,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                  ),
                  space(height: 10, width: 0),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: .0,
          left: .0,
          right: .0,
          child: Center(
            child: CircleAvatar(
              radius: 30.0,
              child: Text(review.userName[0]),
            ),
          ),
        )
      ],
    );
  }
}
