import 'package:flutter/material.dart';
import 'package:fog_map/reuseable/round_button.dart';
import 'package:fog_map/sigin/index.dart';
import 'package:fog_map/welcom_screens/controller.dart';
import 'package:fog_map/welcom_screens/screen1/view.dart';
import 'package:fog_map/welcom_screens/screen2/view.dart';
import 'package:fog_map/welcom_screens/screen3/view.dart';
import 'package:get/get.dart';

class WelcomePage extends StatelessWidget {
  WelcomePage({Key? key}) : super(key: key);

  List<Widget> pages = [
    ScreenOne(),
    // Scaffold(
    //   backgroundColor: Colors.grey,
    //   body: Center(
    //     child: Text("Page 2 s"),
    //   ),
    // ),
    ScreenTwo(),
    ScreenThree(),
    // Scaffold(
    //   backgroundColor: Colors.blue,
    //   body: Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Text("Page 3 s"),
    //         Padding(
    //           padding: const EdgeInsets.all(20),
    //           child: RoundButton(
    //               title: "Go to SignUp Page",
    //               onPress: () {
    //                 Get.offAll(() => SignInPage());
    //               }),
    //         )
    //       ],
    //     ),
    //   ),
    // ),
  ];

  final controller = Get.put<WelcomeController>(WelcomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          PageView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: pages.length,
            itemBuilder: (BuildContext context, int index) {
              return pages[index];
            },
            onPageChanged: (int index) {
              // Handle page change event
              print('Page changed to index $index');
              controller.state.index.value = index;
            },

          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // CircleAvatar(),
                    // CircleAvatar(),
                    //
                    //
                    // CircleAvatar(),
                    Obx(() {
                      return CircleIndicator(
                        itemCount: pages.length,
                        activeIndex: controller
                            .state.index.value, // Set the initial active index
                      );
                    })
                  ],
                ),
                SizedBox(height: 30,)
              ],
            ),
          ),
        ],
      )),
    );
  }
}

class CircleIndicator extends StatelessWidget {
  final int itemCount;
  final int activeIndex;

  const CircleIndicator({required this.itemCount, required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 8),
          width: index == activeIndex ? 20 : 8,
          height: index == activeIndex ? 10 : 8,
          decoration: BoxDecoration(
            // shape: BoxShape.circle,
            borderRadius: BorderRadius.circular(5),
            color: index == activeIndex ? Colors.black : Colors.grey,
          ),
        );
      }),
    );
  }
}
