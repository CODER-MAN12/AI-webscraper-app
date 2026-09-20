import 'package:flutter/material.dart';
import 'package:frontend/pages/Menu.dart';
import 'package:frontend/pages/DataHub.dart';
import 'package:frontend/pages/PresentationMaker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SpreadSheetMaker extends StatefulWidget {
  const SpreadSheetMaker({super.key});

  @override
  State<SpreadSheetMaker> createState() => _MyAppState();
}

class _MyAppState extends State<SpreadSheetMaker> {
  final TextEditingController IdInput = TextEditingController();
  final TextEditingController PromptInput = TextEditingController();

  String _outputText = 'Output terminal';
  bool _isLoading = false;

  Future<void> sendId() async {
    setState(() {
      _isLoading = true;
      _outputText = 'Creating spreadsheet...';
    });

    try {
      final apiUrl = Uri.parse("http://127.0.0.1:8000/data/excel");
      final response = await http.post(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id': IdInput.text,
          'prompt': PromptInput.text
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> data1 = jsonDecode(response.body);
        final String filePath = data1['exported_file'] ?? '';
        setState(() {
          _outputText = 'Created successfully!\n\nFile saved at:\n$filePath';
        });
      } else {
        setState(() {
          _outputText = 'Error: Failed with status code ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _outputText = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    IdInput.dispose();
    PromptInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text(
          "Spread Sheet",
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
            const DrawerHeader(
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
                  borderSide: const BorderSide(
                    color: Color(0xFF1B004A),
                    width: 2.5,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF1B004A),
                    width: 2.5,
                  ),
                ),
              ),
            ),
            // TextField(
            //   controller: PromptInput,
            //   maxLines: 15,
            //   minLines: 1,
            //   decoration: InputDecoration(
            //     hintText: "Enter how you want the spreadsheet",
            //     enabledBorder: OutlineInputBorder(
            //       borderSide: const BorderSide(
            //         color: Color(0xFF1B004A),
            //         width: 2.5,
            //       ),
            //       borderRadius: BorderRadius.circular(5),
            //     ),
            //     focusedBorder: const OutlineInputBorder(
            //       borderSide: BorderSide(
            //         color: Color(0xFF1B004A),
            //         width: 2.5,
            //       ),
            //     ),
            //   ),
            // ),
            ElevatedButton(
              onPressed: _isLoading ? null : sendId,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                backgroundColor: const Color(0xFFCDF760),
                textStyle: const TextStyle(
                  fontSize: 20,
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2)
              )
                  : const Text("Enter"),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFFFAC05), width: 4),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _outputText,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}