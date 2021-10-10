import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_to_do_app/database/DbHelper.dart';
import 'package:simple_to_do_app/screens/archive_screen.dart';
import 'package:simple_to_do_app/screens/done_screen.dart';
import 'package:simple_to_do_app/screens/home_screen.dart';

class HomeLayout extends StatefulWidget {
  HomeLayout({Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int currentIndex = 0;

  TextEditingController _titleController = TextEditingController();

  List<Map<String, dynamic>> _pages = [
    {
      "title": "Home Page",
      "page": HomeScreen(),
    },
    {
      "title": "Done Page",
      "page": DoneScreen(),
    },
    {
      "title": "Archive Page",
      "page": ArchiveScreen(),
    },
  ];
  bool isSheetBottomShown = false;
  DateTime _getDate = DateTime.now();
  TimeOfDay _getTime = TimeOfDay.now();
  GlobalKey<ScaffoldState> _sheetBottomKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _sheetBottomKey,
      
      body: _pages[currentIndex]["page"],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (int value) {
          setState(() {
            currentIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(
              Icons.home_outlined,
            ),
          ),
          BottomNavigationBarItem(
            label: "Done",
            icon: Icon(
              Icons.done,
            ),
          ),
          BottomNavigationBarItem(
            label: "Archive",
            icon: Icon(
              Icons.archive_outlined,
            ),
          ),
        ],
      ),
      floatingActionButton: currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                if (isSheetBottomShown) {
                  Navigator.pop(context);
                  setState(() {
                    isSheetBottomShown = false;
                  });
                } else {
                  _showBottomSheet();
                  setState(() {
                    isSheetBottomShown = true;
                  });
                }
              },
              child: Icon(isSheetBottomShown ? Icons.close : Icons.edit),
            )
          : null,
    );
  }

  Future _submitData() async {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context);
      await DbHelper.insertToDatabase(
        title: _titleController.text,
        date: DateFormat.yMMMd().format(_getDate),
        time: _getTime.format(context),
      ).then((value) {
        DbHelper.getDataFromDatabase();
        _titleController.clear();
        setState(() {
          isSheetBottomShown = false;
        });
      });
    }
  }

  _showBottomSheet() {
    _sheetBottomKey.currentState!
        .showBottomSheet(
          (context) {
            return StatefulBuilder(
              builder: (BuildContext context, void Function(void Function()) setState) {
                return Container(
                  padding: EdgeInsets.only(top: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                width: 2,
                                color: Colors.grey,
                              ),
                            ),
                            child: TextFormField(
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.title,
                                  color: Colors.grey,
                                ),
                                label: Text("Insert Title"),
                                border: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                              ),
                              controller: _titleController,
                              validator: (String? value) {
                                if (_titleController.text.trim().isEmpty) {
                                  return "Please Insert a title";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                width: 2,
                                color: Colors.grey,
                              ),
                            ),
                            child: TextFormField(
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: DateFormat.yMMMd().format(_getDate),
                                prefixIcon: Icon(Icons.calendar_today),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                              ),
                              onTap: () async {
                                await showDatePicker(
                                  context: context,
                                  initialDate: _getDate,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2025),
                                ).then((value) {
                                  if (value != null) {
                                    setState(() {
                                      _getDate = value;
                                    });
                                  }
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                width: 2,
                                color: Colors.grey,
                              ),
                            ),
                            child: TextFormField(
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: _getTime.format(context),
                                prefixIcon: Icon(Icons.alarm),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                              ),
                              onTap: () async {
                                await showTimePicker(context: context, initialTime: _getTime).then((value) {
                                  if (value != null) {
                                    setState(() {
                                      _getTime = value;
                                    });
                                  }
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 15),
                          ElevatedButton(
                            onPressed: () async {
                              await _submitData();
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 13,
                                horizontal: 20,
                              ),
                            ),
                            child: Text("Add Task"),
                          ),
                          SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        )
        .closed
        .then((value) {
          setState(() {
            _titleController.clear();
            isSheetBottomShown = false;
          });
        });
  }
}
