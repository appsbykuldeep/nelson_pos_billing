// ignore_for_file: public_member_api_docs, sort_constructors_first
class ChargesType {
  int id;
  String lable;
  bool calculateAmountOnEntry;
  ChargesType({
    this.id = 0,
    this.lable = '',
    this.calculateAmountOnEntry = false,
  });

  bool get isOnTime => id == 1;
  bool get isHourly => id == 2;
  bool get isPerDay => id == 3;
  bool get isCustomRate => id == 5;

  @override
  bool operator ==(covariant ChargesType other) {
    if (identical(this, other)) return true;

    return other.id == id && other.lable == lable;
  }

  @override
  int get hashCode => id.hashCode ^ lable.hashCode;
}

extension KDChargesTypeList on List<ChargesType> {
  ChargesType findByID(int id) => firstWhere((e) => e.id == id, orElse: () => ChargesType());
}
