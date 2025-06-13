import 'package:ardour_ai/app/utils/theme/colors.dart';
import 'package:ardour_ai/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

enum CustomSnackBarStatus { danger, info, warning, success }

class CustomSnackBar extends StatefulWidget {
  const CustomSnackBar({
    super.key,
    required this.status,
    required this.title,
    required this.message,
  });
  final CustomSnackBarStatus status;
  final String title;
  final String message;

  @override
  State<CustomSnackBar> createState() => _CustomSnackBarState();
}

class _CustomSnackBarState extends State<CustomSnackBar>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _width;

  _initAnimations() {
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _width = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();
  }

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CustomSnackBar oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    _controller.dispose();
    _initAnimations();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, oldWidget) {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              width: MainController.size.width * _width.value,
              color:
                  widget.status == CustomSnackBarStatus.info
                      ? AppColors.info
                      : widget.status == CustomSnackBarStatus.danger
                      ? AppColors.danger
                      : widget.status == CustomSnackBarStatus.success
                      ? AppColors.success
                      : AppColors.warning,
              height: 3,
            ),

            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: GoogleFonts.notoSans(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        widget.message,
                        style: TextStyle(fontSize: 13, color: Colors.black),
                      ),
                    ],
                  ),

                  Icon(
                    Icons.ac_unit_rounded,
                    size: 28,
                    color:
                        widget.status == CustomSnackBarStatus.info
                            ? AppColors.info
                            : widget.status == CustomSnackBarStatus.danger
                            ? AppColors.danger
                            : widget.status == CustomSnackBarStatus.success
                            ? AppColors.success
                            : AppColors.warning,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

getCustomSnackBar({
  required String title,
  required String message,
  required CustomSnackBarStatus status,
}) => ScaffoldMessenger.of(Get.context!).showSnackBar(
  SnackBar(
    padding: EdgeInsets.zero,
    duration: const Duration(seconds: 4),
    content: CustomSnackBar(title: title, message: message, status: status),
    backgroundColor: Colors.white,
  ),
);

errorMessage({String? message, String? title}) => getCustomSnackBar(
  title: title ?? "Error",
  message: message ?? "Some issue occured try again later!",
  status: CustomSnackBarStatus.danger,
);
successMessage({String? message, String? title}) => getCustomSnackBar(
  title: title ?? "Success",
  message: message ?? "Action Completed Successfully",
  status: CustomSnackBarStatus.success,
);
serverError() => getCustomSnackBar(
  title: "Server Error",
  message: "Server did not respond. Try again later!",
  status: CustomSnackBarStatus.danger,
);
noServerError() => getCustomSnackBar(
  title: "Server Error",
  message: "Some issue occured connecting to server, try again!",
  status: CustomSnackBarStatus.danger,
);
noInternetMessage() => getCustomSnackBar(
  title: "Network Issue",
  message: "Please check your connection and try again!",
  status: CustomSnackBarStatus.warning,
);

// void networkExceptionHandler(Exception e) {
//   if (e is TimeoutException) {
//     noServerError();
//   }
//   if (e is NetworkConnectionException) {
//     print(e);
//     noInternetMessage();
//   }
//   if (e is SocketException) {
//     print(e);
//     serverError();
//   }
// }
