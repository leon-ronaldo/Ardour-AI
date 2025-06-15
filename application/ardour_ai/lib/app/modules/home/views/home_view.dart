import 'package:ardour_ai/app/data/sample_profiles.dart';
import 'package:ardour_ai/app/utils/theme/colors.dart';
import 'package:ardour_ai/app/utils/widgets/drawables.dart';
import 'package:ardour_ai/app/utils/widgets/navbars.dart';
import 'package:ardour_ai/app/utils/widgets/post_views.dart';
import 'package:ardour_ai/app/utils/widgets/profile_badges.dart';
import 'package:ardour_ai/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tailwind/flutter_tailwind.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    MainController.size = context;
    MainController.padding = context;
    return Scaffold(
      backgroundColor: AppColors.primaryBG,
      body:
          FTContainer(
              child: Obx(
                () => Visibility(
                  visible: controller.isReady.value,
                  replacement: PlaceHolderLoader(),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        MainNavBar(),

                        FTContainer(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: sampleProfiles.length,
                              itemBuilder:
                                  (context, index) =>
                                      FTContainer(
                                          child: ProfileStatusBadge(
                                            isUser: index == 0,
                                            statusCount: 1,
                                            name: sampleProfiles[index].name,
                                            image:
                                                sampleProfiles[index]
                                                    .profilePic,
                                          ),
                                        )
                                        ..mr = 10
                                        ..ml = index == 0 ? 10 : 0,
                            ),
                          )
                          ..width = MainController.size.width
                          ..height = 120,

                        // post image
                        ImagePostView(
                          name: "Lucia Caminos",
                          profileImage: "assets/images/sample/lucia.png",
                          postImage: "assets/images/sample/lucia-gta-6.jpg",
                          caption:
                              "Vice City, get ready — I'm coming in loud and legendary. 💋🚘🔥 No more teasers… this is the rise of Lucia. #GTA6 #ViceQueen #ComingSoon",
                        ),

                        ImagePostView(
                          name: "Ashlyn Mary",
                          profileImage: "assets/images/sample/ashlyn.png",
                          postImage: "assets/images/sample/ashlyn-summer.png",
                          caption:
                              "Years of dreaming, one perfect summer — just me and my sis soaking in the sunshine and sisterhood 🌞👭💛 #SisterGoals #SummerOfUs",
                        ),

                        ImagePostView(
                          name: "Leon Ronaldo",
                          profileImage: "assets/images/sample/ronaldo.jpeg",
                          postImage: "assets/images/sample/leonida.jpg",
                          caption:
                              "Heading to Leonida Keys — where the sun kisses the waves and every moment feels like freedom 🌴☀️🌊 Can’t wait to dive into paradise! 😎🔥 #BeachBound #LeonidaVibes",
                        ),

                        ImagePostView(
                          name: "Ben Affleck",
                          profileImage: "assets/images/sample/affleck.jpg",
                          postImage: "assets/images/sample/the-bat.jpg",
                          caption:
                              "Being Batman isn't a simple task! You gotta balance between a businessman💵 and a city guardian🦇 life day and night❤️‍🔥",
                        ),

                        ImagePostView(
                          name: "Michael De Santa",
                          profileImage:
                              "assets/images/sample/gta-v-michael.jpg",
                          postImage: "assets/images/sample/the-gta-v-trio.jpg",
                          caption:
                              "A retired bank robber, a lunatic, and a hustler walk into Los Santos... and rewrite chaos. 🔫💰🎭 Some bonds aren’t made — they’re detonated. #GTAV #LosSantosLegends #FamilyAndFirefights",
                        ),

                        ImagePostView(
                          name: "John Wick",
                          profileImage: "assets/images/sample/john.jpg",
                          postImage: "assets/images/sample/royal-wick.jpg",
                          caption:
                              "Being John Wick isn’t just pulling the trigger—💥 it’s carrying the weight of love lost 💔 and vengeance earned ⚔️ while walking a path where peace is a luxury and survival is an art 🎯🔥",
                        ),

                        ImagePostView(
                          name: "Samantha Gallen",
                          profileImage: "assets/images/sample/sam.jpg",
                          postImage: "assets/images/sample/mike.jpg",
                          caption:
                              "I still remember that cold night at Blackwood Pines... Mike, are you really gone? 🥺🌨️ #UntilDawn #MemoriesThatHaunt",
                        ),

                        ImagePostView(
                          name: "Leon Ronaldo",
                          profileImage: "assets/images/sample/ronaldo.jpeg",
                          postImage: "assets/images/sample/jesus-photo.jpg",
                          caption:
                              "He walked so we could rise. ✝️❤️ A reminder that love, sacrifice, and forgiveness still light the way. #Faith #Guidance #Gratitude",
                        ),

                        ImagePostView(
                          name: "Lucia Caminos",
                          profileImage: "assets/images/sample/lucia.png",
                          postImage: "assets/images/sample/raul.jpg",
                          caption:
                              "Raul and I on a mission that changed everything. Some roads you walk once, and they never leave your soul. 🚗💣🔥",
                        ),

                        ImagePostView(
                          name: "Sooryodhaya",
                          profileImage: "assets/images/sample/soorya.png",
                          postImage: "assets/images/sample/two-side.jpg",
                          caption:
                              "Two sides of the same soul — one holding her hand with warmth, the other chasing dreams in code. 💻❤️‍🔥 Balancing love and legacy like a true alter ego. #DualLife #EngineerInMaking #LoyalHeart",
                        ),

                        ImagePostView(
                          name: "Vaas Montenegro",
                          profileImage: "assets/images/sample/vaas.jpg",
                          postImage: "assets/images/sample/define-insanity.jpg",
                          caption:
                              "You know the definition of insanity, right? 🔁 Doing the same post over and over… expecting likes to change. 💣🌀 Welcome back to the jungle, my friend. #FarCry3 #Vaas #InsanityDefined",
                        ),

                        ImagePostView(
                          name: "Ashlyn Mary",
                          profileImage: "assets/images/sample/ashlyn.png",
                          postImage: "assets/images/sample/ashlyn-mummy.png",
                          caption:
                              "Mom finally took that much-needed break — soaking up the sun, the breeze, and life itself 🌊☀️❤️ Wrapped in joy, not just linen 😄 #BeachDays #MomOnTour #DeservedPeace",
                        ),

                        ImagePostView(
                          name: "Edward Kenway",
                          profileImage:
                              "assets/images/sample/edward-kenway.jpg",
                          postImage: "assets/images/sample/ship_sailing.jpg",
                          caption:
                              "The sea’s where I find freedom — no kings, no chains, just the wind at my back and the horizon ahead. 🏴‍☠️⚓🌊 #PirateLife #AssassinsCreed #FreedomOverEverything",
                        ),

                        ImagePostView(
                          name: "Faith Seed",
                          profileImage: "assets/images/sample/faithSeed.jpg",
                          postImage: "assets/images/sample/faith in real.jpg",
                          caption:
                              "They really made a *real-world* version of me? 😇🌸 Guess bliss isn't just a game anymore. Welcome to Eden’s Gate — now in HD and awkward reality! 🎬💉 #IRLRemake #TooReal #FarCry5",
                        ),

                        ImagePostView(
                          name: "Ezio Auditore",
                          profileImage: "assets/images/sample/ac2-ezio.jpg",
                          postImage: "assets/images/sample/il duomo.jpg",
                          caption:
                              "Requiescat in pace… but only after I’ve climbed every rooftop in Firenze 🏛️🗡️ From vengeance to legacy — it all started beneath Il Duomo. #AssassinsCreedII #EzioAuditore #FlorenceVibes",
                        ),

                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            )
            ..alignment = Alignment.centerLeft
            ..pt = MainController.padding.top
            ..width = MainController.size.width
            ..height = MainController.size.height,
    );
  }
}
