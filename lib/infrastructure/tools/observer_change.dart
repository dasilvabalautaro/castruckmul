import 'dart:async';

import 'package:castruckmul/core/data/user.dart';

import '../../core/data/weighing.dart';

class ObserveChange{
  static final StreamController streamController = StreamController<bool>.broadcast();
  static Stream get usersUpdateList => streamController.stream;
  static final StreamController streamControllerWeightUpdate = StreamController<Weighing>.broadcast();
  static Stream get weightUpdate => streamControllerWeightUpdate.stream;
  static final StreamController streamControllerInsertWeight = StreamController<bool>.broadcast();
  static Stream get weightInsert => streamControllerInsertWeight.stream;
  static final StreamController streamControllerValueWeight = StreamController<List<int>>.broadcast();
  static Stream get weightValue => streamControllerValueWeight.stream;
  static final StreamController streamControllerRestoreWeight = StreamController<List<int>>.broadcast();
  static Stream get weightRestore => streamControllerRestoreWeight.stream;
  static final StreamController streamControllerUserSelected = StreamController<User>.broadcast();
  static Stream get userSelected => streamControllerUserSelected.stream;
}