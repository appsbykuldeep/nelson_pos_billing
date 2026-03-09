class OfflineResponse {
  OfflineResponse({
    this.resultStatus = false,
    this.resultMsj = "",
    this.resultData,
  });

  bool resultStatus;
  String resultMsj;
  dynamic resultData;

  @override
  String toString() =>
      'OfflineResponse(resultStatus: $resultStatus, resultMsj: $resultMsj, resultData: $resultData)';
}
