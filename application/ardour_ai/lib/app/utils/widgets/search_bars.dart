import 'package:ardour_ai/app/utils/theme/colors.dart';
import 'package:ardour_ai/app/utils/theme/shadows.dart';
import 'package:ardour_ai/app/utils/widgets/drawables.dart';
import 'package:ardour_ai/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tailwind/flutter_tailwind.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ModernSearchBar extends StatefulWidget {
  final void Function(String)? onSubmitted;
  final String placeHolder;
  final EdgeInsets? margin;

  ModernSearchBar({
    super.key,
    this.onSubmitted,
    this.margin,
    this.placeHolder = "What are you looking for?",
  });

  @override
  State<ModernSearchBar> createState() => _ModernSearchBarState();
}

class _ModernSearchBarState extends State<ModernSearchBar> {
  final FocusNode focusNode = FocusNode();

  RxBool isFocused = false.obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusNode.addListener(() {
      isFocused.value = focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MainController.size.width,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      margin: widget.margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        // boxShadow: AppShadows.downShadow,
      ),
      child: Row(
        children: [
          SVGIcon("search")..width = 20,
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              focusNode: focusNode,
              onSubmitted: widget.onSubmitted,
              style: GoogleFonts.poppins(fontSize: 14),
              cursorColor: AppColors.statusBorder,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.placeHolder,
                hintStyle: GoogleFonts.poppins(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
