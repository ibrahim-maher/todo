import 'package:flutter/material.dart';
import 'package:todoapp/rusable_widgets/dafualtformfield.dart';

import '../constants.dart';
class newscreens extends StatelessWidget {
  const newscreens({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context,index) =>buildTaksItem (tasks[index],context),
        separatorBuilder: (context,index) => Container(),
        itemCount: tasks.length ) ;
  }
}
