import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/pages/Menu.dart';
import 'package:frontend/pages/SpreadSheetMaker.dart';
import 'package:frontend/pages/PresentationMaker.dart';
import 'package:flutter/services.dart';

class DataHub extends StatefulWidget {
  const DataHub({super.key});

  @override
  State<DataHub> createState() => _DataHubState();
}

class _DataHubState extends State<DataHub> {
  Future<List<dynamic>> loadHistory() async{
    final file = File('lib/data/history.json');
    if (await file.exists()){
      String content = await file.readAsString();
      if (content.isNotEmpty) {
        return jsonDecode(content);
      }
    }
    return [];
  }
  Future<void> deleteHistory(int index) async{
    final file = File('lib/data/history.json');
    if (await file.exists()){
      String content = await file.readAsString();
      if (content.isNotEmpty) {
        List<dynamic> historyList = jsonDecode(content);
        historyList.removeAt(index);
        await file.writeAsString(jsonEncode(historyList));
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text(
          "Data Hub",
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

      body: FutureBuilder<List<dynamic>>(
        future: loadHistory(),
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty){
            return const Center(
              child: Text("No history available", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
            );
          }

          final historyList = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: historyList.length,
            itemBuilder: (context, index){
              final item = historyList[index];
              final String url = item['URL'] ?? 'No URL';
              final String id = item['ID'] ?? 'No ID';

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6.0),
                child: ExpansionTile(
                  title: Text(
                    url,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red,),
                    onPressed: () async{
                      await deleteHistory(index);
                      setState(() {});
                    },
                  ),
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "ID: $id",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          
                          IconButton(
                            icon: const Icon(Icons.copy),
                            onPressed: (){
                              Clipboard.setData(ClipboardData(text: id));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("ID copied to clipboard!", ),duration: Duration(seconds: 2)

                                )
                              );
                            },
                          )
                        ],
                      ),
                    )
                  ],
                )
              );
            }
          );
        }
      )

    );
  }
  }
