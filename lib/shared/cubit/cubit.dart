import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lap6/shared/cubit/states.dart';
import 'package:sqflite/sqflite.dart';

import '../../modules/Archive_layout.dart';
import '../../modules/Done_layout.dart';
import '../../modules/Task_layout.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  int currentIndex = 0;
  late Database database;
  late List<Map> newTasks = [];
  late List<Map> doneTasks = [];
  late List<Map> archiveTasks = [];
  bool isSheet = false;
  IconData myIcon = Icons.edit;

  static AppCubit get(context) => BlocProvider.of(context);
  List<Widget> screen = const [
    Task_Layout(),
    Done_Layout(),
    Archive_Layout(),
  ];

  List<String> changeTitle = ['Task', 'Done', 'Archive'];

  void BottonBar(int index) {
    currentIndex = index;
    emit(AppChangeButtonBar());
  }

  void createDataBase() {
    openDatabase('todoo.db', version: 1, onCreate: (database, version) {
      print('DataBase Created !');
      database
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT)')
          .then((value) {
        print('Table Created !');
      }).onError((error, stackTrace) {
        print('error => ${error.toString()}');
      });
    }, onOpen: (database) {
      getDataFromDataBase(database);
      print('DataBase Opened !');
    }).then((value) {
      database = value;
      emit(createCubitDataBase());
    });
  }

  insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks (title,time,date,status) VALUES ("$title","$time","$date","new")')
          .then((value) {
        print('$value inserting successfully !');
        emit(insertCubitToDatabase());
        getDataFromDataBase(database);
      }).onError((error, stackTrace) {
        print('error => ${error.toString()}');
      });
    });
  }

  void getDataFromDataBase(database) {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];
    emit(LoadingCirclarCubit());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archiveTasks.add(element);
        }
      });
      emit(getDataCubitFromDataBase());
    });
  }

  void SetSheetIconChange({required IconData icons, required bool isSheeet}) {
    isSheet = isSheeet;
    myIcon = icons;
    emit(Iconsheetbutton());
  }

  void updateDataBase({required String status, required int id}) {
    database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?', [status, id]).then((value) {
      getDataFromDataBase(database);
      emit(updateCubitDataBase());
    });
  }

  void deleteDataBase({ required int id}) {
    database.rawDelete(
        'DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDataBase(database);
      emit(deleteCubitDataBase());
    });
  }
}
