import 'package:flutter/material.dart';
import 'package:gemini_demo/core/constants/color_consant.dart';
import 'package:gemini_demo/core/models/sections_models.dart';
import 'package:gemini_demo/core/view_models/home_view_model.dart';
import 'package:gemini_demo/ui/views/base_view.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  HomeViewModel? model;
  @override
  Widget build(BuildContext context) {
    return BaseView<HomeViewModel>(
      onModelReady: (model) {
        this.model = model;
      },
      builder: (context, model, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: ColorConstants.black,
            
            body: buildBody(),
          ),
        );
      },
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 30),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: ColorConstants.white,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              borderRadius: BorderRadius.circular(30),
              dropdownColor: ColorConstants.white,
              value: model?.selectedItem,
              items: List.generate(
                sections.length,
                (index) => DropdownMenuItem<int>(
                  value: index,
                  child: Text(
                    sections[index].title,
                    style: const TextStyle(color: ColorConstants.black),
                  ),
                ),
              ),
              onChanged: (value) {
                model?.onSelection(value);
              },
            ),
          ),
        ),
        Expanded(
          child: IndexedStack(
            index: model?.selectedItem,
            children: sections.map((screen) => screen.widget).toList(),
            // children: [TextAndImageScreen(),ChatScreen()],
          ),
        ),
      ],
    );
  }
}
