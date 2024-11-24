import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

part 'email_provider.g.dart';

@riverpod
class SendEmail extends _$SendEmail {
  @override
  FutureOr<String?> build() {
    return null;
  }

  Future<String?> sendEmail(
      {required String receiverEmail,
      required String userName,
      required String serviceName,
      required String date,
      required List<dynamic> time,
      required double amount,
      bool? updated}) async {
    try {
      // Sort the times in ascending order
      time.sort((a, b) {
        DateTime timeA =
            (a is Timestamp) ? a.toDate() : DateFormat.jm().parse(a);
        DateTime timeB =
            (b is Timestamp) ? b.toDate() : DateFormat.jm().parse(b);
        return timeA.compareTo(timeB);
      });

      // Format times as strings
      List<String> formattedTimes = time.map((t) {
        DateTime dateTime =
            (t is Timestamp) ? t.toDate() : DateFormat.jm().parse(t);
        return DateFormat.jm().format(dateTime);
      }).toList();

      // Create the email content
      final emailContent = """
      <html>
        <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
          <div style="max-width: 600px; margin: auto; padding: 20px; border: 1px solid #ddd; border-radius: 10px; background-color: #f9f9f9;">
            <h2 style="color: #333; text-align: center;">Greetings $userName,</h2>
            <p style="font-size: 16px;">${updated == true ? 'Your appointment date has changed. Please check bellow details' : "Your appointment booking is successful"}.</p>
            <table style="width: 100%; border-collapse: collapse; margin-top: 20px;">
              <tr>
                <td style="padding: 12px; border: 1px solid #ddd; background-color: #f2f2f2; font-weight: bold;">Service Name:</td>
                <td style="padding: 12px; border: 1px solid #ddd;">$serviceName</td>
              </tr>
              <tr>
                <td style="padding: 12px; border: 1px solid #ddd; background-color: #f2f2f2; font-weight: bold;">Date:</td>
                <td style="padding: 12px; border: 1px solid #ddd;">$date</td>
              </tr>
              <tr>
                <td style="padding: 12px; border: 1px solid #ddd; background-color: #f2f2f2; font-weight: bold;">Time:</td>
                <td style="padding: 12px; border: 1px solid #ddd;">${formattedTimes.join(', ')}</td>
              </tr>
            </table>
            <p style="font-size: 16px; margin-top: 20px;">Thank you for choosing our service. We look forward to seeing you!</p>
            <p style="font-size: 16px;">Best regards,</p>
            <p style="font-size: 16px; font-weight: bold;">Shine Schedule</p>
          </div>
        </body>
      </html>
      """;

      await FirebaseFirestore.instance.collection('mail').add({
        'to': receiverEmail,
        'message': {
          'subject': updated == true
              ? "Your appointment date has changed"
              : "Appointment booked successfully",
          'html': emailContent
        }, // Assuming the extension expects 'html' key for HTML messages
      });

      // Optionally, show success message or navigate to a success screen
      state = const AsyncValue.data('Please check your email');
      return 'Please check your email';
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
      return e.toString();
    }
  }
}
