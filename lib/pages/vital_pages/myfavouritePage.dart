import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/additional/model.dart';
import 'package:instaclone/servise/dbs_service.dart';
import 'package:url_launcher/url_launcher.dart';

class MyFavouritePage extends StatefulWidget {
  static final String id = 'iwdi';
  const MyFavouritePage({super.key});

  @override
  State<MyFavouritePage> createState() => _MyFavouritePageState();
}

class _MyFavouritePageState extends State<MyFavouritePage> {
  bool isLoading = false;
  List<Post> items = [];
  void _apiLoadLikes() {
    setState(() {
      isLoading = true;
    });
    DBService.loadLike().then((value) => {
          _resLoadLikes(value),
        });
  }

  void _resLoadLikes(List<Post> posts) {
    items = posts;
    isLoading = false;
  }

  void _apiUnlikePost(Post post) {
    setState(() {
      isLoading = true;
      post.liked = false;
    });
    DBService.likePost(post, false).then((value) => {_apiLoadLikes()});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiLoadLikes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Basket',
          style: TextStyle(
              color: Colors.blue, fontSize: 35, fontFamily: "Powerpunchy"),
        ),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemBuilder: (context, index) {
              return itemOfPost(items[index]);
            },
            itemCount: items.length,
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SizedBox()
        ],
      ),
    );
  }

  Widget itemOfPost(Post post) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage('assets/images/user.jpg'))),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.fullname,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(post.date),
                      ],
                    )
                  ],
                ),
                Text(
                  "id:${post.id.substring(0, 4)}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          SizedBox(
            height: 7,
          ),
          CachedNetworkImage(
            fit: BoxFit.cover,
            width: double.infinity,
            height: MediaQuery.of(context).size.width,
            imageUrl: post.img_post,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    _apiUnlikePost(post);
                  },
                  icon: Icon(
                    Icons.shopping_cart_rounded,
                    size: 25,
                    color: Colors.blue,
                  )),
              SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  _makePhoneCall('0000');
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 40,
                  padding: EdgeInsets.all(10),
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(13)),
                  child: Text(
                    'Shop Now',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.blue),
                  ),
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Text(
              post.caption,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
}
