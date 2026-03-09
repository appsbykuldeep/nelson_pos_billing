import 'dart:io';

class PrinterDevice {
  String name;
  String operatingSystem = Platform.operatingSystem;
  String? vendorId;
  String? productId;
  String? address;

  PrinterDevice(
      {required this.name, this.address, this.vendorId, this.productId});

  Map<String, dynamic> toMap() => {
        "name": name,
        "operatingSystem": operatingSystem,
        "vendorId": vendorId,
        "productId": productId,
        "address": address,
      };

  factory PrinterDevice.fromMap(Map<String, dynamic> json) {
    return PrinterDevice(
      name: json["name"] as String,
      vendorId: json["vendorId"] as String?,
      productId: json["productId"] as String?,
      address: json["address"] as String?,
    );
  }
}
