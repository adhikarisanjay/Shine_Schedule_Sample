import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shine_schedule/commonProvider/userdetaiils_Provider.dart';
import 'package:shine_schedule/config/router/route_names.dart';
import 'package:shine_schedule/pages/booking/provider/fetch_dates.dart';
import 'package:shine_schedule/pages/booking_details/model/booking_details.dart';
import 'package:shine_schedule/pages/booking_details/provider/fetch_booking_details.dart';
import 'package:shine_schedule/pages/edit_appointments/provider/update_appointment_provider.dart';
import 'package:shine_schedule/payment/provider/email_provider.dart';
import 'package:shine_schedule/utils/colors.dart';
import 'package:shine_schedule/widgets/appbar.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:shine_schedule/widgets/custom_button.dart';
import 'package:shine_schedule/widgets/sizedbox.dart';
import 'package:shine_schedule/widgets/toast.dart';

class BookingEditScreen extends ConsumerStatefulWidget {
  const BookingEditScreen({super.key, required this.bookingDetails});

  final BookingDetails bookingDetails;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BookingEditScreenState();
}

class _BookingEditScreenState extends ConsumerState<BookingEditScreen> {
  bool buttonActive = false;
  List<bool> selectedButtons = [];
  String? selectedDate;
  List<String> selectedTime = [];
  List<String> timeList = [];

  @override
  void initState() {
    super.initState();
    String formattedDate =
        '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';
    setState(() {
      ref.read(fetchDatesProvider.notifier).fetchDates();
      selectedDate = formattedDate;
      _initializeData();
    });
  }

  void onDateSelected(DateTime value) {
    DateTime now = DateTime.now();
    DateTime selectedDateOnly = DateTime(value.year, value.month, value.day);
    DateTime todayDateOnly = DateTime(now.year, now.month, now.day);

    if (selectedDateOnly.isBefore(todayDateOnly)) {
      timeList = [];
      toastWidget(context, Colors.red, "Past dates are not selectable");
    } else {
      String formattedDate =
          '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';

      List<String> allTimes =
          ref.read(fetchDatesProvider).asData?.value?[formattedDate] ?? [];

      if (selectedDateOnly == todayDateOnly) {
        // Filter out past times
        timeList = allTimes.where((time) {
          DateTime timeDateTime = DateTime(value.year, value.month, value.day,
              int.parse(time.split(":")[0]), int.parse(time.split(":")[1]));
          return timeDateTime.isAfter(now);
        }).toList();
      } else {
        timeList = allTimes;
      }

      setState(() {
        selectedDate = formattedDate;
        selectedButtons = List.generate(timeList.length, (index) => false);
      });
    }
  }

