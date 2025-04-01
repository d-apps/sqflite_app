import 'package:flutter/material.dart';
import 'package:sqflite_app/src/sql_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> allData = [];

  bool isLoading = true;

  Future<void> getData() async {
    titleController.clear();
    descController.clear();
    final data = await SQLHelper.getAllData();
    setState(() {
      allData = data;
      isLoading = false;
    });
  }

  Future<void> addData() async {
    isLoading = true;
    await SQLHelper.createData(titleController.text, descController.text);
    await getData();
  }

  Future<void> updateData(int id) async {
    isLoading = true;
    await SQLHelper.updateData(id, titleController.text, descController.text);
    await getData();
  }

  Future<void> removeItem(int id) async {
    isLoading = true;
    await SQLHelper.deleteData(id);
    await getData();
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  final titleController = TextEditingController();
  final descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 16, bottom: 16),
        child: isLoading ? Center(
          child: CircularProgressIndicator(),
        ) :  Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: allData.length,
                itemBuilder: (context, index){
                  final item = allData[index];

                  return ListTile(
                    title: Text(item["title"]),
                    subtitle: Text(item["desc"]),
                    leading: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: (){

                        titleController.text = item["title"];
                        descController.text = item["desc"];

                        showModalBottomSheet(
                            context: context,
                            builder: (context){
                              return Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: titleController,
                                      decoration: InputDecoration(
                                          hintText: "Title"
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      controller: descController,
                                      decoration: InputDecoration(
                                          hintText: "Desc"
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                      onPressed: (){
                                        updateData(
                                            item["id"],
                                        );
                                        Navigator.of(context).pop();
                                      },
                                      child: Icon(Icons.play_arrow)
                                  )
                                ],
                              );
                            }
                        );
                      },
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: (){
                        removeItem(item["id"]);
                      },
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: "Title"
                    ),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: descController,
                    decoration: InputDecoration(
                        hintText: "Desc"
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: (){
                      addData();
                    },
                    child: Icon(Icons.play_arrow)
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
