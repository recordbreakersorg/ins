String formatUsername(String name) {
  return name
      .toLowerCase()
      .replaceAll(" ", "_")
      .replaceAll(RegExp("[^a-z1-9_]+"), "");
}
