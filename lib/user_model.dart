import 'package:flutter/material.dart';

class UserModel {
  int id;
  String username;
  String email;
  double weight;
  String gender;
  double height;
  double result;
  String resultType;
  String category;
  Color resultColor;
  DateTime currentDate;
  Color categoryColor;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.weight,
    required this.gender,
    required this.height,
    required this.result,
    required this.resultType,
    required this.category,
    required this.resultColor,
    required this.currentDate,
    required this.categoryColor,
  });

  Map<String, dynamic> toMap(UserModel userModel) {
    Map<String, dynamic> userModelMap = Map();
    userModelMap["id"] = userModel.id;
    userModelMap["username"] = userModel.username;
    userModelMap["email"] = userModel.email;
    userModelMap["weight"] = userModel.weight;
    userModelMap["gender"] = userModel.gender;
    userModelMap["height"] = userModel.height;
    userModelMap["result"] = userModel.result;
    userModelMap["resultType"] = userModel.resultType;
    userModelMap["category"] = userModel.category;
    userModelMap["resultColor"] = userModel.resultColor.value;
    userModelMap["currentDate"] = userModel.currentDate.toIso8601String();
    userModelMap["categoryColor"] = userModel.categoryColor.value;
    return userModelMap;
  }

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
    id: json['id'] ?? 0,
    username: json['username'] ?? '',
    email: json['email'] ?? '',
    weight: json['weight'] ?? 0.0,
    gender: json['gender'] ?? '',
    height: json['height'] ?? 0.0,
    result: json['result'] ?? 0.0,
    resultType: json['resultType'] ?? '',
    category: json['category'] ?? '',
    resultColor: Color(json['resultColor']) ?? Colors.transparent,
    currentDate: DateTime.parse(json['currentDate'] ?? ''),
    categoryColor: Color(json['categoryColor']) ?? Colors.transparent,
  );
}
