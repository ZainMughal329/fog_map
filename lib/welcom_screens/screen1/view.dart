import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:fog_map/sigin/sign_up_view.dart';
import 'package:fog_map/sigin/view.dart';
import 'package:fog_map/welcom_screens/screen1/controller.dart';
import 'package:get/get.dart';

class ScreenOne extends GetView<ScreenOneController> {
  const ScreenOne({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 25,top: 20),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                      onTap: (){
                        Get.off(SignInPage());
                      },
                      child: Icon(Icons.fast_forward_outlined,
                      size: 40,
                      ),
                    ),
                  ),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    // height: 400,
                    width: double.infinity,
                    child: Image(
                      image: AssetImage('assets/images/1.png'),
                    ),
                  ),
                ),
                SizedBox(height: 50,),

                Container(
                  // height: 400,
                    width: double.infinity,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: AnimatedTextKit(
                            totalRepeatCount: 1,
                            animatedTexts: [
                              TypewriterAnimatedText(

                                "Register Your Account &",
                                speed: Duration(milliseconds: 70),
                                textStyle: Theme.of(context).textTheme.headlineMedium,
                              ),
                              // TypewriterAnimatedText("Register Your Account"),
                            ],
                          ),
                        ),
                        Container(
                          child: AnimatedTextKit(
                            totalRepeatCount: 1,
                            animatedTexts: [
                              TypewriterAnimatedText(
                                "Share location marker on map",
                                speed: Duration(milliseconds: 90),
                                textAlign: TextAlign.start,
                                textStyle: Theme.of(context).textTheme.headlineMedium,
                              ),
                              // TypewriterAnimatedText("Register Your Account"),
                            ],
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
