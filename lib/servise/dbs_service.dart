import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instaclone/additional/member_model.dart';
import 'package:instaclone/additional/model.dart';
import 'package:instaclone/additional/utils.dart';
import 'package:instaclone/servise/firebase_servise.dart';

class DBService {
  static final firestore = FirebaseFirestore.instance;
  static String folder_users = "users";
  static String folder_basket = "basket";
  static String folder_posts = "posts";
  static String folder_feeds = "feeds";
  static Future storeMember(Member member, bool isCustomer) async {
    member.uid = FireBaseService.currentId();
    member.isCustomer = isCustomer;
    Map<String, String> params = await Utils.deviceParams();
    print(params.toString());
    member.device_id = params["device_id"]!;
    member.device_type = params["device_type"]!;
    member.device_token = params["device_token"]!;
    return firestore
        .collection(folder_users)
        .doc(member.uid)
        .set(member.toJson());
  }

  static Future<Member> loadMember() async {
    String uid = FireBaseService.currentId();
    var value = await firestore.collection(folder_users).doc(uid).get();
    Member member = Member.fromJson(value.data()!);
    return member;
  }

  static Future updateMember(Member member) async {
    String uid = FireBaseService.currentId();
    return firestore.collection(folder_users).doc(uid).update(member.toJson());
  }

  static Future<List<Member>> searchVendors(String keyword) async {
    List<Member> member = [];
    String uid = FireBaseService.currentId();
    var querySnapshot = await firestore
        .collection(folder_users)
        .orderBy("email")
        .startAt([keyword]).get();
    print(querySnapshot.docs.length);
    querySnapshot.docs.forEach((result) {
      Member newMember = Member.fromJson(result.data());
      if (newMember.uid != uid && newMember.isCustomer == false) {
        member.add(newMember);
      }
    });
    return member;
  }

  static Future<Post> storePost(Post post) async {
    Member me = await loadMember();
    post.uid = me.uid;
    post.fullname = me.name;
    post.img_user = me.img_url;
    post.date = Utils.currentDate();
    String postId = firestore
        .collection(folder_users)
        .doc(me.uid)
        .collection(folder_posts)
        .doc()
        .id;
    post.id = postId;
    await firestore
        .collection(folder_users)
        .doc(me.uid)
        .collection(folder_posts)
        .doc(postId)
        .set(post.toJson());
    return post;
  }

  static Future<Post> storeFeed(Post post) async {
    String uid = FireBaseService.currentId();
    await firestore
        .collection(folder_users)
        .doc(uid)
        .collection(folder_feeds)
        .doc(post.id)
        .set(post.toJson());
    return post;
  }

  static Future<List<Post>> loadPosts() async {
    List<Post> posts = [];
    String uid = FireBaseService.currentId();
    var querySnapshot = await firestore
        .collection(folder_users)
        .doc(uid)
        .collection(folder_posts)
        .get();
    querySnapshot.docs.forEach((result) {
      posts.add(Post.fromJson(result.data()));
    });
    return posts;
  }

  static Future<List<Post>> loadMainFeeds() async {
    List<Post> posts = [];
    String uid = FireBaseService.currentId();
    var querySnapshot = await firestore.collectionGroup(folder_feeds).get();

    querySnapshot.docs.forEach((doc) {
      posts.add(Post.fromJson(doc.data()));
    });

    return posts;
  }

  static Future likePost(Post post, bool like) async {
    String uid = FireBaseService.currentId();
    post.liked = like;

    await firestore
        .collection(folder_users)
        .doc(uid)
        .collection(folder_feeds)
        .doc(post.id)
        .set(post.toJson());

    // if (uid == post.uid) {
    //   await firestore
    //       .collection(folder_users)
    //       .doc(uid)
    //       .collection(folder_posts)
    //       .doc(post.id)
    //       .set(post.toJson());
    // }
  }

  static Future<List<Post>> loadLike() async {
    String uid = FireBaseService.currentId();
    List<Post> posts = [];
    var query = await firestore
        .collection(folder_users)
        .doc(uid)
        .collection(folder_feeds)
        .where("liked", isEqualTo: true)
        .get();

    query.docs.forEach((result) {
      Post post = Post.fromJson(result.data());
      if (post.uid == uid) post.mine = true;
      posts.add(post);
    });
    return posts;
  }

  static Future<void> deletePost(String postId) async {
    String uid = FireBaseService.currentId();
    await firestore
        .collection(folder_users)
        .doc(uid)
        .collection(folder_posts)
        .doc(postId)
        .delete();
    await firestore
        .collection(folder_users)
        .doc(uid)
        .collection(folder_feeds)
        .doc(postId)
        .delete();
  }
}
