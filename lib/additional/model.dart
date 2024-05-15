class Post {
  String uid = "";
  String fullname = "";
  String img_user = "";
  String phoneNumber = "";
  String id = "";
  String img_post = "";
  String caption = "";
  String date = "";
  bool liked = false;
  String price = "";

  bool mine = false;
  Post(this.caption, this.img_post, this.price, this.phoneNumber);
  Post.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        fullname = json['fullname'],
        phoneNumber = json['phoneNumber'],
        img_user = json['img_user'],
        img_post = json['img_post'],
        id = json['id'],
        price = json['price'],
        caption = json['caption'],
        date = json['date'],
        liked = json['liked'];
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'fullname': fullname,
        'phoneNumber': phoneNumber,
        'img_user': img_user,
        'id': id,
        'price': price,
        'img_post': img_post,
        'caption': caption,
        'date': date,
        'liked': liked,
      };
}
