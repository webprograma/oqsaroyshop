import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/additional/member_model.dart';
import 'package:instaclone/additional/model.dart';
import 'package:instaclone/pages/vital_pages/myfavouritePage.dart';
import 'package:instaclone/pages/vital_pages/myprofilepage.dart';
import 'package:instaclone/pages/vital_pages/mysearchpage.dart';
import 'package:instaclone/pages/vital_pages/upload_page.dart';
import 'package:instaclone/servise/dbs_service.dart';
import 'package:url_launcher/url_launcher.dart';

class MyMainPage extends StatefulWidget {
  static final String id = "121";
  const MyMainPage({Key? key}) : super(key: key);

  @override
  _MyMainPageState createState() => _MyMainPageState();
}

class _MyMainPageState extends State<MyMainPage> {
  bool isLoading = false;
  List<Post> items = [];

  @override
  void initState() {
    super.initState();
    _apiLoadFeeds();
    _apiLoadMember();
  }

  _apiLoadFeeds() {
    setState(() {
      isLoading = true;
    });
    DBService.loadMainFeeds().then((value) {
      _resLoadFeeds(value);
    });
  }

  _resLoadFeeds(List<Post> posts) {
    setState(() {
      items = posts;
      isLoading = false;
    });
  }

  apiPostLike(Post post) async {
    setState(() {
      isLoading = true;
    });
    await DBService.likePost(post, true);
    setState(() {
      isLoading = false;
      post.liked = true;
    });
  }

  apiPostDislike(Post post) async {
    setState(() {
      isLoading = true;
    });
    await DBService.likePost(post, false);
    setState(() {
      isLoading = false;
      post.liked = false;
    });
  }

  final Uri url = Uri.parse('https://abdurahmon-mahmudov.jimdosite.com/');
  Future<void> _launchSite() async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.blue,
              size: 25,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
        title: Text(
          'Oqsaroy Shop',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 35,
            fontFamily: "Powerpunchy",
          ),
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
          if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.grey[200],
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, MyProfilePage.id);
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: img_url.isNotEmpty
                                    ? NetworkImage(img_url)
                                    : AssetImage('assets/images/user.jpg')
                                        as ImageProvider)),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      fullName,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontFamily: "Powerpunchy"),
                    )
                  ],
                ),
              ),
              ListTile(
                title: Text(
                  'About',
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 27,
                      fontFamily: "Powerpunchy"),
                ),
                leading: Icon(
                  Icons.info,
                  size: 27,
                  color: Colors.blue,
                ),
                onTap: () {
                  _launchSite();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String fullName = "";
  String email = "";
  String img_url = "";

  _apiLoadMember() {
    DBService.loadMember().then((value) {
      showMemberInfo(value);
    });
  }

  bool isCustomer = true;
  showMemberInfo(Member member) {
    setState(() {
      isCustomer = member.isCustomer;
      if (member.isCustomer == false) {
        print('user is vendor');
      } else {
        print('user is customer');
      }
      this.fullName = member.name;
      this.img_url = member.img_url;
    });
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
                      child: ClipRRect(
                        child: post.img_user.isEmpty
                            ? Image(
                                image: AssetImage('assets/images/user.jpg'),
                                height: 70,
                                width: 70,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                post.img_user,
                                height: 70,
                                width: 70,
                                fit: BoxFit.cover,
                              ),
                        borderRadius: BorderRadius.circular(35),
                      ),
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
            placeholder: (context, url) => Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.only(right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    isCustomer == false
                        ? InkWell(
                            onTap: () {
                              _makePhoneCall(post.phoneNumber);
                              print(post.phoneNumber);
                            },
                            child: Container(
                                width: 70,
                                height: 30,
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(6)),
                                child: Center(
                                  child: Text(
                                    'Contact',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                          )
                        : IconButton(
                            onPressed: () {
                              _makePhoneCall("0000");
                            },
                            icon: Icon(
                              Icons.shopping_cart_outlined,
                              size: 23,
                              color: Colors.blue,
                            ),
                          ),
                    SizedBox(
                      width: 7,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Price:",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.blue),
                      child: Text(
                        "\$${post.price}",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                )
              ],
            ),
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
