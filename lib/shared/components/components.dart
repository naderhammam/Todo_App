import 'package:flutter/material.dart';

import '../cubit/cubit.dart';


Widget buildItem (Map model,context) => Dismissible(
 key: Key(model['id'].toString()),
  onDismissed: (direction){
    AppCubit.get(context).deleteDataBase(id: model['id']);
  },
  child:Padding(

    padding: const EdgeInsets.all(20.0),

    child: Row(

      children: [

         CircleAvatar(

          radius: 45,

          backgroundColor: Colors.deepOrange[500],

          child: Text(

            '${model['time']}',

            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),

          ),

        ),

        const SizedBox(

          width: 20,

        ),

        Expanded(

          child: Column(

            mainAxisSize: MainAxisSize.min,

            crossAxisAlignment: CrossAxisAlignment.start,

            children:  [

              Text(

                '${model['title']}',

                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),

              ),

              Text(

                '${model['date']}',

                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold,color: Colors.grey),

              ),

            ],

          ),

        ),

        const SizedBox(

          width: 20,

        ),

        IconButton(onPressed: (){

          AppCubit.get(context).updateDataBase(status: 'done', id: model['id']);

        }, icon: const Icon(Icons.check_box_outlined,color: Colors.green,)),

        IconButton(onPressed: (){

          AppCubit.get(context).updateDataBase(status: 'archive', id: model['id']);

        }, icon: const Icon(Icons.archive,color: Colors.black45,)),

      ],

    ),

  ),
);