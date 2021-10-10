import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_to_do_app/database/DbHelper.dart';

class ArchiveScreen extends StatelessWidget {
  const ArchiveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DbHelper.getArchiveTasks();

    return Scaffold(
      appBar: AppBar(
        title: Text("Done Page"),
      ),
      body: Obx(
        () => ListView.separated(
          separatorBuilder: (BuildContext, int) => SizedBox(height: 10),
          itemCount: DbHelper.archiveTask.length,
          itemBuilder: (BuildContext context, int index) {
            return Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.indigo,
                  child: Text(
                    DbHelper.archiveTask[index]["time"].toString(),
                    style: TextStyle(fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                  radius: 35,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DbHelper.archiveTask[index]["title"].toString(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5),
                      Text(
                        DbHelper.archiveTask[index]["date"].toString(),
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
              ],
            );
          },
        ),
      ),
    );
  }
}
