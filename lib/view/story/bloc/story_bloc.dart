import 'package:everyone_know_app/api/main/statuses.dart';
import 'package:rxdart/rxdart.dart';

class StoryBloc {
  final BehaviorSubject<String?> _storyIdController = BehaviorSubject<String?>();

  String? get storyId => _storyIdController.valueOrNull;

  void updateStoryId(String? value) => _storyIdController.add(value);

  Future<bool> deleteStory() async {
    try {
      print('bura girdi');
      await Statuses.deleteStatus(storyId);

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  void close() {
    _storyIdController.close();
  }
}
