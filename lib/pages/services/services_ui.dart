import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:shine_schedule/common_model.dart/services_model.dart';
import 'package:shine_schedule/config/router/route_names.dart';
import 'package:shine_schedule/pages/services/provider/service_provider.dart';
import 'package:shine_schedule/utils/colors.dart';
import 'package:shine_schedule/utils/constant.dart';
import 'package:shine_schedule/widgets/appbar.dart';
import 'package:shine_schedule/widgets/sizedbox.dart';
import 'package:shine_schedule/widgets/toast.dart';

final indexProvider = Provider<int>((_) {
  return 0;
});

final selectedServicesProvider = StateProvider<List<ServicesModel>>((ref) {
  return [];
});

class ServicesPage extends ConsumerStatefulWidget {
  final String categoryName;

  const ServicesPage({Key? key, required this.categoryName}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ServicesPageState();
}

class _ServicesPageState extends ConsumerState<ServicesPage> {
  String? serviceValue;
  List<String> categories = [];
  ServicesModel? service;
  List<String> professionals = ['Giovana Ramos'];
  bool networkError = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      serviceValue = professionals.first;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool cartVisible = ref.watch(selectedServicesProvider).isNotEmpty;

    // Select only the first service for now
    ServicesModel? selectedService =
        ref.watch(selectedServicesProvider).isNotEmpty
            ? ref.watch(selectedServicesProvider).first
            : null;

    return PopScope(
      child: Scaffold(
        backgroundColor: ShineColors.background,
        appBar: CustomAppBar(
          isShowLeftIcon: true,
          pressedLeftIcon: () {
            ref.read(selectedServicesProvider.notifier).state = [];
            GoRouter.of(context).pop();
          },
          pressedActionIcon3: () {},
          leftIcon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 200),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          space(height: 10, width: 0),
                          const Text(
                            "Professional",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 18),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: 60,
                            child: DropdownButtonFormField<String>(
                              isExpanded: false,
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
                              hint: const Text(''),
                              value: serviceValue,
                              onChanged: (String? newValue) {
                                setState(() {
                                  serviceValue = newValue!;
                                });
                              },
                              items: professionals
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          _ListViewCategories(
                              categoryName: widget.categoryName),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Visibility(
                visible: cartVisible,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.19,
                  decoration: BoxDecoration(
                    color: ShineColors.whiteColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
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
                            Expanded(
                              flex: 9,
                              child: IntrinsicWidth(
                                child: Column(
                                  children: [
                                    if (cartVisible && selectedService != null)
                                      serviceCardCard(
                                        ref,
                                        ref
                                            .watch(selectedServicesProvider)
                                            .first,
                                        selected: true,
                                        showDescription: false,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed: () {
                                    final data = {
                                      "service": selectedService,
                                      'image': '',
                                    };
                                    GoRouter.of(context).pushNamed(
                                      RouteNames.booking,
                                      extra: data,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(20),
                                    backgroundColor: ShineColors.appMainColor,
                                  ),
                                  child: const Text(
                                    "Book",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  ),
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
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.15,
              right:
                  MediaQuery.of(context).size.width * 0.4, // Adjust as needed
              child: Visibility(
                visible: cartVisible,
                child: SizedBox(
                    width: 75,
                    height: 75,
                    child: FittedBox(
                        child: FloatingActionButton.large(
                      onPressed: () {
                        GoRouter.of(context).pushNamed(
                          RouteNames.deepAr,
                          extra: selectedService,
                        );
                      },
                      backgroundColor: Color.fromARGB(255, 204, 76, 112),
                      shape: const CircleBorder(
                          side: BorderSide(
                              color: ShineColors.whiteColor, width: 4)),
                      elevation:
                          3, // Remove any shadow if you want complete transparency
                      child: const Text(
                        "AR \n Try-On",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w800),
                      ),
                    ))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ListViewCategories extends ConsumerWidget {
  final String categoryName;
  const _ListViewCategories({Key? key, required this.categoryName})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int listLength =
        ref.watch(servicesActivityProvider("Gior")).value?.categories.length ??
            0;

    return listLength == 0
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              space(height: MediaQuery.of(context).size.height * 0.2, width: 0),
              const Center(
                child: CircularProgressIndicator(),
              ),
            ],
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: listLength,
            itemBuilder: (_, index) {
              return ProviderScope(
                overrides: [indexProvider.overrideWith((ref) => index)],
                child: _ListCategories(categoryName: categoryName),
              );
            },
          );
  }
}

class _ListCategories extends ConsumerWidget {
  final String categoryName;
  const _ListCategories({required this.categoryName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.read(indexProvider);
    final category =
        ref.watch(servicesActivityProvider("Gior")).value!.categories[index];

    return Card(
      elevation: 0,
      color: ShineColors.whiteColor,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ExpansionTile(
          initiallyExpanded: category.name == categoryName,
          title: Text(
            category.name,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          children: [
            Column(
              children: category.services
                  .map((service) => serviceCard(ref, service, selected: false))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

Widget serviceCard(WidgetRef ref, service,
    {bool selected = false, bool showDescription = true}) {
  return Card(
    elevation: 0,
    color: ShineColors.whiteColor,
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: showDescription == false
                    ? Text(
                        service.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      )
                    : Text(
                        service.name,
                        softWrap: true,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
              ),
              Visibility(
                visible: !selected,
                child: IconButton(
                  icon: const FaIcon(
                    FontAwesomeIcons.plus,
                    size: 20,
                  ),
                  onPressed: () {
                    ref.read(selectedServicesProvider.notifier).state = [];
                    final currentState =
                        ref.read(selectedServicesProvider.notifier).state;
                    final newState = List<ServicesModel>.from(currentState)
                      ..add(service);
                    ref.read(selectedServicesProvider.notifier).state =
                        newState;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 2, width: 0),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "\$${service.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 0, width: 30),
                  const Icon(Icons.timelapse_rounded),
                  const SizedBox(height: 0, width: 2),
                  Text(
                    "Approx. ${service.duration} Mins",
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 14),
                  ),
                ],
              ),
              Visibility(
                visible: showDescription,
                child: Column(
                  children: [
                    ExpansionTile(
                      initiallyExpanded: true,
                      title: const Text(
                        textAlign: TextAlign.start,
                        "Description",
                        style: TextStyle(fontSize: 14),
                      ),
                      children: [
                        Text(
                          service.description,
                          style: const TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget serviceCardCard(WidgetRef ref, service,
    {bool selected = false, bool showDescription = true}) {
  return Card(
    elevation: 0,
    color: ShineColors.whiteColor,
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  service.name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
              Visibility(
                visible: !selected,
                child: IconButton(
                  icon: const FaIcon(
                    FontAwesomeIcons.plus,
                    size: 20,
                  ),
                  onPressed: () {
                    final currentState =
                        ref.read(selectedServicesProvider.notifier).state;
                    final newState = List<ServicesModel>.from(currentState)
                      ..add(service);
                    ref.read(selectedServicesProvider.notifier).state =
                        newState;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 2, width: 0),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "\$${service.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 0, width: 30),
                  const Icon(Icons.timelapse_rounded),
                  const SizedBox(height: 0, width: 2),
                  Text(
                    "Approx. ${service.duration} Mins",
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
