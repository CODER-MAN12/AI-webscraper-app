import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Container(
              height: 300,
              width: 300,
              color: Colors.indigo[200],
            ),

            Container(
              height: 100,
              width: 100,
              color: Colors.indigo[100],
            ),

            Container(
              height: 100,
              width: 100,
              color: Colors.indigo[500],
            ),
          ]
        ),


      ),

    );
  }
}

