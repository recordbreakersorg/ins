import 'package:flutter/material.dart';
import 'package:ins/backend/models.dart';

CircleAvatar profileAvatar({
  Profile? profile,
  required double radius,
  String? imagePath,
  String? mnemonic,
  String? name,
}) {
  if (name != null) {
    mnemonic =
        name
            .trim()
            .split(RegExp(r'\s+'))
            .map((word) => word[0])
            .join()
            .toUpperCase();
  }
  final path = imagePath ?? profile?.getPath();
  if (path == null) {
    return CircleAvatar(
      backgroundColor: Colors.grey,
      radius: radius,
      child:
          mnemonic != null
              ? Text(mnemonic, style: TextStyle(fontSize: radius / 2))
              : Icon(Icons.person, color: Colors.white, size: radius),
    );
  }
  return CircleAvatar(backgroundImage: NetworkImage(path), radius: radius);
}
