// import 'package:flutter/material.dart';
// import 'package:fog_map/views/mapView/controller.dart';
// import 'package:get/get.dart';
//
// class ShowDistanceScreen extends StatelessWidget {
//   const ShowDistanceScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(MapController());
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Distance to Markers'),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Obx(
//             () => Text(
//               controller.currentLocation.toString(),
//             ),
//           ),
//           Expanded(
//             child: Obx(
//               () => controller.addInDistanceList().length != 0 ? ListView.builder(
//                 itemCount: controller.addInDistanceList().length,
//                 itemBuilder: (context, index) {
//                   print('MarkerList length is' + controller.markerList.length.toString());
//                   print('DistanceList length is' + controller.addInDistanceList().length.toString());
//
//                   return  ListTile(
//                     title: Text(
//                       'Marker ${index + 1}',
//                     ),
//                     subtitle: Text(
//                       'Distance: ${controller.addInDistanceList()[index]} km',
//
//                     ),
//                   ) ;
//                 },
//
//               ): Center(child: Text('No item there')),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
