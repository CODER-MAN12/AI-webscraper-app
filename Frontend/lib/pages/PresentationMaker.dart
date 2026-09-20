import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/pages/Menu.dart';
import 'package:frontend/pages/DataHub.dart';
import 'package:frontend/pages/SpreadSheetMaker.dart';
import 'package:http/http.dart' as http;

class Presentationmaker extends StatefulWidget {
  const Presentationmaker({super.key});

  @override
  State<Presentationmaker> createState() => _PresentationmakerState();
}

class _PresentationmakerState extends State<Presentationmaker> {
  String outputText = "Output terminal";

  Future<void> sendId() async {
    setState(() {
      outputText = "Generating presentation...";
    });

    try {
      final apiUrl = Uri.parse("http://127.0.0.1:8000/data/pptx");
      final response = await http.post(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id': IdInput.text,
          'prompt': PromptInput.text,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> data1 = jsonDecode(response.body);
        final String exportedFile = data1['exported_file'] ?? 'Unknown path';
        setState(() {
          outputText = "Done!\nSaved to: $exportedFile";
        });
      } else {
        setState(() {
          outputText = "Error: Server responded with status ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        outputText = "Connection failed: $e";
      });
    }
  }

  final TextEditingController IdInput = TextEditingController();
  final TextEditingController PromptInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          "Presentation Maker",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        backgroundColor: Colors.amber,
        child: Column(
          children: [
            DrawerHeader(
              child: Icon(
                Icons.menu,
                size: 100,
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Menu()),
                );
              },
              leading: const Icon(Icons.circle_outlined),
              title: const Text(
                "Menu",
                style: TextStyle(fontSize: 25),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DataHub()),
                );
              },
              leading: const Icon(Icons.circle_outlined),
              title: const Text(
                "Data Hub",
                style: TextStyle(fontSize: 25),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SpreadSheetMaker()),
                );
              },
              leading: const Icon(Icons.circle_outlined),
              title: const Text(
                "Spread Sheet Maker",
                style: TextStyle(fontSize: 25),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Presentationmaker()),
                );
              },
              leading: const Icon(Icons.circle_outlined),
              title: const Text(
                "Presentation maker",
                style: TextStyle(fontSize: 25),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: IdInput,
              decoration: InputDecoration(
                hintText: "Enter ID",
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF1B004A), width: 2.5)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF1B004A), width: 2.5)),
              ),
            ),
            TextField(
              controller: PromptInput,
              decoration: InputDecoration(
                  hintText: " Enter How you want the presentation",
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF1B004A),
                        width: 2.5,
                      )),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF1B004A),
                        width: 2.5,
                      ))),
            ),
            ElevatedButton(
                onPressed: () {
                  sendId();
                  print("active");
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Color(0xFFCDF760),
                    textStyle: TextStyle(
                      fontSize: 20,
                    )),
                child: Text("Enter")),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Color(0xFFFFAC05), width: 4),
                    borderRadius: BorderRadius.circular(10)),
                child: SingleChildScrollView(
                  child: Text(
                    outputText,
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}