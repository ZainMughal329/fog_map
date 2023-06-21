import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fog_map/views/mapView/controller.dart';
import 'package:fog_map/views/mapView/index.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final con = Get.put(GMapController());

  Widget _buildSelectVehicle(
      String vehicleType, String vehicleLogo, BuildContext context) {
    return  GestureDetector(
      onTap: () {
        if (vehicleType == 'Car') {
          con.vehicleType = 'Car';
          // showDialog(
          //     context: context,
          //     builder: (context) {
          //       return AlertDialog(
          //         title: Text('Enter Model Number : '),
          //         actions: [
          //           TextButton(
          //             onPressed: () {
          //               Navigator.pop(
          //                   context); // Close the dialog
          //               con
          //                   .showFeedbackDialog(context);
          //             },
          //             child: Text(
          //               'Yes',
          //               style: TextStyle(color: Colors.red),
          //             ),
          //           ),
          //           TextButton(
          //             onPressed: () {
          //               // Action when "No" is clicked
          //               Navigator.pop(
          //                   context); // Close the dialog
          //               // TODO: Perform some other action
          //             },
          //             child: Text(
          //               'No',
          //               style:
          //               TextStyle(color: Colors.black),
          //             ),
          //           ),
          //         ],
          //       );
          //     });
          con.showFeedbackDialog(context);
        } else if (vehicleType == 'Bus') {
          con.vehicleType = 'Bus';
          // showDialog(
          //     context: context,
          //     builder: (context) {
          //       return AlertDialog(
          //         title: Text('Enter Model Number : '),
          //         actions: [
          //           TextButton(
          //             onPressed: () {
          //               Navigator.pop(
          //                   context); // Close the dialog
          //               con
          //                   .showFeedbackDialog(context);
          //             },
          //             child: Text(
          //               'Yes',
          //               style: TextStyle(color: Colors.red),
          //             ),
          //           ),
          //           TextButton(
          //             onPressed: () {
          //               // Action when "No" is clicked
          //               Navigator.pop(
          //                   context); // Close the dialog
          //               // TODO: Perform some other action
          //             },
          //             child: Text(
          //               'No',
          //               style:
          //               TextStyle(color: Colors.black),
          //             ),
          //           ),
          //         ],
          //       );
          //     });
          con.showFeedbackDialog(context);
        } else if (vehicleType == 'Bike') {
          con.vehicleType = 'Bike';
          // showDialog(
          //     context: context,
          //     builder: (context) {
          //       return AlertDialog(
          //         title: Text('Enter Model Number : '),
          //         actions: [
          //           TextButton(
          //             onPressed: () {
          //               Navigator.pop(
          //                   context); // Close the dialog
          //               con
          //                   .showFeedbackDialog(context);
          //             },
          //             child: Text(
          //               'Yes',
          //               style: TextStyle(color: Colors.red),
          //             ),
          //           ),
          //           TextButton(
          //             onPressed: () {
          //               // Action when "No" is clicked
          //               Navigator.pop(
          //                   context); // Close the dialog
          //               // TODO: Perform some other action
          //             },
          //             child: Text(
          //               'No',
          //               style:
          //               TextStyle(color: Colors.black),
          //             ),
          //           ),
          //         ],
          //       );
          //     });
          con.showFeedbackDialog(context);
        } else {
          con.vehicleType = 'none';
          Get.to(() => GMapScreen());
        }
      },
      child: Container(
        height: 54.h,
        width: 280.w,
        padding: EdgeInsets.all(10.w),
        margin: EdgeInsets.only(bottom: 15.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: vehicleLogo == ''
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            vehicleLogo == ''
                ? Container()
                : Container(
              padding: EdgeInsets.only(left: 30.w, right: 25.w),
              child: Image.asset('$vehicleLogo.png'),
            ),
            Text(
              'Your vehicle type $vehicleType',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.sp,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 50.h, horizontal: 0.w),
            child: Column(
              children: [
                _buildSelectVehicle('Car', 'assets/images/car', context),
                _buildSelectVehicle('Bus', 'assets/images/bus', context),
                _buildSelectVehicle('Bike', 'assets/images/bycicle', context),
                _buildSelectVehicle('Nothing', 'assets/images/walk', context),
                // _buildSelectVehicle('Car', 'assets/images/car'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
