class TypeUser{
  final int id;
  final String description;

  TypeUser({required this.id, required this.description});

  Map<String, dynamic> toMap(){
    return {'id': id, 'description': description};
  }

  @override
  String toString(){
    return 'Type{id: $id, description: $description}';
  }
}