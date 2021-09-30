import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:haniwa/components/cloud_storage_avatar.dart';

class UserPageHeader extends StatelessWidget {
  const UserPageHeader({
    Key key,
    @required this.badgeCount,
  }) : super(key: key);
  final Map<String, dynamic> badgeCount;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final user = FirebaseAuth.instance.currentUser;
    final uid = user.uid;
    final name = user.displayName;

    return ListTile(
      leading: CloudStorageAvatar(
        path: 'versions/v2/users/$uid/icon.png',
        radius: width * 0.06,
      ),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: width * 0.05,
          ),
        ),
      ),
      subtitle: Row(
        children: [
          Icon(Icons.military_tech, color: Color.fromRGBO(255, 221, 58, 1)),
          Text(badgeCount['2'].toString()),
          SizedBox(width: 10),
          Icon(Icons.military_tech, color: Color.fromRGBO(191, 191, 191, 1)),
          Text(badgeCount['1'].toString()),
          SizedBox(width: 10),
          Icon(Icons.military_tech, color: Color.fromRGBO(227, 168, 143, 1)),
          Text(badgeCount['0'].toString()),
          SizedBox(width: 10),
        ],
      ),
      trailing: Icon(Icons.more_horiz),
    );
  }
}
