import 'package:gemini_demo/core/view_models/base_model.dart';

class HomeViewModel extends BaseModel {
  int selectedItem = 0;

  void onSelection(value) {
    selectedItem = value;
    updateUI();
  }
}
