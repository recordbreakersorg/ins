import 'package:flutter/material.dart';
import 'package:ins/backend/models.dart';

CircleAvatar profileAvatar(Profile? profile, double radius) {
  if (profile == null) {
    return CircleAvatar(
      backgroundColor: Colors.grey,
      radius: radius,
      child: Icon(Icons.person, color: Colors.white),
    );
  }
  return CircleAvatar(
    backgroundImage: NetworkImage(profile.getPath()),

    radius: radius,
  );
}
