import 'dart:io';

import 'package:Alemeno/widgets/click_picture/corner_container.dart';
import 'package:Alemeno/widgets/common/back_button.dart';
import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../gen/assets.gen.dart';
import '../gen/colors.gen.dart';
import '../provider/animal_provider.dart';

class ClickPictureScreen extends StatefulWidget {
  const ClickPictureScreen({Key? key}) : super(key: key);

  @override
  State<ClickPictureScreen> createState() => _ClickPictureScreenState();
}

class _ClickPictureScreenState extends State<ClickPictureScreen> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  late AnimalProvider provider;

  @override
  void initState() {
    super.initState();
    final camerasFuture = availableCameras();
    _initializeControllerFuture = camerasFuture.then((cameras) {
      _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
      return _cameraController.initialize();
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Widget buildCamera() {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the camera is initialized, display the CameraPreview inside a ClipOval.
          return ClipOval(
            child: AspectRatio(
              aspectRatio: 1,
              child: CameraPreview(_cameraController),
            ),
          );
        } else {
          // Otherwise, display a loading indicator.
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget buildPicture(BuildContext context) {
    final provider = Provider.of<AnimalProvider>(context);
    return ClipOval(
      child: AspectRatio(
        aspectRatio: 1,
        child: Image.file(
          File(provider.file!.path),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AnimalProvider>(builder: (context, provider, _) {
        return SafeArea(
          child: SizedBox(
            width: 1.sw,
            height: 1.sh,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 16, top: 16),
                  child: AppBackButton(),
                ),
                ValueListenableBuilder<ANIMALSTATE>(
                    valueListenable: provider.animalStateStream,
                    builder: (context, value, _) {
                      Widget image;
                      switch (value) {
                        case ANIMALSTATE.BABY:
                          image = Assets.images.baby.image(
                            fit: BoxFit.contain,
                          );
                          break;
                        case ANIMALSTATE.ADULT:
                          image = Assets.images.adult.image(
                            fit: BoxFit.contain,
                          );
                          break;
                        case ANIMALSTATE.TEEN:
                          image = Assets.images.teen.image(
                            fit: BoxFit.contain,
                          );
                          break;
                        default:
                          image = Assets.images.baby.image(
                            fit: BoxFit.contain,
                          );
                          break;
                      }

                      return AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        width: 1.sw,
                        height: 0.25.sh,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        alignment: Alignment.centerRight,
                        child: image,
                      );
                    }),
                Expanded(
                  child: Card(
                    color: AppColors.gray,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Container(
                      width: 1.sw,
                      height: 1.sh,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          const Spacer(
                            flex: 2,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Assets.images.fork.svg(),
                              20.horizontalSpace,
                              CornerContainer(
                                child: CircleAvatar(
                                    radius: 100.r,
                                    backgroundColor: AppColors.black,
                                    child: ValueListenableBuilder<CAMERASTATE>(
                                      valueListenable:
                                          provider.cameraStateStream,
                                      builder: (context, value, child) {
                                        switch (value) {
                                          case CAMERASTATE.CAMERA:
                                            return buildCamera();
                                          case CAMERASTATE.PICTURE:
                                            return buildPicture(context);
                                          default:
                                            return const CircularProgressIndicator();
                                        }
                                      },
                                    )),
                              ),
                              20.horizontalSpace,
                              Assets.images.spoon.svg(),
                            ],
                          ),
                          const Spacer(),
                          ValueListenableBuilder(
                              valueListenable: provider.cameraStateStream,
                              builder: (context, value, _) {
                                return Text(
                                  value == CAMERASTATE.CAMERA
                                      ? 'clickYourMeal'.tr()
                                      : 'willYouEatThis'.tr(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                );
                              }),
                          const Spacer(),
                          ValueListenableBuilder(
                              valueListenable: provider.cameraStateStream,
                              builder: (context, value, _) {
                                return ElevatedButton(
                                  onPressed: () async {
                                    if (value == CAMERASTATE.PICTURE) {
                                      await _cameraController
                                          .resumePreview()
                                          .then((value) =>
                                              provider.check(context));
                                    } else {
                                      await _cameraController
                                          .takePicture()
                                          .then(
                                            (value) =>
                                                provider.clickPicture(value),
                                          );
                                      _cameraController.pausePreview();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 6,
                                    primary: AppColors.accent,
                                    onPrimary: Colors.white,
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 12,
                                    ),
                                  ),
                                  child: value == CAMERASTATE.CAMERA
                                      ? Icon(
                                          Icons.camera_alt,
                                          size: 35.r,
                                        )
                                      : Icon(
                                          Icons.check,
                                          size: 35.r,
                                        ),
                                );
                              }),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
