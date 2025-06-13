import 'package:ardour_ai/app/data/models.dart';
import 'package:ardour_ai/app/utils/theme/colors.dart';
import 'package:ardour_ai/app/utils/widgets/drawables.dart';
import 'package:ardour_ai/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tailwind/flutter_tailwind.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ModernSearchBar extends StatefulWidget {
  final void Function(String)? onItemTap;
  final TextEditingController textEditingController;
  final String placeHolder;
  final EdgeInsets? margin;
  final RxList<PassUser> searchResults;
  final RxList<PassUser> searchRecommendations;

  ModernSearchBar({
    super.key,
    this.onItemTap,
    required this.textEditingController,
    this.margin,
    this.placeHolder = "What are you looking for?",
    required this.searchResults,
    required this.searchRecommendations,
  });

  @override
  State<ModernSearchBar> createState() => _ModernSearchBarState();
}

class _ModernSearchBarState extends State<ModernSearchBar>
    with TickerProviderStateMixin {
  final FocusNode focusNode = FocusNode();

  late AnimationController _barController;
  late AnimationController _suggestionController;

  late Animation<double> barScale;
  late Animation<Color?> barShadowColor;

  RxBool isFocused = false.obs;

  @override
  void initState() {
    super.initState();

    _barController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _suggestionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    barScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.05), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.05, end: 1.0), weight: 1),
    ]).animate(
      CurvedAnimation(parent: _barController, curve: Curves.easeInOut),
    );

    barShadowColor = ColorTween(
      begin: FTColors.gray200,
    ).animate(CurvedAnimation(parent: _barController, curve: Curves.easeInOut));

    widget.searchResults.listen((updatedList) {
      if (focusNode.hasFocus && updatedList.isNotEmpty) {
        _suggestionController.forward();
      }
    });

    focusNode.addListener(() {
      isFocused.value = focusNode.hasFocus;

      if (focusNode.hasFocus) {
        _barController.forward();
        if (widget.searchResults.isNotEmpty ||
            widget.searchRecommendations.isNotEmpty) {
          _suggestionController.forward();
        }
      } else {
        _barController.reverse();
        _suggestionController.reverse();
      }
    });
  }

  Widget searchItem(PassUser item) {
    return InkWell(
      onTap: () => widget.onItemTap?.call(item.userId),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            const SizedBox(width: 6),
            SVGIcon("search")..width = 16,
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                item.userName,
                style: GoogleFonts.poppins(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _barController.dispose();
    _suggestionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.margin ?? EdgeInsets.zero,
      child: Stack(
        children: [
          // suggestions dropdown
          SizeTransition(
            sizeFactor: _suggestionController,
            axisAlignment: -1.0,
            child: Obx(() {
              if (widget.searchRecommendations.isEmpty &&
                  widget.searchResults.isEmpty)
                return const SizedBox.shrink();

              return FTContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        widget.searchResults.isEmpty
                            ? "Recommended Accounts"
                            : "Search Results",
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      ...(widget.searchResults.isEmpty
                              ? widget.searchRecommendations
                              : widget.searchResults)
                          .map(searchItem)
                          .toList(),
                    ],
                  ),
                )
                ..width = MainController.size.width
                ..pt = 70
                ..pb = 20
                ..px = 20
                ..borderRadius = BorderRadius.circular(30)
                ..alignment = Alignment.centerLeft
                ..bgColor = const Color.fromARGB(255, 250, 250, 250);
            }),
          ),

          // search bar
          AnimatedBuilder(
            animation: _barController,
            builder: (context, _) {
              return Transform.scale(
                scale: barScale.value,
                child: Container(
                  width: MainController.size.width,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5000),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 3,
                        color: barShadowColor.value ?? Colors.transparent,
                        offset: const Offset(0, 0),
                      ).scale(3),
                    ],
                  ),
                  child: Row(
                    children: [
                      SVGIcon("search")..width = 20,
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          focusNode: focusNode,
                          controller: widget.textEditingController,
                          style: GoogleFonts.poppins(fontSize: 14),
                          cursorColor: AppColors.statusBorder,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: widget.placeHolder ?? "Search...",
                            hintStyle: GoogleFonts.poppins(fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
