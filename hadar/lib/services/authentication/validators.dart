import 'package:flutter/material.dart';

class Email_Validator{

  static String Validate(String value){
    if(value.isEmpty){
      return 'Email can\'t be empty';
    }
  }

}

class password_Validator{

  static String Validate(String value){
    if(value.isEmpty){
      return 'Password can\'t be empty';
    }
  }

}

class Id_Validator{

  static String Validate(String value){
    if(value.isEmpty){
      return 'Id can\'t be empty';
    }
  }

}

class name_Validator{

  static String Validate(String value){
    if(value.isEmpty){
      return 'Name can\'t be empty';
    }
  }

}

class number_Validator{

  static String Validate(String value){
    if(value.isEmpty){
      return 'Number can\'t be empty';
    }
  }

}

class second_pw_Validator{

  static String Validate(String value){
    if(value.isEmpty){
      return 'pw arent the same';
    }
  }

}