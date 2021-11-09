import 'package:flutter/material.dart';
import 'package:buildcondition/buildcondition.dart';

Widget defaultFormFeild({
  required TextEditingController controller,
  required TextInputType type,
  required String? Function(String?) validate,
  required String label,
  required IconData prefix,
  Function()? onTap,
  bool isPassword = false,
  bool isClickable = true,
  IconData? suffix,
  Function()? suffixPressed,
}) =>
    TextFormField(
      validator: validate,
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      onTap: onTap,
      enabled: isClickable,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefix),
        suffixIcon: IconButton(
          onPressed: suffixPressed,
          icon: Icon(suffix),
        ),
        border: OutlineInputBorder(),
      ),
    );


Widget buildTaksItem (Map model, BuildContext context) => Dismissible(
  child:   Padding(

    padding: const EdgeInsets.all(20.0),

    child: Row(

      children: [

        CircleAvatar(

          radius: 40,

          child: Text ( '${model["time"]}'),



        ),

        SizedBox(width: 20,),

        Expanded(

          child: Column(

            mainAxisSize: MainAxisSize.min,

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Text( '${model["title"]}',

                style: TextStyle(

                    fontSize: 18

                    ,fontWeight: FontWeight.bold),

              ),

              Text(

                  " '${model["date"]}'",

                  style: TextStyle(

                      color: Colors.grey)

              ),

            ],

          ),



        ),

        SizedBox(width: 20,),

        IconButton(

            onPressed: (){



            },

            icon:Icon(

              Icons.check_box,

              color: Colors.blueAccent,

            )),

        IconButton(

            onPressed: (){


            },

            icon:Icon( Icons.archive)),

      ],

    ),

  ),
  key: Key(model['id'].toString()),
  onDismissed: (direction)
  {

  },

);

Widget tasksBuilder({
  required List tasks

})=>BuildCondition(
  condition: tasks.length > 0,
  builder: (context)=>  ListView.separated(
      itemBuilder: (context,index)=>buildTaksItem(tasks[index],context),
      separatorBuilder: (context,index) =>Padding(
        padding: const EdgeInsetsDirectional.only(
          start: 20,
        ),
        child: Container(
          width: double.infinity,
          height: 1.0,
          color: Colors.grey[300],
        ),
      ) ,
      itemCount: 10),
  fallback:(context)=>  Center(
    child: Column (
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        Icon(Icons.menu,
          size: 100,
          color: Colors.grey,),
        Text ( " No Tasks Yet , Please Add Some Tasks",
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey
          ),)
      ],
    ),
  ),
) ;