class StatusResult {
  final bool status;
  final String message;
  StatusResult({required this.status, required this.message});

  (bool, String) get toRecord => (status, message);
}
