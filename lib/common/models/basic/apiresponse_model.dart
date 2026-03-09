class ApiResponse {
  ApiResponse({
    this.statusCode = 0,
    this.resultStatus = false,
    this.internetAvailable = true,
    this.resultMsj = "",
    this.resultData,
    this.apiBody,
  });

  int statusCode;
  bool resultStatus;
  bool internetAvailable;
  String resultMsj;
  dynamic resultData;
  dynamic apiBody;
}
