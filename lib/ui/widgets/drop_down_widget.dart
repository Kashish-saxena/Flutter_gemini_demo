import 'package:flutter/material.dart';
import 'package:gemini_demo/core/constants/color_consant.dart';
import 'package:gemini_demo/core/constants/string_constant.dart';
import 'package:gemini_demo/core/models/sections_models.dart';
import 'package:gemini_demo/core/view_models/home_view_model.dart';
import 'package:gemini_demo/ui/views/base_view.dart';

// ignore: must_be_immutable
class DropDownWidget extends StatelessWidget {
  DropDownWidget({super.key});
  HomeViewModel? model;
  @override
  Widget build(BuildContext context) {
    return BaseView<HomeViewModel>(
      onModelReady: (model) {
        this.model = model;
      },
      builder: (context, model, child) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: ColorConstants.black,
          ),
          child: PopupMenuButton<int>(
            offset: const Offset(10, 35),
            initialValue: model.selectedItem,
            onSelected: (value) => model.onSelection(value),
            itemBuilder: (context) => sections.map((e) {
              return PopupMenuItem<int>(value: e.index, child: Text(e.title));
            }).toList(),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                    child: Text(
                  StringConstants.select,
                  style: TextStyle(color: ColorConstants.white),
                )),
                Flexible(
                    child: Icon(
                  Icons.arrow_drop_down,
                  color: ColorConstants.white,
                )),
              ],
            ),
          ),
        );
      },
    );
  }
}
