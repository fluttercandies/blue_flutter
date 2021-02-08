/// **************************************************************************
/// ignore_for_file: non_constant_identifier_names,library_prefixes
/// **************************************************************************

class BondedDeviceModel {
  final String address;
  final String name;

  BondedDeviceModel({
    this.address,
    this.name,
  });

  factory BondedDeviceModel.fromJson(Map<String, dynamic> json) =>
      _$BondedDeviceModelFromJson(json);

  BondedDeviceModel from(Map<String, dynamic> json) =>
      _$BondedDeviceModelFromJson(json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['name'] = this.name;
    return data;
  }
}

BondedDeviceModel _$BondedDeviceModelFromJson(Map<String, dynamic> json) {
  return BondedDeviceModel(
    address: json['address'],
    name: json['name'],
  );
}
