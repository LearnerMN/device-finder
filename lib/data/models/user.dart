class User {
  final String id;
  final String name;
  final String imgUrl;


  User.fromMap(Map<dynamic, dynamic> map)
      : assert(map['id'] != null),
        assert(map['name'] != null),
        assert(map['img_url'] != null),
        id = map['id'],
        name = map['name'],
        imgUrl = map['img_url'];

  @override
  String toString() => "User<$id:$name>";
}