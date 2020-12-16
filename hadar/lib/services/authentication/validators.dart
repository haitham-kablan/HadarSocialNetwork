import 'package:flutter/material.dart';

class Email_Validator{

  static String Validate(String value){
    if(value.isEmpty){
      return 'האימיל לא יכול להיות ריק';
    }
    else{
      return null;
    }
  }

}

class password_Validator{

  static String Validate(String value){
    if(value.isEmpty){
      return 'הסיסמה לא יכולה להיות ריקה';
    }
    else{
      return null;
    }
  }

}

class Id_Validator{

  static String Validate(String value){
    if(value.isEmpty){
      return 'תעודת זהות לא יכול להיות ריק';
    }
    else{
      return null;
    }
  }

}

class name_Validator{

  static String Validate(String value){
    if(value.isEmpty){
      return 'השם לא יכול להיות ריק';
    }
    else{
      return null;
    }
  }

}

class number_Validator{

  static String Validate(String value){
    if(value.isEmpty){
      return 'מספר טלפון לא יכול להיות ריק';
    }
    else{
      return null;
    }
  }

}

class second_pw_Validator{

  static String First_pw;
  static String Validate(String value){
    if(First_pw != value){
      return 'הסיסמה לא תואמת';
    }else{
      return null;
    }
  }

}