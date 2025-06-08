import 'package:ardour_ai/app/data/sample_profiles.dart';
import 'package:ardour_ai/app/utils/theme/colors.dart';
import 'package:ardour_ai/app/utils/widgets/chat_widgets.dart';
import 'package:ardour_ai/app/utils/widgets/navbars.dart';
import 'package:ardour_ai/app/utils/widgets/profile_badges.dart';
import 'package:ardour_ai/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tailwind/flutter_tailwind.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/chats_controller.dart';

class ChatsView extends GetView<ChatsController> {
  const ChatsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBG,
      body:
          FTContainer(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ChatPageNavbar(),
                    FTContainer(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: sampleProfiles.length,
                          itemBuilder:
                              (context, index) =>
                                  index == 0
                                        ? (FTContainer(
                                          child: ProfileBadgeWithNotes(
                                            isUser: true,
                                            name: "Your Note",
                                            image:
                                                sampleProfiles[index]
                                                    .profilePic,
                                          ),
                                        )..ml = 15)
                                        : FTContainer(
                                          child: ProfileBadgeWithNotes(
                                            name: sampleProfiles[index].name,
                                            image:
                                                sampleProfiles[index]
                                                    .profilePic,
                                            note: sampleProfiles[index].note,
                                          ),
                                        )
                                    ..mr = 10,
                        ),
                      )
                      ..width = MainController.size.width
                      ..height = 120,

                    FTContainer(
                        child: Row(
                          children: [
                            Expanded(
                              child:
                                  FTContainer(
                                      child: Text(
                                        "All Chats",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                    ..py = 10
                                    ..px = 15
                                    ..borderRadius = FTBorderRadii.roundedFull
                                    ..bgColor = AppColors.statusBorder,
                            ),

                            Expanded(
                              child:
                                  FTContainer(
                                      child: Text(
                                        "Groups",
                                        style: GoogleFonts.poppins(),
                                      ),
                                    )
                                    ..py = 10
                                    ..px = 15
                                    ..borderRadius = FTBorderRadii.roundedFull,
                            ),

                            Expanded(
                              child:
                                  FTContainer(
                                      child: Text(
                                        "Contacts",
                                        style: GoogleFonts.poppins(),
                                      ),
                                    )
                                    ..py = 10
                                    ..px = 15
                                    ..borderRadius = FTBorderRadii.roundedFull,
                            ),
                          ],
                        ),
                      )
                      ..bgColor = Color(0xfff2f2f2)
                      ..width = MainController.size.width
                      ..borderRadius = FTBorderRadii.roundedFull
                      ..mx = 15
                      ..mt = 10
                      ..mb = 15,

                    ChatCard(
                      name: "Manish Prasad",
                      caption: "Let’s review the PR before noon ⏰",
                      image: "assets/images/sample/manish.png",
                      unreadMessages: 2,
                    ),

                    ChatCard(
                      name: "Sooryodhaya",
                      caption: "I'll send the updated prototype tonight.",
                      image: "assets/images/sample/soorya.jpeg",
                      unreadMessages: null,
                    ),

                    ChatCard(
                      name: "John Wick",
                      caption: "I'm thinking... I'm back.",
                      image: "assets/images/sample/john.jpg",
                      unreadMessages: 7,
                    ),

                    ChatCard(
                      name: "Ben Affleck",
                      caption: "Board meeting postponed to tomorrow.",
                      image: "assets/images/sample/affleck.jpg",
                      unreadMessages: null,
                    ),

                    ChatCard(
                      name: "Lucia Caminos",
                      caption: "Vice City is about to get wild 🔥",
                      image: "assets/images/sample/lucia.png",
                      unreadMessages: 1,
                    ),

                    ChatCard(
                      name: "Ashlyn Mary",
                      caption: "Sis, the beach was magical today 🌊✨",
                      image: "assets/images/sample/ashlyn.png",
                      unreadMessages: 3,
                    ),

                    ChatCard(
                      name: "Samantha G.",
                      caption: "Nature calms me... even after horror 🌲😌",
                      image: "assets/images/sample/sam.jpg",
                      unreadMessages: 5,
                    ),

                    ChatCard(
                      name: "Edward Kenway",
                      caption: "The sea is calling, lad. Set sail! ⛵",
                      image: "assets/images/sample/edward-kenway.jpg",
                      unreadMessages: null,
                    ),

                    ChatCard(
                      name: "Michael",
                      caption:
                          "Therapy’s at 4, heist at 6... classic Tuesday 🤯💰",
                      image: "assets/images/sample/gta-v-michael.jpg",
                      unreadMessages: 9,
                    ),

                    SizedBox(height: 20),
                  ],
                ),
              ),
            )
            ..width = MainController.size.width
            ..height = MainController.size.height
            ..pt = MainController.padding.top + 10
            ..alignment = Alignment.topCenter,
    );
  }
}
