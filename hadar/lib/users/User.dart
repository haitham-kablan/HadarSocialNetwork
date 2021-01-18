


enum Privilege {Admin, UserInNeed, Volunteer, UnregisterUser,Annoymous}

class User{
  String name;
  String phoneNumber;
  String email;
  String id;
  Privilege privilege;

  User(this.name, this.phoneNumber, this.email, this.privilege , this.id
      );
}
