import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaclone/additional/member_model.dart';
import 'package:instaclone/additional/model.dart';
import 'package:instaclone/servise/dbs_service.dart';
import 'package:instaclone/servise/firebase_servise.dart';
import 'package:instaclone/servise/storage_servise.dart';

class MyProfilePage extends StatefulWidget {
  static final String id = 'ckne';
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  bool isLoading = false;
  List<Post> items = [];
  bool gridSelected = true;

  String fullName = "";
  String email = "";
  String img_url = "";

  _apiLoadPosts() {
    DBService.loadPosts().then((value) => {
          _resLoadPosts(value),
        });
  }

  _resLoadPosts(List<Post> posts) {
    setState(() {
      items = posts;
    });
  }

  _apiLoadMember() {
    DBService.loadMember().then((value) => {showMemberInfo(value)});
  }

  showMemberInfo(Member member) {
    setState(() {
      this.fullName = member.name;
      this.email = member.email;
      this.img_url = member.img_url;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiLoadPosts();
    _apiLoadMember();
  }

  _imgFromGallery() async {
    XFile? image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _image = File(image!.path);
    });
    apiChangePhoto();
  }

  ImagePicker picker = ImagePicker();
  File? _image;
  _imgFromCamera() async {
    XFile? image =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      _image = File(image!.path);
    });
    apiChangePhoto();
  }

  void apiChangePhoto() {
    if (_image == null) return;
    FileService.uploadUserImage(_image!)
        .then((value) => {apiUpdateUser(value)});
  }

  apiUpdateUser(String url) async {
    Member member = await DBService.loadMember();
    member.img_url = url;
    await DBService.updateMember(member);
    _apiLoadMember();
  }

  _apiDeletePost(String postId) async {
    await DBService.deletePost(postId);
    _apiLoadPosts();
  }

  void showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
              child: Container(
            child: Wrap(
              children: [
                ListTile(
                  leading: new Icon(Icons.photo_library),
                  title: new Text('Gallery'),
                  onTap: () {
                    _imgFromGallery();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Camera'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Profile',
            style: TextStyle(
                color: Colors.blue, fontSize: 35, fontFamily: "Powerpunchy"),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  FireBaseService.signOut(context);
                },
                icon: Icon(
                  Icons.logout,
                  color: Colors.blue,
                ))
          ],
        ),
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              child: Column(children: [
                InkWell(
                  onTap: () {
                    showPicker(context);
                  },
                  child: Stack(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: img_url.isEmpty
                              ? Image(
                                  image: AssetImage('assets/images/user.jpg'),
                                  height: 70,
                                  width: 70,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  img_url,
                                  height: 70,
                                  width: 70,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  fullName,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Text(
                  email,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.only(left: 10),
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    'Products',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Stack(
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
                )
              ]),
            ),
            if (isLoading)
              Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ));
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
                    _apiDeletePost(post.id);
                  },
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    size: 23,
                    color: Colors.blue,
                  )),
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
}
