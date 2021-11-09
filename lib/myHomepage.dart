import 'package:flutter/material.dart';
import 'constants.dart';
import 'rusable_widgets/dafualtformfield.dart';
import 'screens/newtasks.dart';
import 'screens/donetasks.dart';
import 'screens/archivedtasks.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
class MyHomepage extends StatefulWidget {

  const  MyHomepage({Key? key}) : super(key: key);

  @override
  _MyHomepageState createState() => _MyHomepageState();
}

class _MyHomepageState extends State<MyHomepage> {

   var scafflodkey = GlobalKey<ScaffoldState>();
   var formkey = GlobalKey<FormState>();

   late Database database;
  bool isbottomsheetclosed = true;

   var titlecontroller = TextEditingController();
   var timeecontroller = TextEditingController();
   var dateecontroller = TextEditingController();

  void initState() {

    create_database();
    super.initState();
  }
  var currentIndex = 0;

  List title = [
    " New tasks",
    " done tasks",
    " archived tasks",
  ];


  List screens = [
    newscreens(),
    donescreen(),
    archivedscreen(),
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      key: scafflodkey,
      appBar: AppBar(
        title: Text(title[currentIndex]),
      ),
      body: screens[currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print( tasks );
          if(isbottomsheetclosed)
            {

              scafflodkey.currentState?.showBottomSheet((context) => Container(
              color: Colors.white,
              padding: EdgeInsets.all(20),
              child: Form(
               key: formkey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    defaultFormFeild(
                        controller: titlecontroller,
                        type: TextInputType.text,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return " title must not be empty ";
                          }
                          return null;
                        },
                        label: "tasks title",
                        prefix: Icons.title),
                    SizedBox(
                      height: 15,
                    ),
                    defaultFormFeild(
                        controller: timeecontroller,
                        type: TextInputType.datetime,
                        onTap: () {
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          ).then((value) {
                            timeecontroller.text =
                                value!.format(context).toString();
                          });
                        },
                        validate: (value) {
                          if (value!.isEmpty) {
                            return " time must not be empty ";
                          }
                          return null;
                        },
                        label: "tasks time",
                        prefix: Icons.watch_later_outlined),
                    SizedBox(
                      height: 15,
                    ),
                    defaultFormFeild(
                        controller: dateecontroller,
                        type: TextInputType.datetime,
                        onTap: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2050),
                          ).then((value) {
                            dateecontroller.text =
                                DateFormat.yMMMd().format(value!);
                          });
                        },
                        validate: (value) {
                          if (value!.isEmpty) {
                            return " date must not be empty ";
                          }
                          return null;
                        },
                        label: "tasks date",
                        prefix: Icons.calendar_today),
                  ],
                ),
              ),
            ),

            );

            isbottomsheetclosed = false;
          }
          else
            {
              insert_database (
                  title: titlecontroller.text,
                  date: dateecontroller.text,
                  time: timeecontroller.text);

              Navigator.pop(context);
              isbottomsheetclosed = true;
            }
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: ' new tasks'),
          BottomNavigationBarItem(
              icon: Icon(Icons.done_all), label: ' done tasks'),
          BottomNavigationBarItem(
              icon: Icon(Icons.archive_outlined), label: ' archived tasks'),
        ],
      ),
    );
  }

  void create_database() async {
    database = await openDatabase('todo.db', version: 1,
        onCreate: (database, version) {
          print(" database created");
          database.execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
              .then((value) {
            print(" table created");
          }).catchError((onError) {
            print(" while table created ${onError.tostring }");
          });
        },
        onOpen: (database) {
          print(" database opened ");
          getDataFromDatabase(database).then((value) {
            setState(() {
              tasks=value;
              print (tasks);
            });

          });
        }
    ).catchError((onError) {
      print(" while database created ${onError.tostring }");
    });
  }

  void insert_database({
    required String title,
    required String date,
    required String time,
  }) async {
    database.transaction((txn) async{
     await txn.rawInsert(
          'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")')
          .then((value) {

        print('$value inserted successfully');


      }).catchError((error) {

        print('Error when Inserting New Record ${error.toString()}');

      });
    });
  }

  Future <List> getDataFromDatabase(database) async{

    return await database.rawQuery("select *from tasks ");
  }

}
