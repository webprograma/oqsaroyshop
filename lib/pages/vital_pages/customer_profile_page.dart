import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaclone/additional/member_model.dart';
import 'package:instaclone/additional/model.dart';
import 'package:instaclone/servise/dbs_service.dart';
import 'package:instaclone/servise/firebase_servise.dart';
import 'package:instaclone/servise/storage_servise.dart';

class CustomerProfilePage extends StatefulWidget {
  static final String id = 'sjcbwj';
  const CustomerProfilePage({super.key});

  @override
  State<CustomerProfilePage> createState() => _CustomerProfilePageState();
}

class _CustomerProfilePageState extends State<CustomerProfilePage> {
  bool isLoading = false;

  String fullName = "";
  String email = "";
  String img_url = "";

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
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      showPicker(context);
                    },
                    child: Stack(
                      children: [
                        Container(
                          height: 300,
                          width: 300,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(150),
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
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    fullName,
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    email,
                    style: TextStyle(fontSize: 25),
                  ),
                ],
              ),
            ),
            if (isLoading)
              Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ));
  }
}
