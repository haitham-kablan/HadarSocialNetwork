

enum Privilege {Admin, UserInNeed, Volunteer, UnregisterUser, Organization, Anonymous}

Privilege stringToPrivilege(String prev){
  switch(prev){
    case "Privilege.Admin":
      print("heeeeeeeeeeeeeeeeeeeehaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
      return Privilege.Admin;
    case "Privilege.UserInNeed":
      return Privilege.UserInNeed;
    case "Privilege.Volunteer":
      return Privilege.Volunteer;
    case "Privilege.UnregisterUser":
      return Privilege.UnregisterUser;
    case "Privilege.Organization":
      return Privilege.Organization;
    case "Privilege.Anonymous":
      return Privilege.Anonymous;
    default:
      print("oooooooohhhhhhhhhhhhh noooooooooooooooooooooooooo");
      return null;
  }
}
