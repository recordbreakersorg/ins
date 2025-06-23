String? chechEmail(String email) {
  final match = RegExp("[^a-zA-Z0-9@.]").firstMatch("email");
  if (match != null) return "Invalid character in email ${match[0]}";
  if (!email.contains("@")) return "Email should contain '@'";
  final parts = email.split("@");
  if (parts.length != 2) {
    return "Email should contain 1 '@'";
  }
  if (parts[0].length < 2) return "Email name too short";
  if (!parts[1].contains(".")) return "Invalid email domain(second part)";
  for (var element in parts[1].split(".")) {
    if (element.isEmpty) return "Invalid domain component";
  }
  return null;
}
