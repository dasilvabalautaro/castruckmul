class User{
  int id = 0;
  int type = -1;
  String login = "";
  String password = "";
  String firstName = "";
  String lastName = "";

  User({required this.id, required this.type,
    required this.login, required this.password,
    required this.firstName, required this.lastName});

  Map<String, dynamic> toMap(){
    return {
      'type': type,
      'login': login,
      'password': password,
      'first_name': firstName,
      'last_name': lastName,
    };
  }

  User.fromMap(Map mapUser) {
    type = int.tryParse(mapUser['type'])!;
    login = mapUser['login'].toString();
    password = mapUser['password'].toString();
    firstName = mapUser['firstName'].toString();
    lastName = mapUser['lastName'].toString();

  }

  @override
  String toString(){
    return 'User{id: $id, type: $type, '
        'login: $login, password: $password, first_name: $firstName, '
        'last_name: $lastName}';
  }
}