  Widget mobileDesign() {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: Calendar(
                startOnMonday: true,
                weekDays: const [
                  'Mon',
                  'Tue',
                  'Wed',
                  'Thu',
                  'Fri',
                  'Sat',
                  'Sun'
                ],
                onDateSelected: onDateSelected,
                isExpandable: true,
                eventDoneColor: Colors.green,
                selectedColor: ShineColors.appMainColor,
                selectedTodayColor: ShineColors.appMainColor,
                todayColor: ShineColors.appMainColor,
                eventColor: null,
                bottomBarColor: Colors.transparent,
                bottomBarTextStyle: const TextStyle(
                    fontSize: 18,
                    color: ShineColors.titleColor,
                    fontWeight: FontWeight.w500),
                locale: 'en_US',
                todayButtonText: 'Today',
                multiDayEndText: 'End',
                isExpanded: true,
                expandableDateFormat: 'EEEE, dd. MMMM yyyy',
                datePickerType: DatePickerType.date,
                dayOfWeekStyle: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                dayBuilder: (context, day) {
                  bool isBeforeToday = day.isBefore(DateTime.now());
                  bool isSelected = selectedDate ==
                      '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
                  bool isToday = day.day == DateTime.now().day &&
                      day.month == DateTime.now().month &&
                      day.year == DateTime.now().year;
                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? ShineColors.appMainColor
                          : isToday
                              ? ShineColors.appMainColor.withOpacity(0.5)
                              : isBeforeToday
                                  ? Colors.grey.withOpacity(0.5)
                                  : null,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: TextStyle(
                          color: isSelected || isToday || isBeforeToday
                              ? ShineColors.whiteColor
                              : ShineColors.titleColor,
                        ),
                      ),
                    ),
                  );
                },
                eventListBuilder: (context, eventList) {
                  return Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(20),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 20,
                      ),
                      itemCount: timeList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _buildEventButton(index, timeList[index]);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
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
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Text(
                              widget.bookingDetails.serviceName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 2),
                                child: Text(
                                  "\$${widget.bookingDetails.amount}",
                                  style: const TextStyle(
                                      color: ShineColors.lightGrey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              Text(
                                "Dur. ${selectedTime.length} hr 00 min",
                                style: const TextStyle(
                                    color: ShineColors.lightGrey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          )
                        ],
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: CustomButton(
                            label: "Checkout",
                            onTap: () {
                              if (selectedDate == "" || selectedTime.isEmpty) {
                                toastWidget(context, Colors.red,
                                    "Please select date and time before checkout!");
                              } else {
                                setState(() {
                                  buttonActive = true;
                                });
                                ref
                                    .read(
                                        updateBookingProviderProvider.notifier)
                                    .updateBookingDetails(
                                      bookingId: widget.bookingDetails.id,
                                      newDate: selectedDate!,
                                      newTimes: selectedTime,
                                    );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget webDesign() {
    return SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Center(
              child: SizedBox(
                width: 700,
                child: Card(
                  child: Column(
                    children: [
                      space(height: 50, width: 0),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 1,
                        width: MediaQuery.of(context).size.width * 1,
                        child: Calendar(
                          startOnMonday: true,
                          weekDays: const [
                            'Mon',
                            'Tue',
                            'Wed',
                            'Thu',
                            'Fri',
                            'Sat',
                            'Sun'
                          ],
                          onDateSelected: onDateSelected,
                          isExpandable: true,
                          eventDoneColor: Colors.green,
                          selectedColor: ShineColors.appMainColor,
                          selectedTodayColor: ShineColors.appMainColor,
                          todayColor: ShineColors.appMainColor,
                          eventColor: null,
                          bottomBarColor: Colors.transparent,
                          bottomBarTextStyle: const TextStyle(
                              fontSize: 18,
                              color: ShineColors.titleColor,
                              fontWeight: FontWeight.w500),
                          locale: 'en_US',
                          todayButtonText: 'Today',
                          multiDayEndText: 'End',
                          isExpanded: true,
                          expandableDateFormat: 'EEEE, dd. MMMM yyyy',
                          datePickerType: DatePickerType.date,
                          dayOfWeekStyle: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                          dayBuilder: (context, day) {
                            bool isBeforeToday = day.isBefore(DateTime.now());
                            bool isSelected = selectedDate ==
                                '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
                            bool isToday = day.day == DateTime.now().day &&
                                day.month == DateTime.now().month &&
                                day.year == DateTime.now().year;
                            return Container(
                              margin: const EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? ShineColors.appMainColor
                                    : isToday
                                        ? ShineColors.appMainColor
                                            .withOpacity(0.5)
                                        : isBeforeToday
                                            ? ShineColors.backgroundGrey
                                            : null,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Center(
                                child: Text(
                                  '${day.day}',
                                  style: TextStyle(
                                    color:
                                        isSelected || isToday || isBeforeToday
                                            ? ShineColors.whiteColor
                                            : ShineColors.titleColor,
                                  ),
                                ),
                              ),
                            );
                          },
                          eventListBuilder: (context, eventList) {
                            return Expanded(
                              child: GridView.builder(
                                padding: const EdgeInsets.all(10),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  childAspectRatio: 4,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20,
                                ),
                                itemCount: timeList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return _buildEventButton(
                                      index, timeList[index]);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.1,
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
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Eyelash Extension",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Text(
                                "American Volume Full Set",
                                style: TextStyle(
                                    color: ShineColors.titleColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 2),
                                  child: Text(
                                    "\$120.00",
                                    style: TextStyle(
                                        color: ShineColors.lightGrey,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Text(
                                  "Dur. 2 hr 00 min",
                                  style: TextStyle(
                                      color: ShineColors.lightGrey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            )
                          ],
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: CustomButton(
                              label: "Checkout",
                              onTap: () {
                                if (selectedDate == "" ||
                                    selectedTime.isEmpty) {
                                  toastWidget(context, Colors.red,
                                      "Please select date and time before checkout!");
                                } else {
                                  setState(() {
                                    buttonActive = true;
                                  });
                                  ref
                                      .read(updateBookingProviderProvider
                                          .notifier)
                                      .updateBookingDetails(
                                        bookingId: widget.bookingDetails.id,
                                        newDate: selectedDate!,
                                        newTimes: selectedTime,
                                      );
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _initializeData() async {
    DateTime now = DateTime.now();
    String formattedDate =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    setState(() {
      selectedDate = formattedDate;
    });

    // Ensure data is fetched before updating the state
    await ref.read(fetchDatesProvider.notifier).fetchDates();

    // After fetching dates, set today's times
    onDateSelected(now);
  }

  Widget _buildEventButton(int index, String time) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 50,
      ),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor:
              selectedButtons[index] ? ShineColors.appMainColor : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          side: const BorderSide(
            color: ShineColors.lightGrey,
          ),
        ),
        onPressed: () {
          setState(() {
            selectedButtons = List.generate(timeList.length, (i) => false);
            selectedButtons[index] = !selectedButtons[index];
            selectedTime = selectedButtons[index] ? [time] : [];
          });
        },
        child: Text(
          time,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selectedButtons[index]
                ? ShineColors.whiteColor
                : ShineColors.titleColor,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final datesAsyncValue = ref.watch(fetchDatesProvider);
    final userAsyncValue = ref.watch(userDetailsProvider);

    ref.listen<AsyncValue<String?>>(updateBookingProviderProvider,
        (previous, next) {
      if (next.hasError) {
        setState(() {
          buttonActive = false;
        });
        toastWidget(context, Colors.red, next.error.toString());
      } else if (next.value != null) {
        setState(() {
          buttonActive = false;
        });

        ref.read(fetchBookingDetailsProvider.notifier).fetchDetails();

        toastWidget(context, Colors.blue, next.value.toString());

        ref.read(sendEmailProvider.notifier).sendEmail(
            receiverEmail: widget.bookingDetails.email,
            userName: widget.bookingDetails.userName,
            serviceName: widget.bookingDetails.serviceName,
            date: selectedDate ?? '',
            updated: true,
            time: selectedTime,
            amount: widget.bookingDetails.amount.toDouble());
        GoRouter.of(context).pushReplacementNamed(RouteNames.home);
      }
    });

    return Scaffold(
      backgroundColor: ShineColors.background,
      appBar: CustomAppBar(
        isShowLeftIcon: true,
        pressedLeftIcon: () {
          GoRouter.of(context).pop();
        },
        leftIcon: const Icon(
          Icons.arrow_back_ios,
          size: 25,
          color: ShineColors.whiteColor,
        ),
      ),
      body: datesAsyncValue.when(
        data: (datesMap) => LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 480) {
              return webDesign();
            } else {
              return mobileDesign();
            }
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
