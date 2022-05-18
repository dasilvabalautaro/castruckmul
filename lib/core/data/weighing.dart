import 'dart:ffi';

class Weighing {
  int id = 0;
  int user = 0;
  String plate = "";
  String driver = "";
  String license = "";
  int register = 0;
  int inside = 0;
  int outside = 0;
  String source = "";
  String target = "";
  String product = "";
  int weightGross = 0;
  int weightNet = 0;
  int weightTare = 0;
  String observation = "";

  Weighing({required this.id, required this.user,
    required this.driver, this.plate = "",
    this.license = "", required this.register,
    required this.inside, this.outside = 0,
    this.source = "", this.target = "",
    this.product = "", required this.weightGross,
    required this.weightNet, this.weightTare = 0, this.observation = ""});

  Map<String, dynamic> toMap(){
    return {'user':user,
        'plate': plate, 'driver': driver, 'license': license,
        'register': register, 'inside': inside,
        'outside': outside, 'source': source, 'target': target,
        'product': product, 'weight_gross': weightGross,
        'weight_net': weightNet, 'weight_tare': weightTare,
        'observations': observation};
  }

  Weighing.fromMap(Map mapWeighing) {
    user = mapWeighing['user']!;
    register = mapWeighing['register']!;
    inside = mapWeighing['inside']!;
    outside = mapWeighing['outside']!;
    plate = mapWeighing['plate'].toString();
    driver = mapWeighing['driver'].toString();
    license = mapWeighing['license'].toString();
    source = mapWeighing['source'].toString();
    target = mapWeighing['target'].toString();
    product = mapWeighing['product'].toString();
    observation = mapWeighing['observation'].toString();
    weightGross = mapWeighing['weightGross']!;
    weightNet = mapWeighing['weightNet']!;
    weightTare = mapWeighing['weightTare']!;
  }
  
  @override
  String toString(){
    return 'Weighing{id: $id, user: $user, '
        'plate: $plate, driver: $driver, license: $license, '
        'register: $register, inside: $inside, '
        'outside: $outside, source: $source, target: $target, '
        'product: $product, weight_gross: $weightGross, '
        'weight_net: $weightNet, weight_tare: $weightTare, '
        'observation: $observation}';
  }
}