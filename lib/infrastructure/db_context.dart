import 'dart:io';
import 'dart:ffi';
import 'package:castruckmul/core/data/user.dart';
import 'package:castruckmul/core/data/weighing.dart';
import 'package:castruckmul/infrastructure/tools/crypto.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
import '../core/data/type_user.dart';
import '../core/database.dart';

class DbContext implements IDatabase{

  String nameDatabase = "castruck.db";
  Database? _db;

  @override
  Future<void> connect() async {
    sqfliteFfiInit();

    var databaseFactory = databaseFactoryFfi;

    var databasesPath = await databaseFactory.getDatabasesPath();
    var idx = databasesPath.indexOf('castruckmul', 0);
    var pathWork = databasesPath.substring(0, idx + 12) + "database";
    String path = join(pathWork, nameDatabase);
    File file = File(path);

    if (!file.existsSync()){
      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (e)
      {
        rethrow;
      }

      ByteData data = await rootBundle.load(join('assets', 'castruck.db'));

      List<int> bytes = data.buffer.asUint8List(
          data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);

    }

    _db = await databaseFactoryFfi.openDatabase(path);

  }

  @override
  Future<List<TypeUser>> getTypeUser() async {
    List<Map<String, dynamic>> mapsTypeUser = await _db!.query('type_user');
    return List.generate(mapsTypeUser.length, (i) {
      return TypeUser(
        id: mapsTypeUser[i]['id'],
        description: mapsTypeUser[i]['description'],
      );
    });
  }

  @override
  Future<dynamic> getUserById(int id) async {
    return _db!.query('user', where: 'id = ?', whereArgs: [id], limit: 1);
  }


  @override
  Future<List<User>> getUsers() async {
    List<Map<String, dynamic>> mapsUsers = await _db!.query('user');
    return List.generate(mapsUsers.length, (i) {
      return User(
        id: mapsUsers[i]['id'],
        type: mapsUsers[i]['type'],
        login: mapsUsers[i]['login'],
        password: mapsUsers[i]['password'],
        firstName: mapsUsers[i]['first_name'],
        lastName: mapsUsers[i]['last_name'],
      );
    });
  }

  @override
  Future<List<Weighing>> getWeighingPending() async{
    List<Map<String, dynamic>> mapWeighing = await _db!.query('weighing',
        where: 'outside == 0');
    return List.generate(mapWeighing.length, (i)
    {
      return Weighing(
        id: mapWeighing[i]['id'],
        user: mapWeighing[i]['user'],
        plate: mapWeighing[i]['plate'],
        driver: mapWeighing[i]['driver'],
        license: mapWeighing[i]['license'],
        register: mapWeighing[i]['register'],
        inside: mapWeighing[i]['inside'],
        outside: mapWeighing[i]['outside'],
        source: mapWeighing[i]['source'],
        target: mapWeighing[i]['target'],
        product: mapWeighing[i]['product'],
        weightGross: mapWeighing[i]['weight_gross'],
        weightNet: mapWeighing[i]['weight_net'],
        weightTare: mapWeighing[i]['weight_tare'],
        observation: mapWeighing[i]['observations'],
      );
    });
  }

  @override
  Future<List<Weighing>> getWeighingByDate(int start, int end) async {
    List<Map<String, dynamic>> mapWeighing = await _db!.query('weighing',
        where: 'register > ? and register < ?', whereArgs: [start, end]);
    return List.generate(mapWeighing.length, (i)
    {
      return Weighing(
        id: mapWeighing[i]['id'],
        user: mapWeighing[i]['user'],
        plate: mapWeighing[i]['plate'],
        driver: mapWeighing[i]['driver'],
        license: mapWeighing[i]['license'],
        register: mapWeighing[i]['register'],
        inside: mapWeighing[i]['inside'],
        outside: mapWeighing[i]['outside'],
        source: mapWeighing[i]['source'],
        target: mapWeighing[i]['target'],
        product: mapWeighing[i]['product'],
        weightGross: mapWeighing[i]['weight_gross'],
        weightNet: mapWeighing[i]['weight_net'],
        weightTare: mapWeighing[i]['weight_tare'],
        observation: mapWeighing[i]['observations'],
      );
    });
  }

  @override
  Future<Weighing> getWeighingById(int id) async {
    List<Map<String, dynamic>> mapWeighing = await _db!.query('weighing',
        where: 'id = ?', whereArgs: [id], limit: 1);
    return Weighing(
      id: mapWeighing[0]['id'],
      user: mapWeighing[0]['user'],
      plate: mapWeighing[0]['plate'],
      driver: mapWeighing[0]['driver'],
      license: mapWeighing[0]['license'],
      register: mapWeighing[0]['register'],
      inside: mapWeighing[0]['inside'],
      outside: mapWeighing[0]['outside'],
      source: mapWeighing[0]['source'],
      target: mapWeighing[0]['target'],
      product: mapWeighing[0]['product'],
      weightGross: mapWeighing[0]['weight_gross'],
      weightNet: mapWeighing[0]['weight_net'],
      weightTare: mapWeighing[0]['weight_tare'],
      observation: mapWeighing[0]['observations'],
    );
  }

  @override
  Future<int> insertUser(User user) async {
    int id = await _db!.insert('user', user.toMap());
    return id;
  }

  @override
  Future<int> insertWeighing(Weighing weighing) async {
    int id = await _db!.insert('weighing', weighing.toMap());
    return id;
  }

  @override
  Future<dynamic> getUserByLogin(String login, String password) async {
    List<Map<String, dynamic>> mapsUsers = await _db!.query('user',
        where: 'login LIKE ?', whereArgs: [login]);
    User? usr;

    List<User> listUser =  List.generate(mapsUsers.length, (i) {
      return User(
        id: mapsUsers[i]['id'],
        type: mapsUsers[i]['type'],
        login: mapsUsers[i]['login'],
        password: mapsUsers[i]['password'],
        firstName: mapsUsers[i]['first_name'],
        lastName: mapsUsers[i]['last_name'],
      );
    });

    for(final user in listUser){
      String psw = Crypto.decrypt64(user.password);

      if (password == psw){
        usr = user;
        break;
      }
    }

    return usr;
  }

  @override
  bool isConnected() {
    return (_db == null);
  }

  @override
  Future<int> updateUser(User user) async {
    int changes = await _db!.update('user',
        user.toMap(), where: 'id = ?', whereArgs: [user.id]);
    return changes;
  }

  @override
  Future<int> updateWeighing(Weighing weighing) async {
    int changes = await _db!.update('weighing',
        weighing.toMap(), where: 'id = ?', whereArgs: [weighing.id]);
    return changes;

  }


}