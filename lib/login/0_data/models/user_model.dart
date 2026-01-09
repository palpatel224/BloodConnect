// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:bloodconnect/login/1_domain/entities/user_entity.dart';



class UserModel {
  final String userId;
  final String name;
  final String email;

  UserModel(
      {required this.userId,
      required this.name,
      required this.email});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'name': name,
      'email': email,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

extension UserXModel on UserModel {
  UserEntity toEntity() {
    return UserEntity(
        userId: userId,
        name: name,
        email: email,);
  }
}
