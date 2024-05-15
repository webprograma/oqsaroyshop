import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaclone/additional/member_model.dart';
import 'package:instaclone/additional/model.dart';
import 'package:instaclone/pages/vital_pages/mymainpage.dart';
import 'package:instaclone/servise/dbs_service.dart';
import 'package:instaclone/servise/storage_servise.dart';

class UploadPage extends StatefulWidget {
  static final String id = 'upload';
  final PageController? pageController;
  UploadPage({super.key, this.pageController});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  uploadNewPost() {
    String caption = captionController.text.toString().trim();
    if (caption.isEmpty) return;
    if (_image == null) return;
    _apiPostImage();
  }

  _apiLoadMember() {
    DBService.loadMember().then((value) => {showMemberInfo(value)});
  }

  String phoneNumber = "";
  showMemberInfo(Member member) {
    setState(() {
      phoneNumber = member.phoneNumber;
    });
  }

  void _apiPostImage() {
    setState(() {
      isLoading = true;
    });
    FileService.uploadPostImage(_image!).then((downloadUrl) => {
          _resPostImage(downloadUrl),
        });
  }

  void _resPostImage(String downloadUrl) {
    String caption = captionController.text.toString().trim();
    String price = priceController.text.toString().trim();
    Post post = Post(caption, downloadUrl, price, phoneNumber);
    _apiStorePost(post);
  }

  void _apiStorePost(Post post) async {
// Post to posts
    Post posted = await DBService.storePost(post);
// Post to feeds
    DBService.storeFeed(posted).then((value) => {
          _moveToFeed(),
        });
  }

  _moveToFeed() {
    widget.pageController!
        .animateToPage(0, duration: Duration(seconds: 1), curve: Curves.easeIn);
  }

  ImagePicker picker = ImagePicker();
  TextEditingController captionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  File? _image;
  _imgFromGallery() async {
    XFile? image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _image = File(image!.path);
    });
  }

  _imgFromCamera() async {
    XFile? image =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      _image = File(image!.path);
    });
  }

  bool isLoading = false;
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
          'Upload',
          style: TextStyle(
              color: Colors.blue, fontSize: 35, fontFamily: "Powerpunchy"),
        ),
        actions: [
          IconButton(
              onPressed: () {
                uploadNewPost();
              },
              icon: Icon(
                Icons.upload,
                color: Colors.blue,
                size: 25,
              ))
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      showPicker(context);
                    },
                    child: Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 2,
                        color: Colors.grey.withOpacity(0.4),
                        child: _image == null
                            ? Center(
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                              )
                            : Stack(
                                children: [
                                  Image.file(
                                    _image!,
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                  Container(
                                      width: double.infinity,
                                      color: Colors.black12,
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _image = null;
                                                });
                                              },
                                              icon: Icon(
                                                Icons.highlight_remove,
                                                size: 30,
                                                color: Colors.white,
                                              ))
                                        ],
                                      ))
                                ],
                              )),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, right: 10, left: 10),
                    child: TextField(
                      controller: captionController,
                      style: TextStyle(color: Colors.black),
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 5,
                      decoration: InputDecoration(
                          hintText: 'Caption',
                          hintStyle:
                              TextStyle(fontSize: 17, color: Colors.black38)),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, right: 10, left: 10),
                    child: TextField(
                      controller: priceController,
                      style: TextStyle(color: Colors.black),
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 5,
                      decoration: InputDecoration(
                          hintText: 'Price',
                          hintStyle:
                              TextStyle(fontSize: 17, color: Colors.black38)),
                    ),
                  )
                ],
              ),
            ),
          ),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
