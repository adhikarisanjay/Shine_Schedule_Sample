import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'review_provider.g.dart';

@riverpod
class ReviewService extends _$ReviewService {
  bool isSignedIn = false;

  @override
  FutureOr<String?> build() {
    return null;
  }

  Future<String?> postReview({
    required String serviceName,
    required double rating,
    required String reviewDescription,
    required String userName,
    required String email,
  }) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      await firestore.collection('reviews').add({
        'serviceName': serviceName,
        'rating': rating,
        'reviewDescription': reviewDescription,
        'userName': userName,
        'email': email,
        'timestamp': FieldValue.serverTimestamp(),
      });

      state = const AsyncValue.data('Review successfully posted');
      return 'Review successfully posted';
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
      return e.toString();
    }
  }
}
