import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_application_3/models/task_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<TaskModel> wordList = [
    TaskModel(
      word: 'Short',
      meaning: 'small in length, height, or duration (time), or not having enough of something',
      example: 'قصير',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Refresh your mind 🧠',
          style: TextStyle(
            fontSize: 20.sp,
            color: Colors.indigo,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 191, 205, 212),
        elevation: 4.h,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16.r)
          )
        ),
      ),
      body: ListView.builder(
        itemCount: wordList.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(child: Text('${index +1}')),
            title: Text(wordList[index].word.toString(),
            style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(wordList[index].meaning),
                SizedBox(height: 2),
                Text(wordList[index].example),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue,),
                  onPressed: (){
                    TextEditingController wordController = TextEditingController(text: wordList[index].word);
                    TextEditingController meaningController = TextEditingController(text: wordList[index].meaning);
                    TextEditingController exampleController = TextEditingController(text: wordList[index].example);
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Edit Item'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: wordController,
                                decoration: InputDecoration(labelText: 'Word'),
                              ),
                              TextField(
                                controller: meaningController,
                                decoration: InputDecoration(labelText: 'Meaning'),
                              ),
                              TextField(
                                controller: exampleController,
                                decoration: InputDecoration(labelText: 'Example'),
                              ),
                            ],
                          ),
                          actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    wordList[index].word = wordController.text;
                                    wordList[index].meaning = meaningController.text;
                                    wordList[index].example = exampleController.text;
                                  });
                                  Navigator.pop(context);
                                },
                                child: Text('Save'),
                              )
                          ],
                        );
                      }
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red,),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Delete Confirmation'),
                          content: Text('Are you sure you want to delete this item?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Cancel'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                              onPressed: () {
                                setState(() {
                                  wordList.removeAt(index);
                                });
                                Navigator.pop(context);
                              },
                              child: Text('Delete', style: TextStyle(color: Colors.white),),
                            ),
                          ],
                        );
                      }
                    );
                  }
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
