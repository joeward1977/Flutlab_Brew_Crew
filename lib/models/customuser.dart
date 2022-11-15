class CustomUser {
  final String uid;

  CustomUser({required this.uid});
}

class UserData {
  final String? uid;
  final String name;
  final String sugars;
  final int strength;

  UserData(
      {this.uid,
      required this.sugars,
      required this.strength,
      required this.name});
}
