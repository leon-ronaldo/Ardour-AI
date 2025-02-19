import 'package:ardour_ai/app/utils/widget_utils/svgicon.dart';
import 'package:ardour_ai/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tailwind/flutter_tailwind.dart';

import 'package:get/get.dart';

import '../controllers/get_started_controller.dart';

class GetStartedView extends GetView<GetStartedController> {
  const GetStartedView({super.key});
  @override
  Widget build(BuildContext context) {
    MainController.setScreenSize(context);
    return Scaffold(
      backgroundColor: Color(0xffeeebee),
      body: FTContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text("Ardour AI",
                    style: TextStyle(
                      fontSize: 30,
                    )),
                Text(
                    "Chat and get Entertained with the most realistic AI social platform",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14)),
              ],
            ),
            Column(children: [
              Text("Get Started"),
              FTRow(
                children: [
                  InkResponse(
                    onTap: () {
                      controller.login();
                    },
                    child: FTContainer(child: Svgicon(icon: "google"))
                      ..p = 15
                      ..bgColor = Colors.white
                      ..borderRadius = FTBorderRadii.roundedLg,
                  )
                ],
              )
                ..mt = 20
                ..mainAxisAlignment = MainAxisAlignment.center
            ])
          ],
        ),
      )
        ..p = 15
        ..bgImage = "assets/images/get-started-bg.jpeg"
        ..height = MainController.screenSize.height
        ..width = MainController.screenSize.width,
    );
  }
}

// Scaffold(
//       backgroundColor: Color(0xffeeebee),
//       body: FTContainer()
//         ..p = 15
//         ..height = MainController.screenSize.height
//         ..width = MainController.screenSize.width,
//     )
