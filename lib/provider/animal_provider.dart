import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../screens/message_screen.dart';

enum ANIMALSTATE { BABY, TEEN, ADULT }

enum CAMERASTATE { CAMERA, PICTURE }

class AnimalProvider extends ChangeNotifier {
  XFile? _file;
  XFile? get file => _file;

  final ValueNotifier<ANIMALSTATE> _animalStateController =
      ValueNotifier<ANIMALSTATE>(ANIMALSTATE.BABY);

  ValueNotifier<ANIMALSTATE> get animalStateStream => _animalStateController;

  final ValueNotifier<CAMERASTATE> _cameraStateController =
      ValueNotifier<CAMERASTATE>(CAMERASTATE.CAMERA);

  ValueNotifier<CAMERASTATE> get cameraStateStream => _cameraStateController;

  void grow() {
    if (_animalStateController.value == ANIMALSTATE.BABY) {
      _animalStateController.value = ANIMALSTATE.TEEN;
    } else if (_animalStateController.value == ANIMALSTATE.TEEN) {
      _animalStateController.value = ANIMALSTATE.ADULT;
    }
    notifyListeners();
  }

  void clickPicture(XFile? file) {
    if (file == null) return;
    _file = file;
    _cameraStateController.value = CAMERASTATE.PICTURE;
  }

  void check(BuildContext context) {
    _cameraStateController.value = CAMERASTATE.CAMERA;
    if (_animalStateController.value == ANIMALSTATE.ADULT) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MessageScreen(
            message: 'goodJob',
          ),
        ),
      );
    }
    grow();
  }

  reset() {
    _animalStateController.value = ANIMALSTATE.BABY;
    _cameraStateController.value = CAMERASTATE.CAMERA;
    notifyListeners();
  }
}
