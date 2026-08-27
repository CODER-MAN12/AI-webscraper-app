import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  MyApp({super.key});
  List names = ["Agam", "Agam"];
  @override
  Widget build(BuildContext context){
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ,

    );
  }
}


//home: Scaffold(
//body: Stack()Combines widgets very cool
//GestureDestructures are input
//body: Center(
//child: GestureDetector(
//onDoubleTap: () {
//print("Gesture Detected");
//},
//child: Container(
//height: 200,
//width: 200,
//color: Colors.indigo,
//child: Center(child:Text("Hi"),)
//),
//),

//),
//),