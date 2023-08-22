import 'package:flutter/material.dart';
import 'package:fog_map/reuseable/round_button.dart';
import 'package:fog_map/sigin/view.dart';
import 'package:get/get.dart';

class ScreenThree extends StatelessWidget {
  const ScreenThree({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
            padding:  EdgeInsets.only(top: 40,bottom: 20),
            child: Stack(
              children: [

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        // height: 400,
                        width: double.infinity,
                        child: Image(
                          image: AssetImage('assets/images/2.png'),
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
                                  child: Text("Get Location of Neighbouring Vehicles under 1KM",
                                    style: Theme.of(context).textTheme.headlineMedium,)
                              ),
                            ),
                          ],
                        ),
                    ),
                    SizedBox(height: 40,),

                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: RoundButton(
                          title: "Go to Login Page",
                          onPress: () {
                            Get.offAll(() => SignInPage());
                          }),
                    )

                  ],
                ),
              ],
            ),
          )
      ),
    );
  }
}
