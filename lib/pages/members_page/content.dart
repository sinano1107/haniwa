import 'package:flutter/material.dart';
import 'package:haniwa/models/member.dart';
import 'package:haniwa/components/cloud_storage_avatar.dart';

class MembersPageContent extends StatelessWidget {
  const MembersPageContent({
    Key key,
    @required this.members,
  }) : super(key: key);
  final List<Member> members;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Column(
        children: List.generate(
          members.length,
          (index) => ListTile(
            leading: CloudStorageAvatar(
              path: 'versions/v2/users/${members[index].uid}/icon.png',
            ),
            title: Text(members[index].name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: width * 0.07,
                ),
                SizedBox(width: width * 0.01),
                Text(
                  members[index].star.toString(),
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: width * 0.06,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
