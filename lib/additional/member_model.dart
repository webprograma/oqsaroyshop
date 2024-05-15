class Member {
  String uid = "";
  String name = "";
  String phoneNumber = "";
  String email = "";
  String img_url = "";

  String device_id = "";
  String device_type = "";
  String device_token = "";
  bool isCustomer = true;
  Member(this.name, this.email, this.isCustomer, this.phoneNumber);

  Member.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        img_url = json["img_url"],
        phoneNumber = json["phoneNumber"],
        uid = json['uid'],
        device_id = json['device_id'],
        device_type = json['device_type'],
        device_token = json['device_token'],
        isCustomer = json['isCustomer'],
        email = json['email'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'uid': uid,
        "img_url": img_url,
        "phoneNumber": phoneNumber,
        'device_id': device_id,
        'device_type': device_type,
        'device_token': device_token,
        'email': email,
        'isCustomer': isCustomer,
      };
}
