import 'package:flutter/material.dart';
import 'package:notes/dbhelper.dart';
import 'package:notes/insertpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqlite_api.dart';

class ViewPage extends StatefulWidget {
  const ViewPage({Key? key}) : super(key: key);

  @override
  State<ViewPage> createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  Database? db;
  bool? statusvert;


  @override
  void initState() {
    super.initState();
    getdata();
    storepref();
  }

  Future<List<Map<String, Object?>>> getdata() async {
    db = await dbhelper().createDatabase();
    String qry = "select * from test";
    List<Map<String, Object?>> l1 = await db!.rawQuery(qry);
    return l1;
  }
  storepref() async {
    Utils.prefs=await SharedPreferences.getInstance();
    statusvert=Utils.prefs!.getBool('statusvert') ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
                return InsertPage();
              },
            ));
          },
          child: Text("Add"),
        ),
        appBar: AppBar(
          title: Text("Notes"),
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                  barrierColor: Colors.transparent,
                  barrierDismissible: true,
                  builder: (context) {
                    return Column(
                      children: [
                        TextButton(
                            onPressed: () async {
                              await Utils.prefs!.setBool('statusvert', true);
                              setState(() {
                              });
                            },
                            child: Text(
                              "List",
                              style: TextStyle(color: Colors.black),
                            )),
                        TextButton(
                            onPressed: () async {
                              await Utils.prefs!.setBool('statusvert', false);
                              setState(() {
                              });
                              print(statusvert);
                            },
                            child: Text(
                              "Grid",
                              style: TextStyle(color: Colors.black),
                            ))
                      ],
                    );
                  },
                  context: context,
                );
              },
              icon: Icon(Icons.more_vert),
            ),
          ],
        ),
        body: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              List<Map<String, Object?>> l =
                  snapshot.data as List<Map<String, Object?>>;
              if (snapshot.hasData) {
                print("body= $statusvert");
                statusvert=Utils.prefs!.getBool('statusvert') ?? true;
                return l.length > 0
                    ? (statusvert!
                        ? ListView.separated(
                            separatorBuilder: (context, index) {
                              return Container(
                                  margin: EdgeInsets.only(left: 16),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(width: .4))));
                            },
                            itemCount: l.length,
                            itemBuilder: (context, index) {
                              Map m = l[index];
                              print(m['title']);
                              return ListTile(
                                onLongPress: () {
                                  showDialog(
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("Delete"),
                                          content: Text(
                                              "Are you sure you want to DELETE"),
                                          actions: [
                                            TextButton(
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                  String qry =
                                                      "delete from Test where id='${m['id']}' ";
                                                  await db!.rawDelete(qry);
                                                  setState(() {});
                                                },
                                                child: Text("Yes")),
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("No"))
                                          ],
                                        );
                                      },
                                      context: context);
                                },
                                onTap: () {
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(
                                    builder: (context) {
                                      return InsertPage(
                                        m: m,
                                      );
                                    },
                                  ));
                                },
                                title: Text("${m['title']}"),
                                subtitle: Text(
                                  "${m['content']}",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            },
                          )
                        : GridView.builder(
                            itemCount: l.length,
                            itemBuilder: (context, index) {
                              Map m = l[index];
                              print(m['title']);
                              return Card(
                                clipBehavior: Clip.antiAlias,
                                child: ListTile(
                                  onLongPress: () {
                                    showDialog(
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text("Delete"),
                                            content: Text(
                                                "Are you sure you want to DELETE"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () async {
                                                    Navigator.pop(context);
                                                    String qry =
                                                        "delete from Test where id='${m['id']}' ";
                                                    await db!.rawDelete(qry);
                                                    setState(() {});
                                                  },
                                                  child: Text("Yes")),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("No"))
                                            ],
                                          );
                                        },
                                        context: context);
                                  },
                                  onTap: () {
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(
                                      builder: (context) {
                                        return InsertPage(
                                          m: m,
                                        );
                                      },
                                    ));
                                  },
                                  title: Text("${m['title']}"),
                                  subtitle: Text(
                                    "${m['content']}",
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              );
                            },
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                          ))
                    : Center(
                        child: Text("No data found"),
                      );
              }
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
          future: getdata(),
        ));
  }
}
