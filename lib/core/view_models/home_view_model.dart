import 'package:gemini_demo/core/view_models/base_model.dart';

class HomeViewModel extends BaseModel {
  int _selectedItem = 0;
  int get selectedItem => _selectedItem;

  set selectedItem(int value) {
    _selectedItem = value;
    updateUI();
  }

  void onSelection(int? value) {
    _selectedItem = value??0;
    updateUI();
  }
}
