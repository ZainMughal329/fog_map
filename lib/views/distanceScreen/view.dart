import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fog_map/reuseable/session_manager.dart';
import 'package:fog_map/views/distanceScreen/controller.dart';
import 'package:get/get.dart';

class DistanceScreen extends StatelessWidget {
   DistanceScreen({Key? key}) : super(key: key);
  final controller = Get.put<DistanceController>(DistanceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: controller.ref.onValue,
          builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
            //   if(!snapshot.hasData){
            //     return CircularProgressIndicator();
            //   }else{
            //     print(snapshot.data!.snapshot.value);
            //     print("Inside else block");
            //     print("Va;ies" +snapshot.data!.snapshot.value.toString());
            //     Map<dynamic,dynamic> map = snapshot.data!.snapshot.value as Map<dynamic,dynamic>;
            //     print("Map value is");
            //     print(map.toString());
            //
            //     List<dynamic> list=[];
            //     list.clear();
            //     list = map.values.toList();
            //     return ListView.builder(
            //       itemCount: snapshot.data!.snapshot.children.length,
            //       itemBuilder: (context,index){
            //         return ListTile(
            //           title: Text(map[index]['lat'].toString()),
            //         );
            //       },
            //     );
            //   }
            // },
            if (snapshot.hasData) {
              Map<dynamic, dynamic> locationData = snapshot.data!.snapshot.value as Map<dynamic,dynamic>;
              if (locationData != null) {
                List<dynamic> childNodes = locationData.entries.toList();
                return ListView.builder(
                  itemCount: childNodes.length,
                  itemBuilder: (BuildContext context, int index) {
                    MapEntry<dynamic, dynamic> childEntry = childNodes[index];
                    String childNodeKey = childEntry.key;
                    Map<dynamic, dynamic> childNodeValue = childEntry.value;

                    // Access the values of each child node
                    double lat = childNodeValue['lat'];
                    double long = childNodeValue['long'];
                    var speed = childNodeValue['speed'];
                    String id = childNodeValue['uid'].toString();
                    String modelNo = childNodeValue['model'].toString();
                    print('lat is : ' + lat.toString());
                    print('long is : ' + long.toString());
                    print("childnodevalue"+childNodeValue.toString());
                    print("childnodes"+childNodes.toString());
                    double distance = controller.calDistance(lat,long);

                    print('distance is : ' + distance.toString());

                    // Build your UI using the child node values
                     if(id==SessionController().userId.toString()){
                      return Container();
                    }else{
                       return Padding(
                         padding: const EdgeInsets.all(10.0),
                         child: ListTile(
                           title: Text("Vehicle No : "+modelNo),
                           subtitle: Text("Speed = "+speed.toStringAsFixed(3).toString()+" m/s" ),
                           trailing: Text(distance.toString()),
                         ),
                       );
                     }
                  },
                );
              } else {
                return Text('No child nodes under location');
              }
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return CircularProgressIndicator();
            }
          }
        )

      ),
    );
  }
}
