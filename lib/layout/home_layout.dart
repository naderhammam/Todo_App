import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:lap6/shared/cubit/cubit.dart';
import 'package:lap6/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
  HomeLayout({Key? key}) : super(key: key);

  var keyScaffold = GlobalKey<ScaffoldState>();
  var formScaffold = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppCubit>(
      create: (context) => AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit, AppState>(
          builder: (BuildContext context, state) {
            AppCubit cubit = AppCubit.get(context);
            return Scaffold(
              key: keyScaffold,
              appBar: AppBar(
                title: Text(cubit.changeTitle[cubit.currentIndex]),
              ),
              floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    if (cubit.isSheet) {
                      if (formScaffold.currentState!.validate()) {
                        cubit.insertToDatabase(
                            date: dateController.text,
                            time: timeController.text,
                            title: titleController.text);

                      }
                    } else {
                      keyScaffold.currentState!
                          .showBottomSheet(
                            (context) => Container(
                              color: Colors.white,
                              padding: const EdgeInsets.all(15),
                              child: Form(
                                key: formScaffold,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      controller: titleController,
                                      keyboardType: TextInputType.text,
                                      onTap: () {
                                        print('TITLE TAPPED');
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Title Must n\'t Empty';
                                        }
                                        return null ;
                                      },
                                      decoration: const InputDecoration(
                                        label: Text('Task Title'),
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(Icons.title),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                      controller: timeController,
                                      onTap: () {
                                        showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now())
                                            .then((value) {
                                          timeController.text =
                                              value!.format(context).toString();
                                          print(value.format(context));
                                        });
                                        print('TIME TAPPED');
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Time Must n\'t Empty';
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.datetime,
                                      decoration: const InputDecoration(
                                        label: Text('Task Time'),
                                        border: OutlineInputBorder(),
                                        prefixIcon:
                                            Icon(Icons.watch_later_outlined),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                      controller: dateController,
                                      onTap: () {
                                        showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime.parse(
                                                    '2022-09-12'))
                                            .then((value) {
                                          dateController.text =
                                              DateFormat.yMMMd().format(value!);
                                          print(
                                              DateFormat.yMMMd().format(value));
                                        });
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Date Must n\'t Empty';
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.datetime,
                                      decoration: const InputDecoration(
                                        label: Text('Task Date'),
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(Icons.calendar_today),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            elevation: 20,
                          )
                          .closed
                          .then((value) {

                        cubit.SetSheetIconChange(
                            isSheeet: false, icons: Icons.edit);
                      });

                      cubit.SetSheetIconChange(
                          icons: Icons.add, isSheeet: true);
                    }
                  },
                  child: Icon(cubit.myIcon)),
              bottomNavigationBar: BottomNavigationBar(
                iconSize: 30,
                type: BottomNavigationBarType.fixed,
                currentIndex: cubit.currentIndex,
                onTap: (index) {
                  cubit.BottonBar(index);
                },
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.menu), label: 'text'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.cloud_done_outlined), label: 'Done'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.archive_outlined), label: 'archive'),
                ],
              ),
              body: ConditionalBuilder(
                  condition: state is! LoadingCirclarCubit ,
                  builder: (context) => cubit.screen[cubit.currentIndex],
                  fallback: (context) =>
                      const Center(child: CircularProgressIndicator())),
            );
          },
          listener: (BuildContext context, Object? state) {
            if(state is insertCubitToDatabase) {
              Navigator.pop(context);
            }
          }),
    );
  }
}
