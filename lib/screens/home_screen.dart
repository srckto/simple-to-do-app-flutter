import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_to_do_app/database/DbHelper.dart';

class HomeScreen extends StatefulWidget {

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    DbHelper.getDataFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        actions: [
          TextButton(
            onPressed: () async {
              await DbHelper.deletDataFromDatabase();
            },
            child: Text(
              "Delete All Task",
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          )
        ],
      ),
      body: Obx(
        () => ListView.separated(
          separatorBuilder: (BuildContext, int) => SizedBox(height: 10),
          itemCount: DbHelper.tasks.length,
          itemBuilder: (BuildContext context, int index) {
            return Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.indigo,
                  child: Text(
                    DbHelper.tasks[index]["time"].toString(),
                    style: TextStyle(fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                  radius: 35,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DbHelper.tasks[index]["title"].toString(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 5),
                        Text(
                          DbHelper.tasks[index]["date"].toString(),
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //Spacer(),
                TextButton(
                  onPressed: () async {
                    await DbHelper.updateTaskToDone(DbHelper.tasks[index]["id"]);
                  },
                  child: Text("Complete"),
                ),
                TextButton(
                  onPressed: () async {
                    await DbHelper.deleteSingleTask(DbHelper.tasks[index]["id"]);
                  },
                  child: Text(
                    "Delete",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    await DbHelper.updateTaskToArchive(DbHelper.tasks[index]["id"]);
                  },
                  icon: Icon(Icons.archive_rounded),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
