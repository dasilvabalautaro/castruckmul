import '../core/data/type_user.dart';
import '../core/data/user.dart';
import '../core/data/weighing.dart';
import '../infrastructure/db_context.dart';
import 'package:castruckmul/infrastructure/tools/crypto.dart';

class GetDataUseCase{
  DbContext dbContext = DbContext();

  Future<void> connect() async {
    await dbContext.connect();
  }

  Future<List<Map<String, dynamic>>> getTypeUser() async {
    List<Map<String, dynamic>> items = [];

    List<TypeUser> typeUser = await dbContext.getTypeUser();
    for (var item in typeUser) {
      Map<String, dynamic> mapItem = <String, dynamic>{};
      mapItem['value'] = item.id;
      mapItem['label'] = item.description;

      items.add(mapItem);
    }
    return items;
  }

  Future<int> insertUser(Map dataUser) async {
    User user = User.fromMap(dataUser);
    int id = await dbContext.insertUser(user);
    return id;
  }

  bool isNotConnected(){
    return dbContext.isConnected();
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    List<Map<String, dynamic>> items = [];

    List<User> user = await dbContext.getUsers();
    for (var item in user) {
      String psw = Crypto.decrypt64(item.password);
      String type = item.type == 1 ? 'Operator': 'Administrator';
      Map<String, dynamic> mapItem = <String, dynamic>{};
      mapItem['id'] = item.id;
      mapItem['first_name'] = item.firstName;
      mapItem['last_name'] = item.lastName;
      mapItem['login'] = item.login;
      mapItem['password'] = psw;
      mapItem['type'] = type;
      items.add(mapItem);
    }
    return items;
  }

  Future<List<Map<String, dynamic>>> getWeighingPending() async {
    List<Map<String, dynamic>> items = [];

    List<Weighing> weighing = await dbContext.getWeighingPending();
    for (var item in weighing) {
      Map<String, dynamic> mapItem = <String, dynamic>{};
      mapItem['id'] = item.id;
      mapItem['user'] = item.user;
      mapItem['plate'] = item.plate;
      mapItem['driver'] = item.driver;
      mapItem['license'] = item.license;
      mapItem['register'] = item.register;
      mapItem['inside'] = item.inside;
      mapItem['outside'] = item.outside;
      mapItem['source'] = item.source;
      mapItem['target'] = item.target;
      mapItem['product'] = item.product;
      mapItem['weight_gross'] = item.weightGross;
      mapItem['weight_net'] = item.weightNet;
      mapItem['weight_tare'] = item.weightTare;
      mapItem['observations'] = item.observation;
      items.add(mapItem);

    }
    return items;
  }

  Future<dynamic> getUserByLogin(String login, String password) async {
    return await dbContext.getUserByLogin(login, password);
  }

  Future<int> insertWeighing(Map mapWeighing) async {
    Weighing weighing = Weighing.fromMap(mapWeighing);
    int id = await dbContext.insertWeighing(weighing);
    return id;
  }

  Future<int> updateUser(Map mapUser) async {
    User user = User.fromMap(mapUser);
    user.id = mapUser['id']!;
    int changes = await dbContext.updateUser(user);
    return changes;
  }

  Future<int> updateWeighing(Map mapWeighing) async {
    Weighing weighing = Weighing.fromMap(mapWeighing);
    weighing.id = mapWeighing['id']!;
    int changes = await dbContext.updateWeighing(weighing);
    return changes;
  }
}