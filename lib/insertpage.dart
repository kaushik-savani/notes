import 'package:flutter/material.dart';
import 'package:notes/dbhelper.dart';
import 'package:notes/viewpage.dart';
import 'package:sqflite/sqlite_api.dart';

class InsertPage extends StatefulWidget {
  Map? m;

  InsertPage({this.m});

  @override
  State<InsertPage> createState() => _InsertPageState();
}

class _InsertPageState extends State<InsertPage> {
  Database? db;
  bool viewmode = false;
  Color? textcolor;
  int _textindex = 0;
  TextEditingController _content = TextEditingController();

  @override
  void initState() {
    super.initState();
    dbhelper().createDatabase().then(
      (value) {
        db = value;
      },
    );
    if (widget.m != null) {
      _content.text = "${widget.m!['content']}";
      _textindex = widget.m!['textindex'];
      viewmode = true;
    }
    textcolor = dbhelper.basecolor[_textindex];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          floatingActionButton: FloatingActionButton(onPressed: () {
            showModalBottomSheet(
                isDismissible: true,
                barrierColor: Colors.transparent,
                builder: (context) {
                  return Container(
                    height: 130,
                    margin: EdgeInsets.all(8),
                    child: Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: GridView.builder(
                            itemCount: dbhelper.basecolor.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () async {
                                  setState(() {
                                    textcolor =
                                    dbhelper.basecolor[index];
                                    _textindex = index;
                                  });
                                },
                                child: Card(
                                  color:
                                  dbhelper.basecolor[index],
                                ),
                              );
                            },
                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 8,
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.close))
                      ],
                    ),
                  );
                },
                context: context);
          },child: Icon(Icons.color_lens_outlined),),
          appBar: (viewmode)
              ? AppBar(
                  leading: IconButton(
                      onPressed: () async {
                        (widget.m == null) ? savedata() : updatedata();
                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) {
                            return ViewPage();
                          },
                        ));
                      },
                      icon: Icon(Icons.arrow_back_ios)),
                  title: Text("View"),
                )
              : AppBar(
                  leading: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) {
                          return ViewPage();
                        },
                      ));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  title: Text("Edit", textAlign: TextAlign.center),
                  actions: [
                    TextButton(onPressed: () {
                      (widget.m == null) ? savedata() : updatedata();
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) {
                          return ViewPage();
                        },
                      ));
                    }, child: Text("Done",style: TextStyle(color: Colors.white)))
                  ],
                ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: TextField(
                onTap: () {
                  viewmode = false;
                  setState(() {});
                },
                readOnly: viewmode,
                controller: _content,
                style: TextStyle(color: textcolor),
                keyboardType: TextInputType.multiline,
                textAlign: TextAlign.justify,
                autofocus: true,
                maxLines: 1000,
              ),
            ),
          ),
        ),
        onWillPop: goback);
  }

  Future<bool> goback() {
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) {
        (widget.m == null) ? savedata() : updatedata();
        return ViewPage();
      },
    ));
    return Future.value();
  }

  savedata() async {
    String title = _content.text.split(" ").elementAt(0);
    String content = _content.text;
    int textindex = _textindex;

    String qry =
        "insert into Test (title,content,textindex) values ('$title','$content','$textindex')";
    await db!.rawInsert(qry);
  }

  updatedata() async {
    String title = _content.text.split(" ").elementAt(0);
    String content = _content.text;
    int textindex = _textindex;
    String qry =
        "update Test set title='$title',content='$content',textindex='$textindex' where id='${widget.m!['id']}' ";
    await db!.rawUpdate(qry);
  }
}
