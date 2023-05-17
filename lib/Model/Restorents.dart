import 'dart:convert';
/// status : "SUCCESS"
/// code : "SC_01"
/// data : [{"id":"5","name":"Kake Da Hotel","tags":"Chicken, Naan","rating":"4.9","discount":"20","primary_image":"https://theoptimiz.com/restro/public/Resturants/kake-da-hotel.png","distance":"3174.53"},{"id":"2","name":"Domino's","tags":"Pizza, Wings","rating":"4.8","discount":"25","primary_image":"https://theoptimiz.com/restro/public/Resturants/dominos.png","distance":"3174.73"},{"id":"1","name":"Burger King","tags":"Burger, Fries, Wings","rating":"4.5","discount":"20","primary_image":"https://theoptimiz.com/restro/public/Resturants/burger-king.png","distance":"3176.19"},{"id":"3","name":"Sagar Ratna","tags":"Dosa, Idli, Upma","rating":"4.2","discount":"30","primary_image":"https://theoptimiz.com/restro/public/Resturants/sagar-ratna.png","distance":"3177.51"},{"id":"4","name":"Chaayos","tags":"Tea, Coffee, Snacks","rating":"3.4","discount":"28","primary_image":"https://theoptimiz.com/restro/public/Resturants/chaayos.png","distance":"3177.74"}]

Restorents restorentsFromJson(String str) => Restorents.fromJson(json.decode(str));
String restorentsToJson(Restorents data) => json.encode(data.toJson());
class Restorents {
  Restorents({
      String? status, 
      String? code, 
      List<Data>? data,}){
    _status = status;
    _code = code;
    _data = data;
}

  Restorents.fromJson(dynamic json) {
    _status = json['status'];
    _code = json['code'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  String? _status;
  String? _code;
  List<Data>? _data;
Restorents copyWith({  String? status,
  String? code,
  List<Data>? data,
}) => Restorents(  status: status ?? _status,
  code: code ?? _code,
  data: data ?? _data,
);
  String? get status => _status;
  String? get code => _code;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['code'] = _code;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "5"
/// name : "Kake Da Hotel"
/// tags : "Chicken, Naan"
/// rating : "4.9"
/// discount : "20"
/// primary_image : "https://theoptimiz.com/restro/public/Resturants/kake-da-hotel.png"
/// distance : "3174.53"

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      String? id, 
      String? name, 
      String? tags, 
      String? rating, 
      String? discount, 
      String? primaryImage, 
      String? distance,}){
    _id = id;
    _name = name;
    _tags = tags;
    _rating = rating;
    _discount = discount;
    _primaryImage = primaryImage;
    _distance = distance;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _tags = json['tags'];
    _rating = json['rating'];
    _discount = json['discount'];
    _primaryImage = json['primary_image'];
    _distance = json['distance'];
  }
  String? _id;
  String? _name;
  String? _tags;
  String? _rating;
  String? _discount;
  String? _primaryImage;
  String? _distance;
Data copyWith({  String? id,
  String? name,
  String? tags,
  String? rating,
  String? discount,
  String? primaryImage,
  String? distance,
}) => Data(  id: id ?? _id,
  name: name ?? _name,
  tags: tags ?? _tags,
  rating: rating ?? _rating,
  discount: discount ?? _discount,
  primaryImage: primaryImage ?? _primaryImage,
  distance: distance ?? _distance,
);
  String? get id => _id;
  String? get name => _name;
  String? get tags => _tags;
  String? get rating => _rating;
  String? get discount => _discount;
  String? get primaryImage => _primaryImage;
  String? get distance => _distance;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['tags'] = _tags;
    map['rating'] = _rating;
    map['discount'] = _discount;
    map['primary_image'] = _primaryImage;
    map['distance'] = _distance;
    return map;
  }

}