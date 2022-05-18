import 'dart:ffi';

import 'data/type_user.dart';
import 'data/user.dart';
import 'data/weighing.dart';

abstract class IDatabase {
  Future<void> connect();
  Future<List<TypeUser>> getTypeUser();
  Future<int> insertUser(User user);
  Future<List<User>> getUsers();
  Future<dynamic> getUserById(int id);
  Future<dynamic> getUserByLogin(String login, String password);
  Future<int> insertWeighing(Weighing weighing);
  Future<Weighing> getWeighingById(int id);
  Future<List<Weighing>> getWeighingByDate(int start, int end);
  bool isConnected();
  Future<List<Weighing>> getWeighingPending();
  Future<int> updateUser(User user);
  Future<int> updateWeighing(Weighing weighing);
}
