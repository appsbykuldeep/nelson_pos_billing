enum ApiProgessStatus {
  none("Please wait"),
  wait("Wait..."),
  waiting("Waiting..."),
  receiving("Receiving..."),
  sending("Sending..."),

  working("Working...");

  final String label;

  const ApiProgessStatus(this.label);
}
