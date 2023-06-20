import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
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
            if(!snapshot.hasData){
              return CircularProgressIndicator();
            }else{
              Map<dynamic,dynamic> map = snapshot.data!.snapshot.value as dynamic;
              List<dynamic> list=[];
              list.clear();
              list = map.values.toList();
              return ListView.builder(
                itemCount: snapshot.data!.snapshot.children.length,
                itemBuilder: (context,index){
                  return ListTile(
                    title: Text(""),
                  );
                },
              );
            }
          },

        )

      ),
    );
  }
}
