import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shine_schedule/config/router/route_names.dart';
import 'package:shine_schedule/pages/booking_details/model/booking_details.dart';
import 'package:shine_schedule/pages/booking_details/provider/cancel_booking.dart';
import 'package:shine_schedule/pages/booking_details/provider/fetch_booking_details.dart';
import 'package:shine_schedule/utils/assets.dart';
import 'package:shine_schedule/utils/colors.dart';
import 'package:shine_schedule/utils/constant.dart';
import 'package:shine_schedule/widgets/appbar.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shine_schedule/widgets/custom_button.dart';
import 'package:shine_schedule/widgets/networkerror.dart';
import 'package:shine_schedule/widgets/toast.dart';

class BookingScreenUI extends ConsumerStatefulWidget {
  const BookingScreenUI({Key? key}) : super(key: key);

  @override
  _BookingScreenUIState createState() => _BookingScreenUIState();
}

class _BookingScreenUIState extends ConsumerState<BookingScreenUI> {
  String filter = 'Upcoming';
  bool networkError = false;
  List<BookingDetails> filterBookings(List<BookingDetails> bookings) {
    final now = DateTime.now();
    switch (filter) {
      case 'Upcoming':
        return bookings
            .where((booking) =>
                booking.date.toDate().isAfter(now) &&
                booking.status == "Confirmed")
            .toList();
      case 'All':
        return bookings;
      default:
        return bookings.where((booking) => booking.status == filter).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingDetailsAsyncValue = ref.watch(fetchBookingDetailsProvider);
    ref.listen<AsyncValue<List<BookingDetails>?>>(fetchBookingDetailsProvider,
        (previous, next) {
      if (next.hasError) {
        if (next.error.toString() == Constant.networkError) {
          setState(() {
            networkError = true;
          });
        }
        toastWidget(context, Colors.red, next.error.toString());
      } else if (next.value != null) {
        setState(() {
          networkError = false;
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter by:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                DropdownButton<String>(
                  value: filter,
                  onChanged: (String? newValue) {
                    setState(() {
                      filter = newValue!;
                    });
                  },
                  items: <String>['Upcoming', 'Past', 'Cancelled', 'All']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Expanded(
            child: bookingDetailsAsyncValue.when(
              data: (bookings) {
                if (networkError == true) {
                  return NetworkErrorWidget(
                    image: Assets.notFound,
                    text: Constant.networkError,
                    onRetry: () {
                      ref.refresh(fetchBookingDetailsProvider.notifier);
                    },
                  );
                } else if (bookings == null || bookings.isEmpty) {
                  return NetworkErrorWidget(
                    image: Assets.notFound,
                    text: "No booking data available",
                    onRetry: () {
                      ref.refresh(fetchBookingDetailsProvider.notifier);
                    },
                  );
                } else {
                  final filteredBookings = filterBookings(bookings);
                  if (filteredBookings.isEmpty) {
                    return NetworkErrorWidget(
                      image: Assets.notFound,
                      text: "No booking data available",
                      onRetry: () {
                        ref.refresh(fetchBookingDetailsProvider.notifier);
                      },
                    );
                  }
                  return ListView.builder(
                    itemCount: filteredBookings.length,
                    itemBuilder: (context, index) {
                      final booking = filteredBookings[index];
                      return BookingTile(booking: booking);
                    },
                  );
                }
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Error: $error \n '),
                    CustomButton(
                      label: 'Retry',
                      onTap: () {
                        // Trigger a retry by refetching the data
                        ref.refresh(fetchBookingDetailsProvider);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BookingTile extends ConsumerWidget {
  final BookingDetails booking;

  const BookingTile({Key? key, required this.booking}) : super(key: key);

  void _showCancellationPolicyDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancellation Policy for Gior'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'At Gior Studio, we understand that plans can change. To ensure a smooth experience for all our clients and beauty professionals, we have established the following cancellation policy:',
                ),
                SizedBox(height: 10),
                Text(
                  '1. Booking Fee: When booking an appointment, a payment of 50% of the service cost is required. This payment is subject to a maximum limit of \$99, regardless of the total service cost.',
                ),
                SizedBox(height: 10),
                Text(
                  '2. No-Show Policy: If you do not show up for your appointment without prior notice, the booking fee will be forfeited.',
                ),
                SizedBox(height: 10),
                Text(
                  '3. 24-Hour Cancellation: If you cancel your appointment less than 24 hours before the scheduled time, you will be charged 30% of the service cost. The remaining amount of the booking fee will be refunded.',
                ),
                SizedBox(height: 10),
                Text(
                  '4. 48-Hour Cancellation: If you cancel your appointment more than 48 hours before the scheduled time, you will receive a full refund of the booking fee.',
                ),
                SizedBox(height: 10),
                Text(
                  'By booking an appointment with Gior, you agree to this cancellation policy. Thank you for your understanding and cooperation.',
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Proceed'),
              onPressed: () async {
                // Call the cancelBooking function
                await ref
                    .read(cancelBookingProvider.notifier)
                    .cancelBooking(booking.id);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<String?>>(cancelBookingProvider, (previous, next) {
      if (next.hasError) {
        // Show error message

        toastWidget(context, Colors.red, next.error.toString());
      } else if (next.value != null) {
        ref.read(fetchBookingDetailsProvider.notifier).fetchDetails();

        toastWidget(context, Colors.blue, next.value.toString());
        GoRouter.of(context).pushReplacementNamed(RouteNames.home);
      }
    });
    final date = DateFormat.yMMMMd().format(booking.date.toDate());
    final times =
        booking.time.map((t) => DateFormat.jm().format(t.toDate())).join(', ');

    final now = DateTime.now();
    final isPast = booking.date.toDate().isBefore(now);
    final isCancelled = booking.status == 'Cancelled';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (booking.imageUrl != null && booking.imageUrl!.isNotEmpty)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      height: 250,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Image.network(
                        booking.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Text(
                              'Image not available',
                              style: TextStyle(color: Colors.red),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Service Name: ${booking.serviceName}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: ShineColors.appMainColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Date: $date',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Time: $times',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Amount: \$${booking.amount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                        if (booking.status == 'Cancelled')
                          const Text(
                            'Status: Cancelled',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            if (booking.imageUrl == null || booking.imageUrl!.isEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Service Name: ${booking.serviceName}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: ShineColors.appMainColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Date: $date',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Time: $times',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Amount: \$${booking.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  if (booking.status == 'Cancelled')
                    const Text(
                      'Status: Cancelled',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    ),
                ],
              ),
            const SizedBox(height: 16),
            if (!isPast && !isCancelled)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    onPressed: () {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.warning,
                        text: 'Are you sure you want to modify date?',
                        confirmBtnText: 'Yes',
                        cancelBtnText: 'No',
                        confirmBtnColor: Colors.green,
                        onConfirmBtnTap: () {
                          GoRouter.of(context).pushNamed(
                              RouteNames.bookingEditUi,
                              extra: booking);
                        },
                      );
                    },
                    child: const Text(
                      'Edit',
                      style: TextStyle(
                        color: ShineColors.appMainColor,
                      ),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    onPressed: () {
                      _showCancellationPolicyDialog(context, ref);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: ShineColors.appMainColor,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
