import 'package:ardour_ai/app/data/sample_profiles.dart';
import 'package:ardour_ai/app/utils/theme/colors.dart';
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
      // backgroundColor: AppColors.primaryBG,
      body:
          FTContainer(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ChatPageNavbar(),
                    ModernSearchBar(
                      placeHolder: "Search people",
                      margin: EdgeInsets.fromLTRB(10, 5, 10, 15),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: MasonryGridView.count(
                        padding: EdgeInsets.only(top: 10),
                        crossAxisCount: 3,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                        itemCount: sampleProfiles.length,
                        shrinkWrap: true, // Let it take only required height
                        physics:
                            NeverScrollableScrollPhysics(), // Disable grid scroll
                        itemBuilder: (context, index) {
                          final profile = sampleProfiles[index];
                          return ProfileFollowRequestCard(
                            followers: profile.followers,
                            following: profile.following,
                            handle: profile.handleName,
                            name: profile.name,
                            image: profile.profilePic,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 30), // bottom spacing
                  ],
                ),
              ),
            )
            ..width = MainController.size.width
            ..height = MainController.size.height
            ..pt = MainController.padding.top + 10,
    );
  }
}
