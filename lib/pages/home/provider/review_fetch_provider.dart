import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shine_schedule/pages/review/model/review_model.dart';

part 'review_fetch_provider.g.dart';

@riverpod
class FetchReviews extends _$FetchReviews {
  @override
  FutureOr<List<ReviewModel>?> build() {
    return fetchReviews();
  }

  Future<List<ReviewModel>?> fetchReviews() async {
    final firestore = FirebaseFirestore.instance;
    try {
      final reviewsCollection = await firestore.collection('reviews').get();

      List<ReviewModel> reviews = reviewsCollection.docs.map((doc) {
        return ReviewModel.fromJson(doc.data());
      }).toList();

      state = AsyncValue.data(reviews);
      return reviews;
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
      return null;
    }
  }
}
