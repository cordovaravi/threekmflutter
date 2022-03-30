final Variantdata = <String, dynamic>{};
class VariantModel {
  VariantModel({
    required this.name,
    required this.value,
  });
  late final String name;
  late final String value;
  

  VariantModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
    Variantdata[name] = Variantdata[name].add(value);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['value'] = value;
    return _data;
  }
}
