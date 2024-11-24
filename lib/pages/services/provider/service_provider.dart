import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shine_schedule/common_model.dart/business_model.dart';
import 'package:shine_schedule/common_model.dart/service_categories_model.dart';
import 'package:shine_schedule/common_model.dart/services_model.dart';
import 'package:shine_schedule/config/network.dart';
import 'package:shine_schedule/utils/constant.dart';

part 'service_provider.g.dart';

class BusinessServices {
  BusinessModel business;
  List<ServiceCategoriesModel> categories;

  BusinessServices({required this.business, required this.categories});
}

@riverpod
class ServicesActivity extends _$ServicesActivity {
  bool isSignedIn = false;

  @override
  FutureOr<BusinessServices?> build(String businessName) async {
    return fetchBusinessServices(businessName: businessName);
  }

  Future<BusinessServices?> fetchBusinessServices(
      {required String businessName}) async {
    try {
      final firestore = FirebaseFirestore.instance;
      BusinessServices businessServices = BusinessServices(
          business: BusinessModel(name: businessName), categories: []);

      QuerySnapshot result = await firestore
          .collection("business")
          .where("name", isEqualTo: businessName)
          .limit(1)
          .get();

      if (result.docs.isNotEmpty) {
        DocumentSnapshot businessDoc = result.docs.first;

        // Check if the document exists
        if (businessDoc.exists) {
          // Fetch the categories collection within the business document
          QuerySnapshot categoriesSnapshot =
              await businessDoc.reference.collection("serviceCategories").get();

          for (DocumentSnapshot categoryDoc in categoriesSnapshot.docs) {
            // Fetch the services collection within the category document
            QuerySnapshot servicesSnapshot = await categoryDoc.reference
                .collection("services")
                .orderBy("name")
                .get();

            List<ServicesModel> services = servicesSnapshot.docs
                .map((doc) =>
                    ServicesModel.fromJson(doc.data()! as Map<String, dynamic>))
                .toList();

            ServiceCategoriesModel category = ServiceCategoriesModel(
                name: categoryDoc.get("name"), services: services);

            businessServices.categories.add(category);
          }
        }
      }
      return businessServices;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return null;
    }
  }

  Future<void> fetchServices(String businessName) async {
    if (!await NetworkUtil.isConnected()) {
      state = AsyncValue.error(Constant.networkError, StackTrace.current);
    }
    state = const AsyncLoading();

    try {
      state = AsyncValue.data(
          await fetchBusinessServices(businessName: businessName));
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
