import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:fog_map/sigin/view.dart';
import 'package:get/get.dart';

class ScreenTwo extends StatelessWidget {
  const ScreenTwo({Key? key}) : super(key: key);

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
                      image: AssetImage('assets/images/3.png'),
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

                        Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                              child: Text("Location continuously updates \nwith  physical location",
                                style: Theme.of(context).textTheme.headlineMedium,)
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ],
        )
      ),
    );
  }
}
