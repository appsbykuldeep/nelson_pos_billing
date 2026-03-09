enum MasterDataType {
  itemInfo(
    tableName: "itemInfo",
    requirementKey: "itemInfoMaster",
    lastSyncOnKey: "itemInfoMasterLastSync",
  );

  final String tableName;
  final String requirementKey;
  final String lastSyncOnKey;

  static const List<MasterDataType> allMasterData = MasterDataType.values;

  static List<MasterDataType> needmasterAccept(
    List<MasterDataType> skipMaster,
  ) => allMasterData.where((e) => !skipMaster.contains(e)).toList();

  static const List<MasterDataType> mainMasterData = [itemInfo];

  static Set<MasterDataType> getMasterTypeByKeyList(List<String> masterKeys) {
    return allMasterData
        .where((e) => masterKeys.contains(e.requirementKey))
        .toSet();
  }

  const MasterDataType({
    required this.tableName,
    required this.requirementKey,
    required this.lastSyncOnKey,
  });

  static MasterDataType? parseByTableName(String tableName) =>
      switch (tableName.toLowerCase()) {
        "itemInfo" => itemInfo,
        "StandRemarksMaster" => itemInfo,
        _ => null,
      };
}
