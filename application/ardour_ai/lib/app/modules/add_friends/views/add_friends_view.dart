import 'package:ardour_ai/app/utils/theme/colors.dart';
import 'package:ardour_ai/app/utils/widgets/animated_widgets.dart';
import 'package:ardour_ai/app/utils/widgets/drawables.dart';
import 'package:ardour_ai/app/utils/widgets/navbars.dart';
import 'package:ardour_ai/app/utils/widgets/profile_badges.dart';
import 'package:ardour_ai/app/utils/widgets/search_bars.dart';
import 'package:ardour_ai/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_tailwind/flutter_tailwind.dart';

import 'package:get/get.dart';

import '../controllers/add_friends_controller.dart';

class AddFriendsView extends GetView<AddFriendsController> {
  const AddFriendsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBG,
      body:
          FTContainer(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ChatPageNavbar(),
                    ModernSearchBar(
                      textEditingController: controller.searchController,
                      searchResults: controller.searchListRecommendations,
                      searchRecommendations: controller.recommendedAccounts,
                      placeHolder: "Search people",
                      margin: EdgeInsets.fromLTRB(10, 5, 10, 15),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Obx(() {
                        final currentItems =
                            controller.searchListRecommendations.isEmpty
                                ? controller.recommendedAccounts
                                : controller.searchListRecommendations;
                        return Visibility(
                          visible: currentItems.isNotEmpty,
                          replacement: PlaceHolderLoader(),
                          child: MasonryGridView.count(
                            padding: EdgeInsets.only(top: 10),
                            crossAxisCount: 3,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5,
                            itemCount: currentItems.length,
                            shrinkWrap:
                                true, // Let it take only required height
                            physics:
                                NeverScrollableScrollPhysics(), // Disable grid scroll
                            itemBuilder: (context, index) {
                              final profile = currentItems[index];
                              return AnimatedCrossFadeUp(
                                delay:
                                    index != 0
                                        ? Duration(milliseconds: 150 * index)
                                        : null,
                                child: ProfileFollowRequestCard(
                                  // followers: profile.followers,
                                  // following: profile.following,
                                  // handle: profile.handleName,
                                  userId: profile.userId,
                                  name: profile.userName,
                                  image:
                                      profile.profileImage ??
                                      'assets/images/sample/raul.jpg',
                                ),
                              );
                            },
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 30), // bottom spacing
                  ],
                ),
              ),
            )
            ..alignment = Alignment.topCenter
            ..width = MainController.size.width
            ..height = MainController.size.height
            ..pt = MainController.padding.top + 10,
    );
  }
}
