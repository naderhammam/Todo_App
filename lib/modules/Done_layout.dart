import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lap6/shared/components/constants.dart';

import 'package:lap6/shared/components/components.dart';
import 'package:lap6/shared/cubit/cubit.dart';
import 'package:lap6/shared/cubit/states.dart';

class Done_Layout extends StatelessWidget {
  const Done_Layout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AppCubit,AppState>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, Object? state) {
        var tasks = AppCubit.get(context).doneTasks;
        return ListView.separated(
          itemBuilder: (context, index) => buildItem(tasks[index],context),
          separatorBuilder: (context, index) => Padding(
            padding: const EdgeInsetsDirectional.only(start: 20),
            child: Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey[400],
            ),
          ),
          itemCount: tasks.length,
        );
      },
    );

  }}
