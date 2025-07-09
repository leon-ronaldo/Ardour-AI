import 'package:ardour_ai/app/data/sample_profiles.dart';
import 'package:ardour_ai/app/routes/app_pages.dart';
import 'package:ardour_ai/app/utils/theme/colors.dart';
import 'package:ardour_ai/app/utils/widgets/chat_widgets.dart';
import 'package:ardour_ai/app/utils/widgets/drawables.dart';
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
      body: Focus(
        autofocus: true,
        onFocusChange: (hasFocus) {
          if (hasFocus) {
            controller.fetchContacts();
          }
        },
        child:
            FTContainer(
                child: SingleChildScrollView(
                  child: Obx(
                    () => Column(
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
                                              name: "Add Note",
                                              image:
                                                  sampleProfiles[index]
                                                      .profilePic,
                                            ),
                                          )..ml = 15)
                                          : ProfileBadgeWithNotes(
                                            name: sampleProfiles[index].name,
                                            image:
                                                sampleProfiles[index]
                                                    .profilePic,
                                            note: sampleProfiles[index].note,
                                          ),
                            ),
                          )
                          ..width = MainController.size.width
                          ..alignment = Alignment.center
                          ..height = 150,

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
                                        ..borderRadius =
                                            FTBorderRadii.roundedFull
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
                                        ..borderRadius =
                                            FTBorderRadii.roundedFull,
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
                                        ..borderRadius =
                                            FTBorderRadii.roundedFull,
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

                        controller.isReady.value
                            ? controller.recentChatsList.isEmpty
                                ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(24.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.group_outlined,
                                          size: 80,
                                          color: Colors.grey[400],
                                        ),
                                        const SizedBox(height: 20),
                                        Text(
                                          "No contacts found",
                                          style: Theme.of(
                                            context,
                                          ).textTheme.headlineSmall?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[700],
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          "Start by adding some friends to begin chatting and sharing moments!",
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium?.copyWith(
                                            color: Colors.grey[600],
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                : Column(
                                  children:
                                      controller.recentChatsList.map((account) {
                                        final chat = account.recentMessages;
                                        String caption =
                                            "Messages are end-to-end encrypted";
                                        int? timestamp;
                                        if (chat != null) {
                                          if (chat.isNotEmpty) {
                                            caption =
                                                "${chat.last.from == account.contact.userId ? "" : "You: "}${chat.last.message}";
                                            timestamp = chat.last.timestamp;
                                          }
                                        }
                                        return InkResponse(
                                          onTap: () {
                                            Get.toNamed(
                                              Routes.PERSONAL_CHAT,
                                              arguments: {
                                                'contact': account.contact,
                                              },
                                            );
                                          },
                                          child: ChatCard(
                                            name: account.contact.userName,
                                            image:
                                                account.contact.profileImage ??
                                                "assets/images/sample/raul.jpg",
                                            unreadMessages: null,
                                            caption: caption,
                                            timeStamp: timestamp,
                                          ),
                                        );
                                      }).toList(),
                                )
                            : PlaceHolderLoader(),

                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              )
              ..width = MainController.size.width
              ..height = MainController.size.height
              ..pt = MainController.padding.top + 10
              ..alignment = Alignment.topCenter,
      ),
    );
  }
}
