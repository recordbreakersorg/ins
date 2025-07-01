class QueryError extends Error {
  int status;
  String message;
  QueryError({required this.status, required this.message});
}
