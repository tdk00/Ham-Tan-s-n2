import 'package:everyone_know_app/api/main/statuses.dart';
import 'package:rxdart/rxdart.dart';
import 'package:story_view/controller/story_controller.dart';

class StoryBloc {
  StoryBloc() {
    _isKeyboardOpenController.stream.listen((value) {
      if (value) {
        controller.pause();
      } else {
        controller.play();
      }
    });
  }

  final BehaviorSubject<String?> _storyIdController = BehaviorSubject<String?>();
  final BehaviorSubject<StoryController> _storyController = BehaviorSubject<StoryController>();
  final BehaviorSubject<bool> _isKeyboardOpenController = BehaviorSubject<bool>.seeded(false);

  Stream<StoryController> get controller$ => _storyController.stream;
  Stream<bool> get isKeyboardOpen$ => _isKeyboardOpenController.stream;

  String? get storyId => _storyIdController.valueOrNull;
  StoryController get controller => _storyController.value;
  bool get isKeyboardOpen => _isKeyboardOpenController.value;

  void updateStoryId(String? value) => _storyIdController.add(value);
  void updateController(StoryController value) => _storyController.add(value);
  void updateIsKeyboardOpen(bool value) => _isKeyboardOpenController.add(value);

  Future<bool> deleteStory() async {
    try {
      await Statuses.deleteStatus(storyId);

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  void checkKeyboardOpen() {
    if (isKeyboardOpen) {
      controller.pause();
    } else {
      controller.play();
    }
  }

  void close() {
    _storyIdController.close();
    _storyController.close();
    _isKeyboardOpenController.close();
  }
}
