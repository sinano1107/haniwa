import 'package:flutter/material.dart';

class PleaseUpdatePage extends StatelessWidget {
  static const id = 'please_update';
  const PleaseUpdatePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final PleaseUpdateArguments args =
        ModalRoute.of(context).settings.arguments;

    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'アプリのバージョンが低いため利用できません\n最新のバージョンへとアップデートしてください',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Center(
            child: Text(
              '現在のバージョン:${args.version}\nサポートしている最低のバージョン:${args.minVersion}',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class PleaseUpdateArguments {
  PleaseUpdateArguments({
    @required this.version,
    @required this.minVersion,
  });
  final String version;
  final String minVersion;
}
