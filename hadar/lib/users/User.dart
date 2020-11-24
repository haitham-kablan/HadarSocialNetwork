

enum Privilege {Admin, UserInNeed, Volunteer, UnregisterUser}

class User{
  String name;
  String phoneNumber;
  String email;
  Privilege privilege;

  User(this.name, this.phoneNumber, this.email, this.privilege);
}
