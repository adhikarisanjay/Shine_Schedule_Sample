import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

part 'fetch_dates.g.dart';

@riverpod
class FetchDates extends _$FetchDates {
  FutureOr<Map<String, List<String>>?> build() {
    return fetchDates();
  }

  Future<Map<String, List<String>>?> fetchDates() async {
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;
    final user = auth.currentUser;
    if (user != null) {
      try {
        final datesCollection = await firestore.collection('dates').get();
        Map<String, List<String>> datesMap = {};
        for (var doc in datesCollection.docs) {
          List<dynamic> times = doc.get('times');
          List<String> formattedTimes = times.map((timestamp) {
            DateTime dateTime = (timestamp as Timestamp).toDate();
            return DateFormat.jm()
                .format(dateTime); // Convert to desired format
          }).toList();
          datesMap[doc.id] = formattedTimes;
        }
        state = AsyncValue.data(datesMap);
        return datesMap;
      } catch (e) {
        state = AsyncValue.error(e.toString(), StackTrace.current);
        return null;
      }
    }
    return null;
  }
}
