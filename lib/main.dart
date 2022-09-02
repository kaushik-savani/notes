import 'package:flutter/material.dart';
import 'package:notes/viewpage.dart';

void main(){
  runApp(MaterialApp(home: ViewPage(),debugShowCheckedModeBanner: false,));
}

class Notes extends StatefulWidget {
  const Notes({Key? key}) : super(key: key);

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
