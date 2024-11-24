import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:deepar_flutter/deepar_flutter.dart';
import 'package:shine_schedule/common_model.dart/services_model.dart';
import 'package:shine_schedule/config/router/route_names.dart';
import 'package:shine_schedule/utils/colors.dart';
import 'package:shine_schedule/utils/filter.dart';
import 'package:shine_schedule/widgets/appbar.dart';
import 'package:shine_schedule/widgets/custom_button.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:shine_schedule/widgets/toast.dart';

const androidKey =
    "96b49570f5110c1b8a172e4924b23c3a95e59ead87b00f1eda55e222131b0a1441cab501bb1b5a5f";
const iosKey =
    "f22f8de96c7228e251b40b5529c4257196e054d2e32b17874336c6dbc8b82f084cbcac4ab81e9020";

class DeepARCameraScreen extends ConsumerStatefulWidget {
  final ServicesModel service;
  const DeepARCameraScreen({super.key, required this.service});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DeepARCameraScreenState();
}

class _DeepARCameraScreenState extends ConsumerState<DeepARCameraScreen> {
  final deepArController = DeepArController();
  String? capturedImagePath;

  Future<void> initializeController() async {
    await deepArController.initialize(
      androidLicenseKey: androidKey,
      iosLicenseKey: iosKey,
      resolution: Resolution.high,
    );
  }

  @override
  void dispose() {
    deepArController.destroy();
    super.dispose();
  }

  Future<void> takePhoto() async {
    final photoPath = await deepArController.takeScreenshot();
    setState(() {
      capturedImagePath = photoPath.path;
    });
    showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (capturedImagePath != null)
                      Image.file(File(capturedImagePath!))
                    else
                      const Text('No image captured'),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: CustomButton(
                            label: "Save to Device",
                            onTap: () async {
                              if (capturedImagePath != null) {
                                final result = await GallerySaver.saveImage(
                                    capturedImagePath!);
                                if (result ?? false) {
                                  // ignore: use_build_context_synchronously
                                  toastWidget(context, Colors.green,
                                      "Image saved to gallery");
                                } else {
                                  toastWidget(context, Colors.red,
                                      "Failed to save image. Please check your device permission");
                                }
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: CustomButton(
                            label: "Book",
                            onTap: () {
                              GoRouter.of(context).pop();
                              deepArController.destroy();

                              final data = {
                                "service": widget.service,
                                'image': capturedImagePath,
                              };
                              GoRouter.of(context)
                                  .pushNamed(RouteNames.booking, extra: data);
                            },
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              Positioned(
                right: 0.0,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildButtons() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: deepArController.flipCamera,
            icon: const Icon(
              Icons.flip_camera_ios_outlined,
              size: 34,
              color: Colors.white,
            ),
          ),
          ElevatedButton(
            onPressed: takePhoto,
            child: const Icon(Icons.camera),
          ),
          IconButton(
            onPressed: deepArController.toggleFlash,
            icon: const Icon(
              Icons.flash_on,
              size: 34,
              color: Colors.white,
            ),
          ),
        ],
      );

  Widget buildCameraPreview() => SizedBox(
        height: MediaQuery.of(context).size.height * 0.72, // Adjusted height
        child: Transform.scale(
          scale: 1.5,
          child: DeepArPreview(deepArController),
        ),
      );

  Widget buildFilters() => SizedBox(
        height: MediaQuery.of(context).size.height * 0.1,
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: filters.length,
            itemBuilder: (context, index) {
              final filter = filters[index];
              final effectFile = 'assets/filters/${filter.filterPath}';
              return InkWell(
                onTap: () => deepArController.switchEffect(effectFile),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 60, // Adjust width as needed
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      image: DecorationImage(
                        image:
                            AssetImage('assets/previews/${filter.imagePath}'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              );
            }),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: initializeController(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  buildCameraPreview(),
                  buildButtons(),
                  buildFilters(),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
