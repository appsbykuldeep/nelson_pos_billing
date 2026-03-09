class PrintStatus {
  PrintStatus({this.status = false, this.msj = "Failed to print"});
  bool status;
  String msj;

  @override
  String toString() {
    return "PrintStatus($status,$msj)";
  }
}
