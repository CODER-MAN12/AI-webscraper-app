import 'package:flutter/material.dart';
import 'package:frontend/pages/DataHub.dart';
import 'package:frontend/pages/PresentationMaker.dart';
import 'package:frontend/pages/SpreadSheetMaker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final TextEditingController urlInput = TextEditingController();
  final TextEditingController priorityInput = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String? errorMessage;
  String? UrlStorage;
  String outputTerminal = "Output Terminal";
  String? idStorage;
  @override
  void dispose(){
    urlInput.dispose();
    super.dispose();
  }
  void _scrollToBottom(){
    WidgetsBinding.instance.addPostFrameCallback((_){
      if(_scrollController.hasClients){
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
  void checkUrl() async{
    final text = urlInput.text.trim();

    if (text.isEmpty) {
      setState(() {
        errorMessage = "Please enter a url";
      });
      return;
    }

    final uri = Uri.tryParse(text);

    if (uri == null || (uri.scheme != 'http' && uri.scheme != 'https') || uri.host.isEmpty) {
      setState(() {
        errorMessage = "Please enter a url that starts with 'http' or 'https'";
      });
      return;
    }

    setState(() {
      errorMessage = null;
      UrlStorage = text;
    });


    try{
      final response = await http.get(Uri.parse(UrlStorage!));

      if(response.statusCode == 200){
        print("Link is good");
        print ("Response Body: ${response.body}");
        setState(() {
          outputTerminal = "Link is valid proceeding Response: ";
          _scrollToBottom();
        });
        await sendUrl();
      }else{
        print("Server returned status code: ${response.statusCode}");
        setState(() {
          outputTerminal = "Server returned status code: ${response.statusCode}";
        });
      }
    }catch (e){
      print("Failed to reach URL: $e");
      setState(() {
        outputTerminal = "Failed to reach URL: $e";
      });
    }

  }

  Future<void> sendUrl() async {
    final apiUrl = Uri.parse("http://127.0.0.1:8000/data/scraper");
    try {
      final response = await http.post(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'target_url': UrlStorage,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print("Scraper success: ${response.body}");

        final Map<String, dynamic> data = jsonDecode(response.body);
        final String id = data['id'] ?? '';
        final String organizedData = data['organizedData'] ?? '';
        final List<dynamic> rawDataList = data['rawData'] ?? [];

        setState(() {
          outputTerminal = "Scrape Complete!\n\nSummary:\n$organizedData\n\nExtracted ${rawDataList.length} lines of text.";
          _scrollToBottom();
          idStorage = id;
        });



        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/history.json');
        List<dynamic> historyList = [];


        if (await file.exists()) {
          String content = await file.readAsString();
          if (content.isNotEmpty) {
            try {
              historyList = jsonDecode(content);
            } catch (e) {
              print("Error parsing existing JSON: $e");
            }
          }
        }


        historyList.add({
          'URL': UrlStorage,
          'ID': idStorage,
        });


        await file.writeAsString(jsonEncode(historyList));
        print("Saved to ${file.path}");

      } else {
        print("Scraper error: ${response.statusCode} - ${response.body}");
        setState(() {
          outputTerminal = "Backend returned status ${response.statusCode}:\n${response.body}";
          _scrollToBottom();
        });
      }
    } catch (e) {
      print("Failed to send URL to scraper: $e");
      setState(() {
        outputTerminal = "Failed to send request: $e";
        _scrollToBottom();
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "INFO",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Color(0xFF1B004A),
          ),
        ),
        backgroundColor: Colors.amber,
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: urlInput,
              decoration: InputDecoration(
                errorText: errorMessage,
                labelText: "Enter Website URL",
                hintText: "https://example.com",
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0xFF1B004A),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0xFF1B004A),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.red,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.red,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(5),
                )
              ),
            ),
            ElevatedButton(
              onPressed: () {
                checkUrl();
                print(errorMessage);
              },
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
              child: const Text("Enter"),
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
                  controller: _scrollController,
                    child: Text(outputTerminal),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}