
import 'dart:io';

import 'package:castruckmul/core/data/type_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

void copyFile(String path, String newPath) {
  File(path).copySync(newPath);
}

void main(){
  sqfliteFfiInit();
  setUp(() {
    File(join('assets', 'castruck.db')).copySync(join('assets', 'test.db'));
  });

  test('Select', () async{
    var db = await databaseFactoryFfi.openDatabase('../../../assets/test.db');
    //var dataProvider = DataProvider(db: db);
    List<Map<String, dynamic>> maps = await db.query('type_user');

    var list = List.generate(maps.length, (i) {
      return TypeUser(
        id: maps[i]['id'],
        description: maps[i]['description'],
      );
    });

    expect(list[0].toMap(), {'id': 1, 'description': 'operador'});
  });
}