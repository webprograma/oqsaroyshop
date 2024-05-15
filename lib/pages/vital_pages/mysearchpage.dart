import 'package:flutter/material.dart';
import 'package:instaclone/additional/member_model.dart';
import 'package:instaclone/servise/dbs_service.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../additional/member_model.dart';

class MySearchPage extends StatefulWidget {
  static final String id = 'fiei';
  const MySearchPage({super.key});

  @override
  State<MySearchPage> createState() => _MySearchPageState();
}

class _MySearchPageState extends State<MySearchPage> {
  bool isLoading = false;
  var searchController = TextEditingController();
  List<Member> items = [];
  void _apiSearchMember(String keyword) {
    setState(() {
      isLoading = true;
    });
    DBService.searchVendors(keyword).then((users) => {
          _responseSearchMember(users),
        });
  }

  void _responseSearchMember(List<Member> members) {
    setState(() {
      items = members;
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiSearchMember("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Search',
            style: TextStyle(
                color: Colors.blue, fontSize: 35, fontFamily: "Powerpunchy"),
          ),
        ),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.all(1),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.search),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search',
                          ),
                        ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return itemOfPost(items[index]);
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }

  Widget itemOfPost(Member member) {
    return Container(
        child: Column(
      children: [
        Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(70),
                        border: Border.all(
                          width: 1.5,
                          color: Colors.blue,
                        ), // Border.all
                      ), // BoxDecoration
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(22.5),
                          child: member.img_url.isEmpty
                              ? Image(
                                  image: AssetImage("assets/images/user.jpg"),
                                  width: 45,
                                  height: 45,
                                  fit: BoxFit.cover) // Image
                              : Image.network(
                                  member.img_url,
                                  width: 45,
                                  height: 45,
                                  fit: BoxFit.cover,
                                )),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member.name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(member.email),
                      ],
                    )
                  ],
                ),
                InkWell(
                  onTap: () {
                    _makePhoneCall(member.phoneNumber);
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
              ],
            ),
          ],
        )
      ],
    ));
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
}
